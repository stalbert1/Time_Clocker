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
    var selectionMade : TimePunch = TimePunch(timeInPunch: Date())
    
    var lastDateSelected : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let lastDate = UserDefaults.standard.object(forKey: "lastSelectedDate")
        
        if let lastSelectedDateVerified = lastDate as? Date {
            pkrDateSelectionFrom.setDate(lastSelectedDateVerified, animated: true)
            pkrDateSelectionTo.setDate(lastSelectedDateVerified, animated: true)
        }
        
        print("view did appear")
        
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

