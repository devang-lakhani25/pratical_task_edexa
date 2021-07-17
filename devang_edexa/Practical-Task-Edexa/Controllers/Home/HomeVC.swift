//
//  HomeVC.swift
//  Practical-Task-Edexa
//
//  Created by Devang Lakhani  on 7/17/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet var btnTabs : [UIButton]!
    @IBOutlet weak var tblView  : UITableView!
    var actInd:UIActivityIndicatorView!
    
    
    var statusType : EnumCity = .all
    var arrCityData : [CityEmployeeData] = []
    
    var arrChicago : [CityEmployeeData]{
        return arrCityData.filter{$0.city == "Chicago"}
    }
    
    var arrNewYork : [CityEmployeeData]{
        return arrCityData.filter{$0.city == "NewYork"}
    }
    
    var arrLosAngels : [CityEmployeeData]{
        return arrCityData.filter{$0.city == "Los Angeles"}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        prepareUI()
    }
}

//MARK:- Others Methods
extension HomeVC{
    func prepareUI(){
        tblView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tblView.separatorStyle = .none
        self.view.layoutIfNeeded()
    }
    
    @IBAction func btnTabTapped(_ sender: UIButton){
        self.statusType = EnumCity(val: sender.tag)
        setSelectedIndex(index: sender.tag)
        tblView.reloadData()
    }
    
    func setSelectedIndex(index: Int){
        for (idx,btn) in self.btnTabs.enumerated(){
            btn.setTitleColor( idx == index ? #colorLiteral(red: 0.2901960784, green: 0.6, blue: 0.8078431373, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        }
        self.view.layoutIfNeeded()
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch statusType {
        case .all:
            return arrCityData.count
        case .chicago:
            return arrChicago.count
        case .newYork:
            return arrNewYork.count
        case .LosAngles:
            return arrLosAngels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HomeTblCell
        
        cell = tblView.dequeueReusableCell(withIdentifier: "cell") as! HomeTblCell
        cell.parentVc = self
        if statusType == .all{
            cell.prepareData(data: arrCityData[indexPath.row], type: statusType)
        }else if statusType == .chicago{
            cell.prepareData(data: arrChicago[indexPath.row], type: statusType)
        }else if statusType == .newYork{
            cell.prepareData(data: arrNewYork[indexPath.row], type: statusType)
        }else{
            cell.prepareData(data: arrLosAngels[indexPath.row], type: statusType)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}


//MARK:- WEB Call Methods
extension HomeVC{
    func getData(){
        showPopup(title: "Loading", msg: "Please wait data is Loading")
        DLWebCall.call.getHomeData {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            
            if statusCode == 200, let dict = json as? [NSDictionary]{
                for result in dict{
                    let objData = CityEmployeeData(dict: result)
                    weakSelf.arrCityData.append(objData)
                }
                weakSelf.tblView.reloadData()
            }else{
                print("Error")
            }
        }
    }
}


//MARK:- Show Popup
extension HomeVC{
    func showPopup(title: String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
