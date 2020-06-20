//
//  AccountTableViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 3/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
// LOL

import UIKit

class AccountTableViewController: UITableViewController {
    
    var accounts:[Account] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            accounts.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath ], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AddAccount" {
//            let indexPath = tableView.indexPathForSelectedRow!
//            let account = accounts[indexPath.row]
//            let navController = segue.destination as! UINavigationController
//            let addAccountTableViewController = navController.topViewController as! AddAccountTableViewController
//            addAccountTableViewController.account = account
//        }
//    }
    
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
