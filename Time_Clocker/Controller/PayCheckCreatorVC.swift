//
//  PayCheckCreatorVC.swift
//  Time_Clocker
//
//  Created by Shane Talbert on 6/5/18.
//  Copyright © 2018 Shane Talbert. All rights reserved.
//

import UIKit
import RealmSwift

class PayCheckCreatorVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pkrPayDateStart: UIDatePicker!
    @IBOutlet weak var pkrPayDateEnd: UIDatePicker!
    @IBOutlet weak var pkrPayDate: UIDatePicker!
    @IBOutlet weak var txtEmployeerName: UITextField!
    @IBOutlet weak var bottomConstraintForTextBox: NSLayoutConstraint!
    
    //Height of all 3 pkr boxes to make room for keyboard, starts at 75
    @IBOutlet weak var payEndConstraint: NSLayoutConstraint!
    @IBOutlet weak var payStartConstraint: NSLayoutConstraint!
    @IBOutlet weak var payDateConstraint: NSLayoutConstraint!
    
    //This is the Paycheck? object that will be sent if the segue was performed by pressing the update or edit swipe cell.
    //If it was sent via the create object button nil will be sent.
    var paycheckDetailsToEdit: Paycheck?
    //Will need to edit the database entry as opposed to writing a new entry to perserve the time punches...
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmployeerName.delegate = self
        //print("location of realm db...\(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        
        if paycheckDetailsToEdit != nil {
            //have a passed paycheck need to edit the info to the old starting point...
            //can force unwrap because once the item is created will always have a default date...
            pkrPayDateStart.setDate((paycheckDetailsToEdit?._payPeriodStart)!, animated: true)
            pkrPayDateEnd.setDate((paycheckDetailsToEdit?._payPeriodEnd)!, animated: true)
            pkrPayDate.setDate((paycheckDetailsToEdit?._payDate)!, animated: true)
            txtEmployeerName.text = paycheckDetailsToEdit?._employeerName
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        resetView()
        //print("view did appear")
    }
    
    func resetView() {
        //places text box at the bottom and expands the 3 date pickers
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.7) {
            self.payDateConstraint.constant = 100
            self.payEndConstraint.constant = 100
            self.payStartConstraint.constant = 100
            self.bottomConstraintForTextBox.constant = 160
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.7) {
            
            self.payDateConstraint.constant = 60
            self.payEndConstraint.constant = 60
            self.payStartConstraint.constant = 60
            self.bottomConstraintForTextBox.constant = 260
            self.view.layoutIfNeeded()
        }
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        resetView()
        
        
    }

    @IBAction func escapePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func EnterSavePressed(_ sender: UIButton) {
        
        if paycheckDetailsToEdit == nil {
            //came via the create new paycheck button
            let payStart = pkrPayDateStart.date
            let payEnd = pkrPayDateEnd.date
            let payDay = pkrPayDate.date
            let tempPaycheck = Paycheck()
            
            tempPaycheck._employeerName = txtEmployeerName.text!
            tempPaycheck._payPeriodStart = payStart
            tempPaycheck._payPeriodEnd = payEnd
            tempPaycheck._payDate = payDay
            
            do {
                try realm.write {
                    realm.add(tempPaycheck)
                }
            } catch {
                print("Error writing data \(error)")
            }
            
        } else {
            //came via update
            //need to overwrite 4 items and leave time punces in tact...
            
            //will start by trying to update the 4 items and see if it leaves the time punches alone???
            if let item = paycheckDetailsToEdit {
                
                do {
                    try self.realm.write {
                        item._employeerName = txtEmployeerName.text!
                        item._payPeriodStart = pkrPayDateStart.date
                        item._payPeriodEnd = pkrPayDateEnd.date
                        item._payDate = pkrPayDate.date
                    }
                } catch {
                    print("error \(error)")
                }
            }
            //print("Hopefully item is updated...")
        }
      
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
