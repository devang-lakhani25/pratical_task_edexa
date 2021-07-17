//
//  HomeTblCell.swift
//  Practical-Task-Edexa
//
//  Created by Devang Lakhani  on 7/17/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class HomeTblCell: UITableViewCell {
    @IBOutlet weak var lblEmployeeName : UILabel!
    @IBOutlet weak var lblCityName : UILabel!
    @IBOutlet weak var lblCityFirstLatter : UILabel!
    
    weak var parentVc : HomeVC!
    
    func prepareData(data: CityEmployeeData, type: EnumCity){
        if type == .all{
            lblCityName.text = data.city
            lblEmployeeName.text = data.firstName + " " + data.lastname
            lblCityFirstLatter.text = "\(data.city.prefix(1))"
        }else if type == .chicago{
            lblCityName.text = data.city
            lblEmployeeName.text = data.firstName + " " + data.lastname
            lblCityFirstLatter.text = "\(data.city.prefix(1))"
        }else if type == .newYork{
            lblCityName.text = data.city
            lblEmployeeName.text = data.firstName + " " + data.lastname
            lblCityFirstLatter.text = "\(data.city.prefix(1))"
        }else{
            lblCityName.text = data.city
            lblEmployeeName.text = data.firstName + " " + data.lastname
            lblCityFirstLatter.text = "\(data.city.prefix(1))"
        }
    }
}
