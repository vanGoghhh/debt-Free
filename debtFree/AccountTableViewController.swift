//
//  AccountTableViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 3/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
// LOL

import UIKit
import Firebase

class AccountTableViewController: UITableViewController {
    
    var accounts = AccountsDataBase.Accs
    var debtMoney: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        
        let account = accounts[indexPath.row];
        
        cell.update(with: account);
        
        cell.showsReorderControl = true;

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            accounts.remove(at: indexPath.row);
            removeAccFirebase()
            tableView.deleteRows(at: [indexPath ], with: .automatic)
        } else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let debt = self.debtMoney
            else {
                return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chooseThisAccToPayDebt = UIAlertController(title: nil, message: "Pay off debt with this account?", preferredStyle: .alert)
        let yesChooseThisAcc = UIAlertAction(title: "Yes", style: .default, handler: { action in
            print(Int( AccountsDataBase.Accs[indexPath.row].accMoney))
                AccountsDataBase.Accs[indexPath.row].accMoney = String(Int(AccountsDataBase.Accs[indexPath.row].accMoney)! - Int(self.debtMoney!)!)
        })
        let noDontChooseThisAcc = UIAlertAction(title: "No", style: .default, handler: nil)
        chooseThisAccToPayDebt.addAction(yesChooseThisAcc)
        chooseThisAccToPayDebt.addAction(noDontChooseThisAcc)
        self.present(chooseThisAccToPayDebt, animated: true, completion: nil)
    }
    
    func removeAccFirebase() {
        let db = Firestore.firestore()
        let docID = Auth.auth().currentUser?.email
        db.collection("users").document(docID!).updateData([
            "accName" : FieldValue.delete(),
            "accMoney" : FieldValue.delete()
        ]) { err in
            if let err = err {
                print("Error deleting field : \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    @IBAction func unwindToAccountTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as?
            AddAccountTableViewController,
            let account = sourceViewController.account else { return}
        if let selectedPathIndex = tableView.indexPathForSelectedRow {
            accounts[selectedPathIndex.row] = account
            tableView.reloadRows(at: [selectedPathIndex], with: .none)
        } else {
            let newIndexPath = IndexPath(row: accounts.count, section: 0)
            accounts.append(account)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
