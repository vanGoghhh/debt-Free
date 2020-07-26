//
//  ViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 1/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
import FirebaseUI

class WelcomeViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet var welcomeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        configWelcomeView()
    }
    
    func configWelcomeView() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = welcomeView.bounds
        welcomeView.layer.addSublayer(gradient)
        let label = UILabel(frame: welcomeView.bounds)
        label.text = "Welcome to DebtFree"
        label.font = UIFont.boldSystemFont(ofSize: 41)
        label.textAlignment = .center
        welcomeView.addSubview(label)
        welcomeView.mask = label
    }
    
    @IBAction func signUp(_ sender: Any) {
        self.performSegue(withIdentifier: "signUp", sender: self)
    }
    
    
    @IBAction func logIn(_ sender: Any) {
        self.performSegue(withIdentifier: "logIn", sender: self)
    }
    
    


}

