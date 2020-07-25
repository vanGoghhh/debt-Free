//
//  AddAccountTableViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 3/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import CocoaTextField
import PMSuperButton

class AddAccountTableViewController: UITableViewController {
    
    @IBOutlet var accNameTxtField: CocoaTextField!
    
    @IBOutlet var accMoneyTxtField: CocoaTextField!
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updateSaveButtonState()
    }
    @IBOutlet var cellView: [UIView]!
    @IBOutlet var labelView: UIView!
    @IBOutlet var saveButton: PMSuperButton!
    
    var docID: String?
    
    var account: Account?
    
    func updateSaveButtonState() {
        let accName = accNameTxtField.text ?? ""
        let accMoney = accMoneyTxtField.text ?? ""
        saveButton.isEnabled = !accName.isEmpty && !accMoney.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField(textField: accNameTxtField)
        setUpTextField(textField: accMoneyTxtField)
        self.tableView.separatorStyle = .none
        if let account = account {
            accNameTxtField.text = account.accName
            accMoneyTxtField.text = account.accMoney
        }
        updateSaveButtonState()
        
        for view in cellView {
            view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        }
        self.labelView.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.saveButton.gradientStartColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1)
        self.saveButton.gradientEndColor = UIColor(red: 142/255, green: 14/255, blue: 155/255, alpha: 1)
      }
    
    @IBAction func textEditingChanged(_sender: UITextField) {
        updateSaveButtonState()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return}
        
        let name = accNameTxtField.text ?? ""
        let money =  accMoneyTxtField.text ?? ""
        account = Account(accName: name, accMoney: money)
        AccountsDataBase.addAccount(acc: account!)
        AccountsDataBase.addToFireBase()
    }
    
    func setUpTextField(textField: CocoaTextField) {
        textField.inactiveHintColor = UIColor(red: 209/255, green: 211/255, blue: 212/255, alpha: 1)
        textField.activeHintColor = UIColor(red: 94/255, green: 186/255, blue: 187/255, alpha: 1)
        textField.focusedBackgroundColor = UIColor(red: 236/255, green: 239/255, blue: 239/255, alpha: 1)
        textField.defaultBackgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        textField.borderColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        textField.backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 75/255, alpha: 1)
    }

}
