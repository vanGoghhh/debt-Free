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
import CocoaTextField
import PMSuperButton

class LoginViewController: UIViewController {
    
    var acc: Account?
    var debt: Debt?
    
    @IBOutlet var loginButton: PMSuperButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet var emailTextField: CocoaTextField!
    @IBOutlet var passwordTextField: CocoaTextField!
    @IBOutlet var logoView: UIView!
    @IBOutlet var forFunImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        setUpElements()
        setUpTextField(textField: emailTextField)
        setUpTextField(textField: passwordTextField)
        self.loginButton.gradientEndColor = UIColor.red
        self.loginButton.gradientStartColor = UIColor.blue
        configLogoView()
        self.forFunImage.image = UIImage(named: "creditImage")
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    func configLogoView() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = logoView.bounds
        logoView.layer.addSublayer(gradient)
        let label = UILabel(frame: logoView.bounds)
        label.text = "Debt-Free"
        label.font = UIFont.boldSystemFont(ofSize: 70)
        label.textAlignment = .left
        logoView.addSubview(label)
        logoView.mask = label
    }
    
    func setUpTextField(textField: CocoaTextField) {
        textField.inactiveHintColor = UIColor(red: 209/255, green: 211/255, blue: 212/255, alpha: 1)
        textField.activeHintColor = UIColor(red: 94/255, green: 186/255, blue: 187/255, alpha: 1)
        textField.focusedBackgroundColor = UIColor(red: 236/255, green: 239/255, blue: 239/255, alpha: 1)
        textField.defaultBackgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        textField.borderColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
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



