//
//  CustomTabBarView.swift
//  Practical-Task-Edexa
//
//  Created by Devang Lakhani  on 7/17/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class CustomTabBarView: UIView {
    @IBOutlet var btnsMenu : [UIButton]!
    
    var completion : ((_ index : Int) -> ()) = {_ in}
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    class func getView() -> CustomTabBarView{
        let customTabBar = UINib(nibName: "CustomTabBarView", bundle: nil).instantiate(withOwner: self, options: nil).first as! CustomTabBarView
        customTabBar.frame = CGRect(x: 0, y: (_screenSize.height - 65) - _bottomAreaSpacing, width: _screenSize.width, height: 65 + _bottomAreaSpacing)
        customTabBar.layoutIfNeeded()
        customTabBar.selectedIndexTintColor(index: 0)
        return customTabBar
    }
    
    func getSelectedIndex(completion: @escaping(Int) -> ()){
        self.completion = completion
    }
    
    func selectedIndexTintColor(index: Int){
        for btn in btnsMenu{
            btn.tintColor = btn.tag == index ? #colorLiteral(red: 0.3137254902, green: 0.3921568627, blue: 0.7843137255, alpha: 1) : .black
        }
    }
}


//MARK:- Button Action
extension CustomTabBarView{
    @IBAction func btnMenuTapped(_ sender: UIButton){
        self.selectedIndexTintColor(index: sender.tag)
        completion(sender.tag)
    }
}
