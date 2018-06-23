//
//  TimePunch.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 4/23/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import Foundation
import RealmSwift

class TimePunch: Object{
    
    //This will be guarenteed since it is needed to start an instance
    @objc dynamic var timeIn: Date? = nil
    @objc dynamic var timeOut: Date? = nil
    
//    init(timeInPunch: Date) {
//        //was the date ever intialized ? Date()
//        //super.init()
//        timeIn = timeInPunch
//    }
    
    func returnTimeInString () -> String {
        let myFormatter = DateFormatter()
        //let format = "EE-MMM-dd-yyyy"
        let format = "HH:mm EE-MMM-dd-yyyy"
        myFormatter.dateFormat = format
        
        if timeIn == nil {
            return "timer not started"
        } else {
            let timeInStr = "Time in..."
            let timeStr = myFormatter.string(from: timeIn!)
            return timeInStr + timeStr
        }
        
    }
    
    func returnTimeOutString () -> String {
        
        let myFormatter = DateFormatter()
        let format = "HH:mm EE-MMM-dd-yyyy"
        myFormatter.dateFormat = format
        
        if self.timeOut == nil {
            return "timer running"
        } else {
            let timeOutStr = "Time out..."
            let timeStr = myFormatter.string(from: timeOut!)
            return timeOutStr + timeStr
        }
        
    }
    
    func returnTotalTime() -> TimeInterval {
        if let calcTime = timeOut?.timeIntervalSince(timeIn!) {
            return calcTime
        } else {
            return 0
        }
    }
    
    
    func returnTotalTimeAsString() -> String {
        
        //time out may be nil so before we calc we have to ensure against this...
        
        if let calcTime = timeOut?.timeIntervalSince(timeIn!) {
            let hours: Int = Int(calcTime / 3600)
            let minutes: Int = Int(calcTime / 60) - (hours * 60)
            return ("\(hours)Hrs \(minutes)Min.")
        } else {
            return "Time Running"
        }
    }
    
}
