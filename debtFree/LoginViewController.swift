//
//  LoginViewController.swift
//  debtFree
//
//  Created by Christopher Mervyn on 23/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    var acc: Account?
    var debt: Debt?
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        //Validate text fields
        
        //Create Cleaned versions of the text fields
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Signing in the users
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                //Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                //Get document ID of the user
                let db = Firestore.firestore()
                let docID = Auth.auth().currentUser?.email
                let docRef = db.collection("users").document(docID!)
                let debtCollection = docRef.collection("Debts")
                debtCollection.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let name = document.get("Debtee or Debtor Name")
                            let money = document.get("Amount Of Money")
                            let oweOrOwed = document.get("Owe or Owed")
                            let date = document.get("Due-Date")
                            self.debt = Debt(debtorDebteeName: name as! String, money: money as! String, date: date as! String, notes: "", oweOrOwed: oweOrOwed as! String)
                            if (self.debt?.oweOrOwed == "Owe") {
                                debtsData.addDebtOwe(debt: self.debt!)
                            } else {
                                debtsData.addDebtOwedTo(debt: self.debt!)
                                print(debtsData.debtsOwedTo)
                            }
                        }
                        let db2 = Firestore.firestore()
                        let docID2 = Auth.auth().currentUser?.email
                        let docRef2 = db2.collection("users").document(docID2!)
                        let accountCollection = docRef2.collection("Accounts")
                        accountCollection.getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let accName = document.get("Account Name")
                                    let accMoney = document.get("Account Money")
                                    self.acc = Account(accName: accName as! String, accMoney: accMoney as! String)
                                    AccountsDataBase.addAccount(acc: self.acc!)
                                }
                            }
                            let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UITabBarController
                            self.view.window?.rootViewController = homeViewController
                            self.view.window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
    }
}



