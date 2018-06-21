//
//  PayCheckTableVC.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 6/2/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class PayCheckTableVC: UIViewController {
    
    @IBOutlet weak var payCheckTable: UITableView!
    @IBOutlet weak var segVerifiedSelected: UISegmentedControl!
    
    let realm = try! Realm()
    
    //Results of paycehcks that will be used for my table view...
    var paychecks: Results<Paycheck>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payCheckTable.delegate = self
        payCheckTable.dataSource = self
        
        paychecks = realm.objects(Paycheck.self)
        loadData()
        
    }
    
    @IBAction func verifiedSegChanged(_ sender: UISegmentedControl) {
        loadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        
        //Sorts and shows data in realm database based on selected index of verified or not.
        if segVerifiedSelected.selectedSegmentIndex == 0 {
            
            //have to start off by showing all then filtering down from that point.
            paychecks = realm.objects(Paycheck.self)
            paychecks = paychecks.filter("_payCheckIsVerified == %@", false).sorted(byKeyPath: "_payDate", ascending: true)
        } else {
            paychecks = realm.objects(Paycheck.self)
            //print("Verified selected")
            paychecks = paychecks.filter("_payCheckIsVerified == %@", true).sorted(byKeyPath: "_payDate", ascending: true)
        }
        
        //this will load all objects in the database.  Not using this for now.  Could put an extra seg controller segment and do this as a 3rd choice...
        //paychecks = realm.objects(Paycheck.self)
        
        payCheckTable.reloadData()
    }
    
    func dateString (date: Date?) -> String {
        
        let myFormatter = DateFormatter()
        let format = "EE-MMM-dd-yy"
        myFormatter.dateFormat = format

        if date == nil {
            return "No Date"
        } else {
            return myFormatter.string(from: date!)
        }
    }
    
    
    @IBAction func createNewPaycheckPressed(_ sender: UIButton) {
        
        //print("create new paycheck pressed...")
        //sending with no sender.  If update is selected will need to send with the Paycheck object selected.
        performSegue(withIdentifier: "showPayDetails", sender: nil)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //this will occur slightly before the actual seague...
        //print("code to perform when transition is made...")
        if segue.identifier == "showPunches" {
            if let destination = segue.destination as? MainVC {
                if let payCheck = sender as? Paycheck {
                    destination.payCheckToEdit = payCheck
                }
            }
        }
        
        if segue.identifier == "showPayDetails" {
            //print("segue performed item sent is \(String(describing: sender))")
            //When seague is performed from the create paycheck button will send nil
            //When segue is performed through update selection on the swipe cell it will send the optional paycheck object
            //var paycheckDetailsToEdit: Paycheck? variable in the receivng VC
            if let destination = segue.destination as? PayCheckCreatorVC {
                if let payCheck = sender as? Paycheck {
                    destination.paycheckDetailsToEdit = payCheck
                }
            }
        }
        
        
        
    }
    
}

extension PayCheckTableVC: UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //have to cast it as a TimeCell, otherwise it assumes it is a UITableViewCell.  Time cell inherits from the swipe cell now
        if let myCell = payCheckTable.dequeueReusableCell(withIdentifier: "payCell") as? PayTableCell {
            
            myCell.lblEmployeersName.text = paychecks[indexPath.row].employeer
            
            myCell.lblWeekStarting.text = "Week Starting \(dateString(date: paychecks[indexPath.row]._payPeriodStart))"
            myCell.lblWeekEnding.text = "Week Ending \(dateString(date: paychecks[indexPath.row]._payPeriodEnd))"
            myCell.lblPayDate.text = "Pay Date \(dateString(date: paychecks[indexPath.row]._payDate))"
            
            myCell.lblHoursWorked.text = paychecks[indexPath.row].returnTimeWorkedAsString()
            
            if paychecks[indexPath.row].payCheckIsVefified {
                myCell.lblVerified.text = "Is Verified"
            } else {
                myCell.lblVerified.text = "Not Verified"
            }
            
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
        guard orientation == .right else { //return nil }
        
            //since you are not returning nil it will allow a left direction...
            let verifyPay = SwipeAction(style: .default, title: "Verify Pay") { (action, indexPath) in
                //print("Verify checked")
                
                if let itemToUpdate = self.paychecks?[indexPath.row] {
                    
                    do {
                        try self.realm.write {
                            //will make the boolean opposite of what it currently is
                            itemToUpdate._payCheckIsVerified = !itemToUpdate._payCheckIsVerified
                        }
                    } catch {
                            print("error changing to verified\(error)")
                        }
                    }
                
               
                self.loadData()
            }
            
            //customize the verify checked apperance or pic here...
            
            //light blue to match inside table color
            verifyPay.backgroundColor = UIColor(red: 0.749, green: 0.839, blue: 0.937, alpha: 1.00)
            verifyPay.hidesWhenSelected = true
            verifyPay.textColor = UIColor.black
            
            return [verifyPay]
        }
        
        
        
        let editPaycheck = SwipeAction(style: .default, title: "Edit Info") { (action, indexPath) in
            
            //print("edit info pressed")
            self.performSegue(withIdentifier: "showPayDetails", sender: self.paychecks[indexPath.row])
            
        }
        
        let addAction = SwipeAction(style: .default, title: "Add Time") { action, indexPath in
            
            //segue and send current Paycheck object
            self.performSegue(withIdentifier: "showPunches", sender: self.paychecks[indexPath.row])
            
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            //make sure they want to delete the paycheck including time punches...
            let alert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this Paycheck, including all the Time Punches?", preferredStyle: .actionSheet)
            
            let deleteActionAlert = UIAlertAction(title: "Delete This Paycheck!", style: .default, handler: { (action) in
                //print("Perform deletion")
                if let item = self.paychecks?[indexPath.row] {
                    
                    do {
                        try self.realm.write {
                            self.realm.delete(item)
                        }
                        
                    } catch {
                        print("error \(error)")
                    }
                }
                
                 self.payCheckTable.reloadData()
            })
            
            let cancelDelete = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelDelete)
            alert.addAction(deleteActionAlert)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        // customize the action appearance
        addAction.backgroundColor = UIColor(red: 0.749, green: 0.839, blue: 0.937, alpha: 1.00)
        addAction.textColor = UIColor.black
        addAction.hidesWhenSelected = true
        
        //Medium Blue
        editPaycheck.backgroundColor = UIColor(red: 0.375, green: 0.600, blue: 0.950, alpha: 1.00)
        editPaycheck.textColor = UIColor.black
        editPaycheck.hidesWhenSelected = true
        
        deleteAction.textColor = UIColor.black
        deleteAction.hidesWhenSelected = true
        
        //deleteAction.image = UIImage(named: "delete")
        //updateAction.image = UIImage(named: "update")
        
        return [deleteAction, editPaycheck, addAction]
    }
    
    
}
