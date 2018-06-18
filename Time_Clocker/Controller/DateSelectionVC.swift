//
//  DateSelectionVC.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 4/23/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit

//protocol to pass data back
protocol receivePunch {
    func punchReceived (punch: TimePunch)
}

class DateSelectionVC: UIViewController {

    
    @IBOutlet weak var pkrDateSelectionFrom: UIDatePicker!
    @IBOutlet weak var pkrDateSelectionTo: UIDatePicker!
    
    var delegate : receivePunch?
    
    //would init to now as time in and nil as time out
    var selectionMade : TimePunch = TimePunch()
    
    var lastDateSelected : Date?
    
    //this will be sent if the user entered from the update time punch, at which time the 2 date wheels will go to the sent value as opposed to the last stored time.
    var timePunchToEdit: TimePunch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionMade.timeIn = Date()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if timePunchToEdit == nil {
            //we know we are not in update mode so lets restore the last selected dates...
            let lastDate = UserDefaults.standard.object(forKey: "lastSelectedDate")
            
            if let lastSelectedDateVerified = lastDate as? Date {
                pkrDateSelectionFrom.setDate(lastSelectedDateVerified, animated: true)
                pkrDateSelectionTo.setDate(lastSelectedDateVerified, animated: true)
            }
            
        } else {
            //we know the user sent a time punch to edit, so set the 2 wheels to the sent times...
            //at this point we know that timein or timeout cant be nil, because when they were created from the date selection the wheels always have a default value...
            pkrDateSelectionFrom.setDate((timePunchToEdit?.timeIn)!, animated: true)
            pkrDateSelectionTo.setDate((timePunchToEdit?.timeOut)!, animated: true)
            
        }
    }
    
    
    @IBAction func timeInDateChanged(_ sender: UIDatePicker) {
        
        lastDateSelected = pkrDateSelectionFrom.date
        pkrDateSelectionTo.setDate(lastDateSelected!, animated: true)
        
    }
    
    @IBAction func timeOutDateChanged(_ sender: UIDatePicker) {
        
 //       lastDateSelected = pkrDateSelectionTo.date
//        pkrDateSelectionFrom.setDate(lastDateSelected, animated: true)
    }
    
    @IBAction func selectDateButtonPressed(_ sender: UIButton) {
        
        selectionMade.timeOut = pkrDateSelectionTo.date
        selectionMade.timeIn = pkrDateSelectionFrom.date
        
        dismiss(animated: true, completion: nil)
        
        //pass the TimePunch object back to the other vc using the delegate method.
        delegate?.punchReceived(punch: selectionMade)
        
        lastDateSelected = pkrDateSelectionTo.date
        //storing as a user default
        UserDefaults.standard.set(lastDateSelected, forKey: "lastSelectedDate")
        
    }
    
}

