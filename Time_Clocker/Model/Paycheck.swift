//
//  Paycheck.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 6/2/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import Foundation

class Paycheck : Codable {
    
    var _payPeriodStart: Date?
    var _payPeriodEnd: Date?
    var _payDate: Date?
    var _employeerName: String!
    var _timePunches: [TimePunch]?
    var _payCheckIsVerified: Bool = false
    
    
    init (employeerName: String) {
        
        _employeerName = employeerName
        
    }
    
    private func returnStringOfDate (date: Date) -> String {
        
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .short
        myFormatter.timeStyle = .short
        return myFormatter.string(from:date)
        
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
