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

class AddAccountTableViewController: UITableViewController {
    
    @IBOutlet var accNameTxtField: UITextField!
    
    @IBOutlet var accMoneyTxtField: UITextField!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        updateSaveButtonState()
    }
    
    var docID: String?
    
    var account: Account?
    
    func updateSaveButtonState() {
        let accName = accNameTxtField.text ?? ""
        let accMoney = accMoneyTxtField.text ?? ""
        saveButton.isEnabled = !accName.isEmpty && !accMoney.isEmpty
    }
    
    override func viewDidLoad() {
          super.viewDidLoad()
        if let account = account {
            accNameTxtField.text = account.accName
            accMoneyTxtField.text = account.accMoney
        }
        updateSaveButtonState()
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
        addToFireBase(acc: account!)
        
    }
    
     func addToFireBase(acc: Account) {
        let db = Firestore.firestore()
        let docID = Auth.auth().currentUser?.email
        db.collection("users").document(docID!).updateData([
            "accName": "\(acc.accName)",
            "accMoney": "\(acc.accMoney)"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    

}
