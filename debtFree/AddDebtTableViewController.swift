//
//  AddDebtTableViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 15/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//dsadasdasdas
// edit 

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase
import CocoaTextField
import PMSuperButton

class AddDebtTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var money: CocoaTextField!
    @IBOutlet var notes: CocoaTextField!
    @IBOutlet var debtorDebteeName: CocoaTextField!
    @IBOutlet var oweOrOwed: CocoaTextField!
    @IBOutlet var dueDate: CocoaTextField!
    @IBOutlet var cellView: [UIView]!
    @IBOutlet var saveButton: PMSuperButton!
    @IBOutlet var labelView: UIView!
    
    
    var debt: Debt?
    var newDueDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clear
        money.keyboardType = .numberPad
        
        let oweOrOwedPicker = UIPickerView()
        oweOrOwed.inputView = oweOrOwedPicker
        oweOrOwedPicker.delegate = self
        
        dueDate.delegate = self
        
        setUpTextField(textField: money)
        setUpTextField(textField: notes)
        setUpTextField(textField: debtorDebteeName)
        setUpTextField(textField: oweOrOwed)
        setUpTextField(textField: dueDate)
        
        money.attributedPlaceholder = NSAttributedString(string: "$0.00", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        debtorDebteeName.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        oweOrOwed.attributedPlaceholder = NSAttributedString(string: "Owe or Owed", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        dueDate.attributedPlaceholder = NSAttributedString(string: "DueDate", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        notes.attributedPlaceholder = NSAttributedString(string: "Notes", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(AddDebtTableViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        

        setupAddTargetIsNotEmpty()
        
        self.view.backgroundColor =  UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        
        for view in self.cellView {
            view.backgroundColor =  UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        }
        
//        self.saveButton.gradientStartColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1)
//        self.saveButton.gradientEndColor = UIColor(red: 142/255, green: 14/255, blue: 155/255, alpha: 1)
        
        self.saveButton.backgroundColor = UIColor(red: 76/255, green: 0/255, blue: 153/255, alpha: 1)
        
        self.labelView.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        
        //self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "debtBG.png")!)
    }
    
    // Code for due date picker
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == dueDate) {
            performSegue(withIdentifier: "addDueDate", sender: self)
            self.dueDate.text = self.newDueDate
            view.endEditing(true)
        }
    }
    
    
    @IBAction func textEditingChanged(_sender: UITextField) {
    }
    
    func updateSaveButtonState() {
        let name = debtorDebteeName.text ?? ""
        let mon =  money.text ?? ""
        let date = dueDate.text ?? ""
        let owe = oweOrOwed.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !mon.isEmpty && !date.isEmpty && !owe.isEmpty
    }
    // End of code for due date picker
    
    // Code for Owed or Owed Picker
    var pickerDate: [String] = ["Owe", "Owed To"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDate.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDate[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        oweOrOwed.text = pickerDate[row]
    }
    // End of Code for Owe Or Owed Picker
    
    // Code for transfering data to debts table
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "debtSaveUnwind") {
            super.prepare(for: segue, sender: sender)
            let name = debtorDebteeName.text ?? ""
            let mon =  money.text ?? ""
            let date = dueDate.text ?? ""
            let note = notes.text ?? ""
            let owe = oweOrOwed.text ?? ""
            debt = Debt(debtorDebteeName: name, money: mon, date: date, notes: note, oweOrOwed: owe)
            if (debt!.oweOrOwed == "Owe") {
                debtsData.addDebtOwe(debt: debt!)
            } else {
                debtsData.addDebtOwedTo(debt: debt!)
            }
            debtsData.updateFireBase()
            
        }
        if (segue.identifier == "addDueDate") {
            if let dest = segue.destination as? AddDueDateViewController {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy"
                let dateInString = formatter.string(from: date)
                dest.ogDate = dateInString
            }
        }
    }
    // End of code for transfering data to table
    
    
    func setupAddTargetIsNotEmpty() {
        saveButton.isEnabled = false
        money.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        debtorDebteeName.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        oweOrOwed.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .allEditingEvents)
        dueDate.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .allEditingEvents)
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        
        guard
            let name = debtorDebteeName.text, !name.isEmpty,
            let cash = money.text,!cash.isEmpty,
            let oweing = oweOrOwed.text,!oweing.isEmpty,
            let day = dueDate.text,!day.isEmpty
            
            else {

                self.saveButton.isEnabled = false
                return
            }
            saveButton.isEnabled = true
    }
    
    @IBAction func unwindFromAddingNewDueDate(segue: UIStoryboardSegue) {
        if segue.identifier == "addDueDate" {
            guard segue.source is AddDueDateViewController
                else {
                    return
                }
            self.dueDate.text = self.newDueDate!
        }
    }
    
    func setUpTextField(textField: CocoaTextField) {
        textField.inactiveHintColor = UIColor(red: 209/255, green: 211/255, blue: 212/255, alpha: 1)
        textField.activeHintColor = UIColor(red: 94/255, green: 186/255, blue: 187/255, alpha: 1)
        textField.focusedBackgroundColor = UIColor(red: 236/255, green: 239/255, blue: 239/255, alpha: 1)
        textField.defaultBackgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        textField.borderColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        textField.textColor = UIColor.white
    }
    
    
    
}
