//
//  Paycheck.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 6/2/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import Foundation
import RealmSwift

class Paycheck: Object {
    
    @objc dynamic var _payPeriodStart: Date? = nil
    @objc dynamic var _payPeriodEnd: Date? = nil
    @objc dynamic var _payDate: Date? = nil
    @objc dynamic var _employeerName: String = ""
    
    //@objc dynamic var value: Class?
    //@objc dynamic var _timePunches: [TimePunch]?
    //@objc dynamic var timePunch: TimePunch?
    
    //kinda weird, why not var, seems like you could not update this list??? was a let at first...
    var timepunches = List<TimePunch>()
    
    @objc dynamic var _payCheckIsVerified: Bool = false
    
    
    //    init (employeerName: String) {
    //
    //        _employeerName = employeerName
    //
    //    }
    
    private func returnStringOfDate (date: Date) -> String {
        
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .short
        myFormatter.timeStyle = .short
        return myFormatter.string(from:date)
        
    }
    
    func returnTimeWorkedAsString () -> String {
        
        var totalTime: TimeInterval = 0
        
        for timePunch in timepunches {
            totalTime = totalTime + timePunch.returnTotalTime()
        }
        
        let hours: Int = Int(totalTime / 3600)
        let minutes: Int = Int(totalTime / 60) - (hours * 60)
        return ("\(hours)Hrs \(minutes)Min.")
        
    }
    
    func calculateHours () -> TimeInterval {
        var totalTime : TimeInterval = 0
        for timePunch in timepunches {
            totalTime = totalTime + timePunch.returnTotalTime()
        }
        return totalTime
    }
    
    var payPeriodStart: String {
        if _payPeriodStart == nil {
            return "Not Specified"
        } else {
            return returnStringOfDate(date: _payPeriodStart!)
        }
    }
    
    var payPeriodEnd: String {
        if _payPeriodEnd == nil {
            return "Not Specified"
        } else {
            return returnStringOfDate(date: _payPeriodEnd!)
        }
    }
    
    var payDate: String {
        if _payDate == nil {
            return "Not Specified"
        } else {
            return returnStringOfDate(date: _payDate!)
        }
    }
    
    var payCheckIsVefified: Bool {
        get {
            return _payCheckIsVerified
        } set {
            _payCheckIsVerified = newValue
        }
    }
    
    var employeer: String {
        get {
            return _employeerName
        }
    }
    
    
    
}
