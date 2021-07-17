//
//  DLWebCall.swift
//  Practical-Task-Edexa
//
//  Created by Devang Lakhani  on 7/17/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation


// MARK: Web Operation
let _baseUrl = "https://api.npoint.io/"

typealias WSBlock = (_ json: Any?, _ flag: Int) -> ()
typealias WSProgress = (Progress) -> ()?
typealias WSFileBlock = (_ path: String?, _ error: Error?) -> ()


class DLWebCall:NSObject{
    
    static var call: DLWebCall = DLWebCall()
    
    let manager: SessionManager
    var networkManager: NetworkReachabilityManager = NetworkReachabilityManager()!
    var headers: HTTPHeaders = [:]

    var paramEncode: ParameterEncoding = URLEncoding.default
    let timeOutInteraval: TimeInterval = 60
    var successBlock: (String, HTTPURLResponse?, AnyObject?, WSBlock) -> Void
    var errorBlock: (String, HTTPURLResponse?, NSError, WSBlock) -> Void
    
    override init() {
        manager = SessionManager.default
        
        // Will be called on success of web service calls.
        successBlock = { (relativePath, res, respObj, block) -> Void in
            // Check for response it should be there as it had come in success block
            if let response = res{
                kprint(items: "Response Code: \(response.statusCode)")
                kprint(items: "Response(\(relativePath)): \(String(describing: respObj))")
                
                if response.statusCode == 200 {
                    block(respObj, response.statusCode)
                } else {
                    if response.statusCode == 401{
                        block([_appName: kInternetDown] as AnyObject, response.statusCode)
                           
                    } else {
                        block(respObj, response.statusCode)
                    }
                }
            } else {
                // There might me no case this can get execute
                block(nil, 404)
            }
        }
        
        // Will be called on Error during web service call
        errorBlock = { (relativePath, res, error, block) -> Void in
            // First check for the response if found check code and make decision
            if let response = res {
                kprint(items: "Response Code: \(response.statusCode)")
                kprint(items: "Error Code: \(error.code)")
                if let data = error.userInfo["com.alamofire.serialization.response.error.data"] as? NSData {
                    let errorDict = (try? JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
                    if errorDict != nil {
                        kprint(items: "Error(\(relativePath)): \(errorDict!)")
                        block(errorDict!, response.statusCode)
                    }  else if response.statusCode == 404 {
                        block([_appName: kTokenExpire] as AnyObject, response.statusCode)
                    } else {
                        let code = response.statusCode
                        block(nil, code)
                    }
                } else if response.statusCode == 401{
                    block([_appName: kInternetDown] as AnyObject, response.statusCode)
                }else {
                    block(nil, response.statusCode)
                }
                // If response not found rely on error code to find the issue
            } else if error.code == -1009  {
                kprint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kInternetDown] as AnyObject, error.code)
                return
            }  else if error.code == 404 {
                block([_appName: kTokenExpire] as AnyObject, error.code)
            } else if error.code == -1003  {
                block([_appName: kHostDown] as AnyObject, error.code)
                return
            } else if error.code == -1001  {
                kprint(items: "Error(\(relativePath)): \(error)")
                
                block([_appName: kTimeOut] as AnyObject, error.code)
                return
            } else if error.code == 1004  {
                
                kprint(items: "Error(\(relativePath)): \(error)")
                block([_appName: kInternetDown] as AnyObject, error.code)
                return
            } else {
                
                kprint(items: "Error(\(relativePath)): \(error)")
                block(nil, error.code)
            }
        }
        super.init()
        addInterNetListner()
    }
    
    deinit {
        networkManager.stopListening()
    }
}


// MARK: Other methods
extension DLWebCall{
    func getFullUrl(relPath : String) throws -> URL{
        do{
            if relPath.lowercased().contains("http") || relPath.lowercased().contains("www"){
                return try relPath.asURL()
            }else{
                return try (_baseUrl+relPath).asURL()
            }
        }catch let err{
            throw err
        }
    }
}

// MARK: - Internet Availability
extension DLWebCall{
    func addInterNetListner(){
        networkManager.startListening()
        networkManager.listener = { (status) -> Void in
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable{
                print("No InterNet")
            }else{
                print("Internet Avail")
            }
        }
    }
    
    func isInternetAvailable() -> Bool {
        if networkManager.isReachable{
            return true
        }else{
            return false
        }
    }
}


//MARK:- Get Request
extension DLWebCall{
    func getRequest(relPath: String, param: [String: Any]?, headerParam: HTTPHeaders?, timeout: TimeInterval? = nil, block: @escaping WSBlock)-> DataRequest? {
        do{
            kprint(items: "Url: \(try getFullUrl(relPath: relPath))")
            kprint(items: "Param: \(String(describing: param))")
            var req = try URLRequest(url: getFullUrl(relPath: relPath), method: HTTPMethod.get, headers: (headerParam ?? headers))
            req.timeoutInterval = timeout ?? timeOutInteraval
            let encodedURLRequest = try paramEncode.encode(req, with: param)
            return request(encodedURLRequest).responseJSON { (resObj) in
                switch resObj.result{
                case .success:
                    if let resData = resObj.data{
                        do {
                            let res = try JSONSerialization.jsonObject(with: resData, options: []) as AnyObject
                            self.successBlock(relPath, resObj.response, res, block)
                        } catch let errParse{
                            kprint(items: errParse)
                            self.errorBlock(relPath, resObj.response, errParse as NSError, block)
                        }
                    }
                    break
                case .failure(let err):
                    kprint(items: err)
                    self.errorBlock(relPath, resObj.response, err as NSError, block)
                    break
                }
            }
        }catch let error{
            kprint(items: error)
            errorBlock(relPath, nil, error as NSError, block)
            return nil
        }
    }
}

//MARK:- Home Web Call
extension DLWebCall{
    func getHomeData(block: @escaping WSBlock){
        kprint(items: "----- Get Data -------")
        let relPath = "c4683decc7df639018f6"
        _ = getRequest(relPath: relPath, param: nil, headerParam: nil, block: block)
    }
}
