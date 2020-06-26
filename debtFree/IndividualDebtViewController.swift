//
//  IndividualDebtViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 18/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//  oof

import UIKit

class IndividualDebtViewController: UIViewController, UITextFieldDelegate {
    
    var debt: Debt?
    var arrIndex: Int?
    var newName: String?
    var newDate: String?

    @IBOutlet var money: UILabel!
    @IBOutlet var name: UITextField!
    @IBOutlet var duedate: UILabel!
    @IBOutlet var notes: UILabel!
    @IBOutlet var payOffButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        money.text = "$"  + debt!.money
        name.text = debt!.debtorDebteeName
        duedate.text = debt!.date
        notes.text = debt!.notes
       
        
        payOffButton.contentEdgeInsets = UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20)
        payOffButton.backgroundColor = UIColor.systemTeal
        payOffButton.layer.cornerRadius = 5
        payOffButton.layer.borderWidth = 1
        payOffButton.layer.borderColor =
            UIColor.black.cgColor
     
        
        money.isUserInteractionEnabled = true
        let tapChangeMoney = UITapGestureRecognizer(target: self, action: #selector(IndividualDebtViewController.tapChangeMoney(sender:)))
        money.addGestureRecognizer(tapChangeMoney)
        
        name.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
        duedate.isUserInteractionEnabled = true
        let tapChangeDate = UITapGestureRecognizer(target: self, action:
            #selector(IndividualDebtViewController.tapChangeDate(sender:)))
        duedate.addGestureRecognizer(tapChangeDate)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func tapChangeDate(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "changeDate", sender: self)
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        print(name.text!)
        newName = name.text!
        self.debt?.debtorDebteeName = newName!
    }
    
    @objc func tapChangeMoney(sender: UITapGestureRecognizer) {
        let changeDebtAlert =  UIAlertController(title: nil, message: "Changing Debt", preferredStyle: .actionSheet)
        let increaseDebt = UIAlertAction(title: "Increase Debt", style: .default) {
            (action) in
            let increaseDebtController = UIAlertController(title: nil, message: "Enter Increment Amount", preferredStyle: .alert)
            increaseDebtController.addTextField {
                (textField) in textField.placeholder = "$0.00"
                textField.keyboardType = .numberPad
             }
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: {action in self.debt!.money = String(Int(increaseDebtController.textFields![0].text!)! +
                Int(self.debt!.money)!)
                self.money.text = self.debt?.money})
            let cancel = UIAlertAction(title: "cancel", style: .default)
            increaseDebtController.addAction(confirm)
            increaseDebtController.addAction(cancel)
            self.present(increaseDebtController, animated: true, completion: nil)

        }
        let decreaseDebt = UIAlertAction(title: "Decrease Debt", style: .default) {
            (action) in
            let decreaseDebtController = UIAlertController(title: nil, message: "Enter Decrement Amount", preferredStyle: .alert)
            decreaseDebtController.addTextField {
                (textField) in textField.placeholder = "$0.00"
                textField.keyboardType = .numberPad
             }
            let confirm = UIAlertAction(title: "confirm", style: .default, handler: {action in self.debt!.money = String(Int(self.debt!.money)! - Int(decreaseDebtController.textFields![0].text!)!)
                self.money.text = self.debt?.money})
            let cancel = UIAlertAction(title: "cancel", style: .default)
            decreaseDebtController.addAction(confirm)
            decreaseDebtController.addAction(cancel)
            self.present(decreaseDebtController, animated: true, completion: nil)

        }
        let cancelAction =  UIAlertAction(title: "Cancel", style: .default)
        changeDebtAlert.addAction(increaseDebt)
        changeDebtAlert.addAction(decreaseDebt)
        changeDebtAlert.addAction(cancelAction)
        self.present(changeDebtAlert, animated: true, completion: nil)
    }
    
    @IBAction func textFieldDidEndEditing(_ textField: UITextField) {
        name.text = name.text
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editingUnwind") {
        super.prepare(for: segue, sender: sender)
            if let destination = segue.destination as? DebtsViewController {
                destination.editedDebtIndex = self.arrIndex
                destination.newDebtName = self.newName
                //self.debt?.date = newDate!
                destination.editedDebt = self.debt
                //print(self.debt)
            }
        }
        if (segue.identifier == "removeDebt") {
            if let destination = segue.destination as? DebtsViewController {
                destination.editedDebtIndex = 0
                destination.editedDebt = nil
            }
        }
        if (segue.identifier == "changeDate") {
            if let destination = segue.destination as? CalenderViewController {
                destination.originalDate = duedate.text
            }
        }
        
    }
    
    @IBAction func incOrRedDebt(_ sender: Any) {
        let changeDebtAlert =  UIAlertController(title: nil, message: "Changing Debt", preferredStyle: .actionSheet)
        let increaseDebt = UIAlertAction(title: "Increase Debt", style: .default) {
                (action) in
            let increaseDebtController = UIAlertController(title: nil, message: "Enter Increment Amount", preferredStyle: .alert)
                   increaseDebtController.addTextField {
                       (textField) in textField.placeholder = "$0.00"
                       textField.keyboardType = .numberPad
                    }
            let confirm = UIAlertAction(title: "Confirm", style: .default, handler: {action in self.debt!.money = String(Int(increaseDebtController.textFields![0].text!)! +
                       Int(self.debt!.money)!)
                       self.money.text = self.debt?.money})
                   let cancel = UIAlertAction(title: "cancel", style: .default)
                   increaseDebtController.addAction(confirm)
                   increaseDebtController.addAction(cancel)
                   self.present(increaseDebtController, animated: true, completion: nil)
            }
        let decreaseDebt = UIAlertAction(title: "Decrease Debt", style: .default) {
                   (action) in
            let decreaseDebtController = UIAlertController(title: nil, message: "Enter Decrement Amount", preferredStyle: .alert)
                   decreaseDebtController.addTextField {
                       (textField) in textField.placeholder = "$0.00"
                       textField.keyboardType = .numberPad
                    }
            let confirm = UIAlertAction(title: "confirm", style: .default, handler: {action in self.debt!.money = String(Int(self.debt!.money)! - Int(decreaseDebtController.textFields![0].text!)!)
                       self.money.text = self.debt?.money})
            let cancel = UIAlertAction(title: "cancel", style: .default)
                   decreaseDebtController.addAction(confirm)
                   decreaseDebtController.addAction(cancel)
                   self.present(decreaseDebtController, animated: true, completion: nil)
            }
        let cancelAction =  UIAlertAction(title: "Cancel", style: .default)
        changeDebtAlert.addAction(increaseDebt)
        changeDebtAlert.addAction(decreaseDebt)
        changeDebtAlert.addAction(cancelAction)
        self.present(changeDebtAlert, animated: true, completion: nil)
    }
    
    @IBAction func removeDebt(_ sender: Any) {
        let removeDebt = UIAlertController(title: nil, message: "Do you want to remove this debt?", preferredStyle: .alert)
        let yesRemovePls = UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.performSegue(withIdentifier: "removeDebt", sender: self)
        })
        let dontRemove = UIAlertAction(title: "Cancel", style: .default)
        removeDebt.addAction(dontRemove)
        removeDebt.addAction(yesRemovePls)
        self.present(removeDebt, animated: true, completion: nil)
    }
    
    @IBAction func payOFF(_ sender: Any) {
        let confirmPayOff = UIAlertController(title: "Pay Off", message: "Do you want to pay off this debt?", preferredStyle: .alert)
        let yesPayOffDebt =  UIAlertAction(title: "Yes", style: .default, handler: {action in
            self.performSegue(withIdentifier: "payOffDebt", sender: self)
        })
        let noCancelPayOff = UIAlertAction(title: "No", style: .default)
        confirmPayOff.addAction(yesPayOffDebt)
        confirmPayOff.addAction(noCancelPayOff)
        self.present(confirmPayOff, animated: true, completion: nil)
    }
    
    @IBAction func unwindFromChangedDate(segue: UIStoryboardSegue) {
        if segue.identifier == "editedDate" {
            guard segue.source is CalenderViewController
                else { return}
            self.duedate.text = self.newDate
            self.debt?.date = self.newDate!
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
