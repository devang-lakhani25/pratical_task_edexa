//
//  NSDictinaryExtension.swift
//  Practical-Task-Edexa
//
//  Created by Devang Lakhani  on 7/17/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation

extension NSDictionary{
    func getStringValue(key: String) -> String{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.stringValue
            }else if let str = any as? String{
                return str
            }
        }
        return ""
    }

}
