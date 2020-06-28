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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
                docRef.getDocument { (document, error) in
                guard let accName = document?.get("accName"),
                let accMoney = document?.get("accMoney")
                    else {
                        let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UITabBarController
                                       
                        self.view.window?.rootViewController = homeViewController
                        self.view.window?.makeKeyAndVisible()
                        return
                    }
                    
                self.acc = Account(accName: accName as! String, accMoney: accMoney as! String)
                AccountsDataBase.addAccount(acc: self.acc!)
                //Transition to home screen
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? UITabBarController
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    }
}
