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
        myFormatter.dateStyle = .short
        myFormatter.timeStyle = .short
        
        if timeIn == nil {
            return "timer not started"
        } else {
            return myFormatter.string(from: timeIn!)
        }
        
    }
    
    func returnTimeOutString () -> String {
        
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = .short
        myFormatter.timeStyle = .short
        
        if self.timeOut == nil {
            return "timer running"
        } else {
            return myFormatter.string(from: timeOut!)
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
