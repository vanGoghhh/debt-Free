//
//  SettingsViewController.swift
//  debtFree
//
//  Created by Christopher Mervyn on 22/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {

    @IBOutlet weak var darkButton: UIButton!
    @IBOutlet weak var lightButton: UIButton!
    
  
    @IBAction func darkPressed(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "isDarkMode")
        darkMode()
    }
    
    @IBAction func lightPressed(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isDarkMode")
        lightMode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        
            self.view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)

        if isDarkMode == true {
            darkMode()
        } else {
            lightMode()
        }
    }
    
    func darkMode() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]//user global variable
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black //user global variable
        self.navigationController?.navigationBar.tintColor = UIColor.black //user global variable
        overrideUserInterfaceStyle = .dark
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
    }
    
    func lightMode() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//user global variable
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default //user global variable
        self.navigationController?.navigationBar.tintColor = UIColor.white //user global variable
        UIApplication.shared.statusBarStyle = .default
        overrideUserInterfaceStyle = .light
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        view.backgroundColor = UIColor.groupTableViewBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
