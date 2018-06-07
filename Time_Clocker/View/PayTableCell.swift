//
//  payTableCell.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 6/2/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit
import SwipeCellKit

class PayTableCell: SwipeTableViewCell {
    
    @IBOutlet weak var lblEmployeersName: UILabel!
    @IBOutlet weak var lblWeekStarting: UILabel!
    @IBOutlet weak var lblWeekEnding: UILabel!
    @IBOutlet weak var lblPayDate: UILabel!
    @IBOutlet weak var lblHoursWorked: UILabel!
    @IBOutlet weak var lblVerified: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("Paytable cell View custom")
    }
    
//    func updateCell (employeersName: String, weekStarting: String, weekEnding: String, payDate: String, hoursWorked: String, payIsVerified: Bool) {
//        lblEmployeersName.text = employeersName
//        lblWeekStarting.text = weekStarting
//        lblWeekEnding.text = weekEnding
//        lblPayDate.text = payDate
//        lblHoursWorked.text = hoursWorked
//        
//        if payIsVerified == true {
//            lblVerified.text = "Paycheck is Verified"
//        } else {
//            lblVerified.text = "Paycheck Unverified"
//        }
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
