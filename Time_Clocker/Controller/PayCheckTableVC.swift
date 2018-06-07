//
//  PayCheckTableVC.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 6/2/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit
import SwipeCellKit

class PayCheckTableVC: UIViewController {

    @IBOutlet weak var payCheckTable: UITableView!
    @IBOutlet weak var segVerifiedSelected: UISegmentedControl!
    
    //array of paycehcks that will be used for my table view...
    var paychecks = [Paycheck]()
    
    //file path where our custom plist is going to be to write our data
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Paychecks.plist")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        payCheckTable.delegate = self
        payCheckTable.dataSource = self
        
        print("view did load paycheck table...")
        print(dataFilePath!)
        
        loadData()
        payCheckTable.reloadData()
        
        
        //my testing database...
        if paychecks.count == 0 {
            let myPaycheck1 = Paycheck(employeerName: "Largo Medical")
            myPaycheck1._payPeriodStart = Date(timeIntervalSince1970: 50000)
            myPaycheck1._payPeriodEnd = Date(timeIntervalSince1970: 51000)
            myPaycheck1._payDate = Date(timeIntervalSince1970: 52000)
            
            let timepunch1 = TimePunch(timeInPunch: Date(timeIntervalSince1970: 50100))
            let timepunch2 = TimePunch(timeInPunch: Date(timeIntervalSince1970: 55000))
            let timepunches: [TimePunch] = [timepunch1, timepunch2]
            myPaycheck1._timePunches = timepunches
            paychecks.append(myPaycheck1)

            let myPaycheck2 = Paycheck(employeerName: "Palms of Pasadena")
            myPaycheck2._payPeriodStart = Date(timeIntervalSince1970: 53000)
            myPaycheck2._payPeriodEnd = Date(timeIntervalSince1970: 54000)
            myPaycheck2._payDate = Date(timeIntervalSince1970: 55000)
            paychecks.append(myPaycheck2)

            let myPaycheck3 = Paycheck(employeerName: "Largo Medical")
            myPaycheck3._payPeriodStart = Date(timeIntervalSince1970: 56000)
            myPaycheck3._payPeriodEnd = Date(timeIntervalSince1970: 57000)
            myPaycheck3._payDate = Date(timeIntervalSince1970: 58000)
            paychecks.append(myPaycheck3)

            let myPaycheck4 = Paycheck(employeerName: "Select Therapy")
            myPaycheck4._payPeriodStart = Date(timeIntervalSince1970: 60000)
            myPaycheck4._payPeriodEnd = Date(timeIntervalSince1970: 61000)
            myPaycheck4._payDate = Date(timeIntervalSince1970: 62000)
            paychecks.append(myPaycheck4)
        }
        
    }
    
    func loadData() {
        
        //loads data saved as plist in the update table method...
        if let data = try? Data(contentsOf: dataFilePath!) {
            print("we must have data")
            let decoder = PropertyListDecoder()
            do {
                paychecks = try decoder.decode([Paycheck].self, from: data)
                print("i think it loaded")
            } catch {
                print("error decoding \(error)")
            }
        } else {
            print("no data")
        }
        
        payCheckTable.reloadData()
        
    }
    
    
    func saveData() {
        //need to save data
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(paychecks)
            try data.write(to: dataFilePath!)
            print("I think it wrote")
        } catch {
            print("Error while writing \(error)")
        }
    }
    
    
    

    @IBAction func createNewPaycheckPressed(_ sender: UIButton) {
        
        print("create new paycheck pressed...")
        
        //for now temp we will save data to see if it errors
        saveData()
        
    }
    


}

extension PayCheckTableVC: UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //have to cast it as a TimeCell, otherwise it assumes it is a UITableViewCell.  Time cell inherits from the swipe cell now
        if let myCell = payCheckTable.dequeueReusableCell(withIdentifier: "payCell") as? PayTableCell {

            myCell.lblEmployeersName.text = paychecks[indexPath.row].employeer
            myCell.lblWeekStarting.text = paychecks[indexPath.row].payPeriodStart
            myCell.lblWeekEnding.text = paychecks[indexPath.row].payPeriodEnd
            myCell.lblPayDate.text = paychecks[indexPath.row].payDate
            myCell.lblHoursWorked.text = "32hr 15min"
            
            if paychecks[indexPath.row].payCheckIsVefified {
                myCell.lblVerified.text = "Is Verified"
            } else {
                myCell.lblVerified.text = "Not Verified"
            }
            
            //myCell.updateCell(employeersName: employeersName, weekStarting: weekStarting, weekEnding: weekEnding, payDate: payDate, hoursWorked: hoursWorked, payIsVerified: payIsVerified)
            
            //this is assigning the cell as the delegate
            myCell.delegate = self
            return myCell
        } else {
            //if the cell would fail to cast as a TimeCell I would send a blank one.
            return TimeCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paychecks.count
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let addAction = SwipeAction(style: .destructive, title: "Add Time") { action, indexPath in
            // handle action by updating model with deletion
            //print("delete action initiated on \(indexPath.section), \(indexPath.row)")
            print("add Action called")
            //self.timePunches.remove(at: indexPath.row)
            //self.updateTable()
        }
        
        let editAction = SwipeAction(style: .default, title: "Edit Info") { action, indexPath in
            
            print("edit Action called")
            //self.isInUpdateMode = true
            //this triggers the segue and updates the indexpath that needs to be updated upon return
            //self.indexToUpdate = indexPath.row
            //self.performSegue(withIdentifier: "segMainVCtoDateVC", sender: nil)
            
        }
        
        // customize the action appearance
        //deleteAction.image = UIImage(named: "delete")
        //updateAction.image = UIImage(named: "update")
        
        return [addAction, editAction]
    }
    
    
}
