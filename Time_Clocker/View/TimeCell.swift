//
//  TimeCell.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 4/23/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit
import SwipeCellKit

class TimeCell: SwipeTableViewCell {

    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblTimeStop: UILabel!
    @IBOutlet weak var lblTimeOfPunch: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
