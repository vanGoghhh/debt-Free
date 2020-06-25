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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
    }
    

    


}

