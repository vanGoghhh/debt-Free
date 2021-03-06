//
//  IndividualDebtViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 18/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//  oof

import UIKit
import Firebase
import PMSuperButton


class IndividualDebtViewController: UIViewController, UITextFieldDelegate{
    
    var debt: Debt?
    var arrIndex: Int?
    var newName: String?
    var newDate: String?

    @IBOutlet var money: UILabel!
    @IBOutlet var name: UITextField!
    @IBOutlet var duedate: UILabel!
    @IBOutlet var notes: UILabel!
    @IBOutlet var payOffButton: PMSuperButton!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var cellView: [UIView]!
    @IBOutlet var saveChanges: PMSuperButton!
    @IBOutlet var slider: CustomSlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        money.text =  debt!.money
        name.text = debt!.debtorDebteeName
        duedate.text = debt!.date
        notes.text = debt!.notes
       
        money.isUserInteractionEnabled = true
        let tapChangeMoney = UITapGestureRecognizer(target: self, action: #selector(IndividualDebtViewController.tapChangeMoney(sender:)))
        money.addGestureRecognizer(tapChangeMoney)
        
        name.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        
        duedate.isUserInteractionEnabled = true
        let tapChangeDate = UITapGestureRecognizer(target: self, action:
            #selector(IndividualDebtViewController.tapChangeDate(sender:)))
        duedate.addGestureRecognizer(tapChangeDate)
        
        let gradientColour = CAGradientLayer()
        gradientColour.frame = viewBG.bounds
        gradientColour.colors = [UIColor.black, UIColor.gray]
        viewBG.layer.addSublayer(gradientColour)
        
        self.viewBG.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        for view in self.cellView {
            view.backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 75/255, alpha: 1)
            view.layer.cornerRadius = 10
        }
        self.name.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.name.textColor = UIColor.white
        self.name.textAlignment = .center
        self.payOffButton.gradientEndColor = UIColor(red: 142/255, green: 14/255, blue: 155/255, alpha: 1)
        self.payOffButton.gradientStartColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1)
        self.saveChanges.gradientStartColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1)
        self.saveChanges.gradientEndColor = UIColor(red: 142/255, green: 14/255, blue: 155/255, alpha: 1)
        
        configSlider()
    }
    
    @objc func tapChangeDate(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "changeDate", sender: self)
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
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
                print(self.debt)
                destination.editedDebt = self.debt
                //print(self.debt)
            }
        }
        if (segue.identifier == "removeDebt" || segue.identifier == "payOffDebt") {
            if let destination = segue.destination as? DebtsViewController {
                destination.editedDebtIndex = self.arrIndex
                destination.editedDebt = nil
            }
        }
        if (segue.identifier == "changeDate") {
            if let destination = segue.destination as? CalenderViewController {
                destination.originalDate = duedate.text
            }
        }
        if (segue.identifier == "selectAccount") {
            if let destination = segue.destination as? SelectAnAccountViewController {
                destination.paidDebt = self.debt
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
    
    @IBAction func payOFF(_ sender: Any) {
        let confirmPayOff = UIAlertController(title: "Pay Off", message: "Do you want to pay off this debt?", preferredStyle: .alert)
        let yesPayOffDebt =  UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            let payOffWithCurrentAccount = UIAlertController(title: nil, message: "Do you want to pay off this debt with an account stored?", preferredStyle: .alert)
            let yesPayOffDebtWithAccount = UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                if (!AccountsDataBase.Accs.isEmpty) {
                    self.performSegue(withIdentifier: "selectAccount", sender: self)}
                else {
                    let noAccountToPayWith = UIAlertController(title: nil, message: "No Account to pay off debt with!", preferredStyle: .alert)
                    self.present(noAccountToPayWith, animated: true, completion: nil)
                }
            })
            let noDoNotPayOffWithCurrentAccount = UIAlertAction(title: "No", style: .default, handler: {(action) in  self.performSegue(withIdentifier: "payOffDebt", sender: self)})
            payOffWithCurrentAccount.addAction(yesPayOffDebtWithAccount)
            payOffWithCurrentAccount.addAction(noDoNotPayOffWithCurrentAccount)
            self.present(payOffWithCurrentAccount, animated: true, completion: nil)
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
    
    func configSlider() {
        slider.minimumValue = Float(Int(self.money.text!)! - 1000)
        slider.maximumValue = Float(Int(self.money.text!)! + 1000)
        slider.value = Float(Int(self.money.text!)!)
        slider.minimumTrackTintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1)
        slider.maximumTrackTintColor = UIColor(red: 142/255, green: 14/255, blue: 155/255, alpha: 1)
    }

    @IBAction func sliderValueChange(sender: CustomSlider) {
        var currentSliderValue = sender.value
        self.money.text = String(format: "%i",Int(sender.value))
        self.debt?.money = String(Int(currentSliderValue))
    }
}
