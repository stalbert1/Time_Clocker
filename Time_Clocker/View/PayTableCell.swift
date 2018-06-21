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
        //print("Paytable cell View custom")
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
