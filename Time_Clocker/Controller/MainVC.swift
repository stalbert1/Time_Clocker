//
//  MainVC.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 4/23/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit
import SwipeCellKit

class MainVC: UIViewController, receivePunch {
  
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var btnTimeStart: UIButton!
    @IBOutlet weak var btnTimeStop: UIButton!
    @IBOutlet weak var lblTotalTime: UILabel!
    
    var timePunches = [TimePunch]()
    
    //file path where our custom plist is going to be to write our data
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TimePunches.plist")
    
    var totalTime : TimeInterval = 0
    
    var isInUpdateMode = false
    var indexToUpdate : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        loadData()
        updateTable()
        
    }
    
    func loadData() {
        
        //loads data saved as plist in the update table method...
        if let data = try? Data(contentsOf: dataFilePath!) {
            print("we must have data")
            let decoder = PropertyListDecoder()
            do {
                timePunches = try decoder.decode([TimePunch].self, from: data)
                print("i think it loaded")
            } catch {
                print("error decoding \(error)")
            }
        }
        
    }

    @IBAction func timeStartPressed(_ sender: UIButton) {
        
        btnTimeStart.isEnabled = false
        btnTimeStop.isEnabled = true
        let currentPunch = TimePunch(timeInPunch: Date())
        timePunches.append(currentPunch)
        updateTable()
        
    }
    
    @IBAction func timeStopPressed(_ sender: UIButton) {
        
        btnTimeStart.isEnabled = true
        btnTimeStop.isEnabled = false
        timePunches[timePunches.count-1].timeOut = Date()
        updateTable()
        
    }
    
    @IBAction func enterTimeManuallyPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "segMainVCtoDateVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segMainVCtoDateVC" {
            let nextVC = segue.destination as? DateSelectionVC
            nextVC?.delegate = self
        }
    }
    
    func calculateTotal () {
        
        totalTime = 0
        
        for timePunch in timePunches {
            //add all totals and reassing to totaltime
            if timePunch.timeOut != nil {
                totalTime = totalTime + timePunch.timeOut!.timeIntervalSince(timePunch.timeIn)
            }
        }
    
    }
    
    func updateTable () {
        
        calculateTotal()
        let hours: Int = Int(totalTime / 3600)
        let minutes: Int = Int(totalTime / 60) - (hours * 60)
        lblTotalTime.text = ("\(hours)Hrs \(minutes)Min.")
        mainTableView.reloadData()
        
        //need to save data
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(timePunches)
            try data.write(to: dataFilePath!)
            print("I think it wrote")
        } catch {
            print("Error while writing \(error)")
        }
        
    }
    
    //delegate method for what happens when a punch is received from the DateSelectionVC
    func punchReceived(punch: TimePunch) {
        
        if isInUpdateMode {
            print("need to update the punch that was sent back.")
            if let index : Int = indexToUpdate {
                print(index)
                timePunches.remove(at: index)
                timePunches.insert(punch, at: index)
            }
        } else {
            timePunches.append(punch)
        }
        
        updateTable()
        isInUpdateMode = false
    }
    
    
}

extension MainVC: UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    
    //mandatory code for SwipeViewCell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("delete action initiated on \(indexPath.section), \(indexPath.row)")
            self.timePunches.remove(at: indexPath.row)
            self.updateTable()
        }
        
        let updateAction = SwipeAction(style: .default, title: "Update") { action, indexPath in
            
            print("updateAction triggered")
            self.isInUpdateMode = true
            //this triggers the segue and updates the indexpath that needs to be updated upon return
            self.indexToUpdate = indexPath.row
            self.performSegue(withIdentifier: "segMainVCtoDateVC", sender: nil)
            
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        updateAction.image = UIImage(named: "update")
        
        return [deleteAction, updateAction]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //timePunches.count
        return timePunches.count
    }
    
    //deque cell is called "cell"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //have to cast it as a TimeCell, otherwise it assumes it is a UITableViewCell.  Time cell inherits from the swipe cell now
        if let myCell = mainTableView.dequeueReusableCell(withIdentifier: "cell") as? TimeCell {
            myCell.lblTimeStart.text = timePunches[indexPath.row].returnTimeInString()
            myCell.lblTimeStop.text = timePunches[indexPath.row].returnTimeOutString()
            myCell.lblTimeOfPunch.text = timePunches[indexPath.row].returnTotalTimeAsString()
            
            //this is assigning the cell as the delegate
            myCell.delegate = self
            return myCell
        } else {
            //if the cell would fail to cast as a TimeCell I would send a blank one.
            return TimeCell()
        }
        
    }
    
}

