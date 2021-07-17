//
//  CityEmployeeData.swift
//  Practical-Task-Edexa
//
//  Created by Devang Lakhani  on 7/17/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

enum EnumCity{
    case all
    case chicago
    case newYork
    case LosAngles
    
    init(val : Int) {
        if val == 0{
            self = .all
        }else if val == 1{
            self = .chicago
        }else if val == 2{
            self = .newYork
        }else{
            self = .LosAngles
        }
    }
}

class CityEmployeeData{
    var id : String
    var city : String
    var lastname: String
    var firstName: String
    
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        city = dict.getStringValue(key: "city")
        lastname = dict.getStringValue(key: "last_name")
        firstName = dict.getStringValue(key: "first_name")
    }
}



