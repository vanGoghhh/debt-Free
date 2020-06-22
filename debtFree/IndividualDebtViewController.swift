//
//  IndividualDebtViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 18/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
// 

import UIKit

class IndividualDebtViewController: UIViewController, UITextFieldDelegate {
    
    var debt: Debt?
    var arrIndex: Int?

    @IBOutlet var money: UILabel!
    @IBOutlet var name: UITextField!
    @IBOutlet var duedate: UILabel!
    @IBOutlet var notes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        money.text = debt!.money
        name.text = debt!.debtorDebteeName
        duedate.text = debt!.date
        notes.text = debt!.notes
        name.delegate = self
        money.isUserInteractionEnabled = true
        let tapChangeMoney = UITapGestureRecognizer(target: self, action: #selector(IndividualDebtViewController.tapChangeMoney(sender:)))
        money.addGestureRecognizer(tapChangeMoney)
        
     
        
    
        
        duedate.isUserInteractionEnabled = true
        
        
        // Do any additional setup after loading the view.
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        name.text = name.text
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? DebtsViewController {
            destination.editedDebtIndex = self.arrIndex
            destination.newDebtName = self.name.text
            destination.editedDebt = self.debt
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
