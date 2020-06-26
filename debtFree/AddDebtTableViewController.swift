//
//  AddDebtTableViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 15/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//dsadasdasdas
// edit 

import UIKit

class AddDebtTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var money: UITextField!
    @IBOutlet var notes: UITextField!
    @IBOutlet var debtorDebteeName: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var oweOrOwed: UITextField!
    @IBOutlet var dueDate: UITextField!
    
    var debt: Debt?
    
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
        
        let dueDatePicker = UIDatePicker()
        dueDatePicker.datePickerMode = .date
        dueDatePicker.addTarget(self, action: #selector(AddDebtTableViewController.dateChanged(dueDatePicker:)), for: .valueChanged)
        dueDate.inputView = dueDatePicker
        
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(AddDebtTableViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        

        setupAddTargetIsNotEmpty()
    }
    
    // Code for due date picker
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(dueDatePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "MMM d, yyyy"
        dueDate.text = dateFormatter.string(from: dueDatePicker.date)
        view.endEditing(true)
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
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "debtSaveUnwind" else { return}
        
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
        print(debtsData.debtsOwe)
        print(debtsData.debtsOwedTo)
    }
    // End of code for transfering data to table
    
    
    
    // MARK: - Table view data source
    
   
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        
}
