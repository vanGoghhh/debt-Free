//
//  AddDebtTableViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 15/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//dsadasdasdas
// edit 

import UIKit

class AddDebtTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var money: UITextField!
    @IBOutlet var notes: UITextField!
    @IBOutlet var debtorDebteeName: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var oweOrOwed: UITextField!
    @IBOutlet var dueDate: UITextField!
    
    var debt: Debt?
    var newDueDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        money.keyboardType = .numberPad
        
        let oweOrOwedPicker = UIPickerView()
        oweOrOwed.inputView = oweOrOwedPicker
        oweOrOwedPicker.delegate = self
        
        dueDate.delegate = self
        
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(AddDebtTableViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        

        setupAddTargetIsNotEmpty()
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
    
    
    
}
