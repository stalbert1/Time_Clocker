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
        
        loadData()
        
    }
    
    @IBAction func verifiedSegChanged(_ sender: UISegmentedControl) {
        
        //maybe this should be incorperated inside the load data function..???
        //reason being is when you make a change to verify the check you want it to dis appear from that list...
        
        //Show hide verified changed...
        if segVerifiedSelected.selectedSegmentIndex == 0 {
            //show all selected
            print("show all selected")
            loadData()
        } else {
            //Unverified only selected
            print("Unverfied only selected")
            paychecks = paychecks.filter("_payCheckIsVerified == %@", true).sorted(byKeyPath: "_employeerName", ascending: true)
            payCheckTable.reloadData()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        paychecks = realm.objects(Paycheck.self)
        payCheckTable.reloadData()
    }
    
    
    @IBAction func createNewPaycheckPressed(_ sender: UIButton) {
        
        print("create new paycheck pressed...")
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //this will occur slightly before the actual seague...
        print("code to perform when transition is made...")
        if segue.identifier == "showPunches" {
            if let destination = segue.destination as? MainVC {
                if let payCheck = sender as? Paycheck {
                    destination.payCheckToEdit = payCheck
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
            myCell.lblWeekStarting.text = paychecks[indexPath.row].payPeriodStart
            myCell.lblWeekEnding.text = paychecks[indexPath.row].payPeriodEnd
            myCell.lblPayDate.text = paychecks[indexPath.row].payDate
            
            //let hoursWorked = paychecks[indexPath.row].calculateHours()
            //myCell.lblHoursWorked.text = "\(hoursWorked) Seconds"
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
                print("Verify checked")
            }
            
            //customize the verify checked item here...
            
            
            return [verifyPay]
        }
        
        
        
        let editPaycheck = SwipeAction(style: .default, title: "Edit Info") { (action, indexPath) in
            //check verified code
            print("edit info pressed")
            
            
        }
        
        let addAction = SwipeAction(style: .destructive, title: "Add Time") { action, indexPath in
            
            //segue and send current Paycheck object
            self.performSegue(withIdentifier: "showPunches", sender: self.paychecks[indexPath.row])
            
        }
        
        let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
            
            
            //test out to delete the selected item...
            
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
            
        }
        
        // customize the action appearance
        //deleteAction.image = UIImage(named: "delete")
        //updateAction.image = UIImage(named: "update")
        
        return [editPaycheck, addAction, deleteAction]
    }
    
    
}
