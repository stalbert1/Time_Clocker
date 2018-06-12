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
    
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmployeerName.delegate = self
        //print("location of realm db...\(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")

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
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.7) {
            self.payDateConstraint.constant = 100
            self.payEndConstraint.constant = 100
            self.payStartConstraint.constant = 100
            self.bottomConstraintForTextBox.constant = 160
            self.view.layoutIfNeeded()
        }
        
    }

    @IBAction func escapePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func EnterSavePressed(_ sender: UIButton) {
        
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
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
