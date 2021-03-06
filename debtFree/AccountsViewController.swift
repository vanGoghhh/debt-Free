//
//  AccountsViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 6/7/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit
import PMSuperButton

class AccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var accountTable: UITableView!
    @IBOutlet var addAccount: PMSuperButton!
    
    var accounts = AccountsDataBase.Accs
    var usedAcc: Account?
    var usedAccIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        let account = accounts[indexPath.row];
        cell.accName.text = account.accName
        cell.accMoney.text = account.accMoney
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func unwindToAccountTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as?
            AddAccountTableViewController,
            let account = sourceViewController.account else { return}
        accounts.append(account)
        accountTable.reloadData()
    }
    
    @IBAction func unwindFromUsedAcc(segue: UIStoryboardSegue) {
        if (segue.identifier == "showUpdatedAcc") {
            print(self.accounts)
            self.accounts[usedAccIndex!] = usedAcc!
            self.accountTable.reloadData()
        }
    }
    
    @IBAction func addDebt(_ sender: Any) {
        self.performSegue(withIdentifier: "addDebt", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        accountTable?.delegate = self
        accountTable?.dataSource = self
        accountTable?.separatorStyle = .none
        self.accountTable?.separatorStyle = .none
        self.accountTable?.estimatedRowHeight = 100
        self.accountTable?.rowHeight =  UITableView.automaticDimension
        self.view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.accountTable?.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.addAccount.gradientEndColor = UIColor(red: 142/255, green: 14/255, blue: 155/255, alpha: 1)
        self.addAccount.gradientStartColor = UIColor.purple
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        
        if isDarkMode == true {
            darkMode()
        } else {
            self.accountTable?.backgroundColor = UIColor.white
            lightMode()
        }
    }
    
    func darkMode() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]//user global variable
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black //user global variable
        self.navigationController?.navigationBar.tintColor = UIColor.black //user global variable
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
         self.tabBarController?.tabBar.barTintColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
    }
    
    func lightMode() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]//user global variable
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default //user global variable
        self.navigationController?.navigationBar.tintColor = UIColor.white //user global variable
        
     
        UIApplication.shared.statusBarStyle = .default
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        view.backgroundColor = UIColor.groupTableViewBackground
    }
    

}
