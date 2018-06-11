//
//  STButton.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 6/9/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit

class STButton: UIButton {

    override func awakeFromNib() {
        self.layer.cornerRadius = 15.0
        self.backgroundColor = UIColor.init(red: 0.000, green: 0.239, blue: 0.961, alpha: 1.00)
        self.setTitleColor(UIColor.white, for: .normal)
        self.clipsToBounds = true
    }

}
