//
//  SelectAnAccountViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 2/7/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit

class SelectAnAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var accountsTableView: UITableView!
    
    var acc = AccountsDataBase.Accs
    var paidDebt: Debt?
    var usedAcc: Account?
    var usedAccIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountsTableView?.delegate = self
        accountsTableView?.dataSource = self
        accountsTableView.separatorStyle = .none
        self.view.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.accountsTableView.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acc.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = accountsTableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! SelectAccountTableViewCell
        cell.accountName.text = acc[indexPath.row].accName
        cell.accountMoney.text = acc[indexPath.row].accMoney
        if (Int(acc[indexPath.row].accMoney)! >= Int(paidDebt!.money)!) {
            cell.accountMoney.textColor = UIColor(red: 0/255, green: 153/255, blue: 76/255, alpha: 1)
        } else {
            cell.accountMoney.textColor = UIColor(red: 153/255, green: 0/255, blue: 76/255, alpha: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chooseThisAccToPayDebt = UIAlertController(title: nil, message: "Pay off debt with this account?", preferredStyle: .alert)
        let yesChooseThisAcc = UIAlertAction(title: "Yes", style: .default, handler: { action in
            AccountsDataBase.Accs[indexPath.row].accMoney = String(Int(AccountsDataBase.Accs[indexPath.row].accMoney)! - Int(self.paidDebt!.money)!)
            AccountsDataBase.addToFireBase()
            self.usedAcc = AccountsDataBase.Accs[indexPath.row]
            self.usedAccIndex = indexPath.row
            self.performSegue(withIdentifier: "payOffDebtWithAcc", sender: self)
            
        })
        let noDontChooseThisAcc = UIAlertAction(title: "No", style: .default, handler: nil)
        chooseThisAccToPayDebt.addAction(yesChooseThisAcc)
        chooseThisAccToPayDebt.addAction(noDontChooseThisAcc)
        self.present(chooseThisAccToPayDebt, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func removeDebt(deb: Debt) {
        if (paidDebt!.oweOrOwed == "Owe") {
            if let index = debtsData.debtsOwe.firstIndex(of: paidDebt!) {
                debtsData.debtsOwe.remove(at: index)
            }
        } else {
            if let index = debtsData.debtsOwedTo.firstIndex(of: paidDebt!) {
                debtsData.debtsOwedTo.remove(at: index)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DebtsViewController {
            self.removeDebt(deb: self.paidDebt!)
            dest.paidDebt = self.paidDebt
            dest.usedAcc = self.usedAcc
            dest.usedAccIndex = self.usedAccIndex
        }
    }
    
}

