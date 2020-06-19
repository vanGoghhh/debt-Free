//
//  DebtsViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 15/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit

class DebtsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var iOwe: [Debt] = []
    var peopleOweMe: [Debt] = []
    
    var currentTableView: Int!
    @IBOutlet var debtTableView: UITableView!
    @IBOutlet var totalMoneyLabel: UILabel!
    @IBOutlet var typeOfDebtsSegControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTableView = 0;
        updateTotal()
        debtTableView.delegate = self
        debtTableView.dataSource = self
        self.debtTableView.separatorStyle = .none
        self.debtTableView.estimatedRowHeight = 600
        self.debtTableView.rowHeight =  UITableView.automaticDimension
        self.debtTableView.allowsSelection = true
     //   self.debtTableView.rowHeight = UITableViewAutomatic
        // Do any additional setup after loading the view.
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (currentTableView == 0) {
            return iOwe.count
        } else {
            return peopleOweMe.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = debtTableView.dequeueReusableCell(withIdentifier: "debtCell", for: indexPath) as! DebtTableViewCell
        switch (typeOfDebtsSegControl.selectedSegmentIndex) {
        case 0:
            cell.debtorDebteeName!.text = iOwe[indexPath.row].debtorDebteeName
            cell.amountOwed!.text = iOwe[indexPath.row].money
            cell.dueDate!.text = iOwe[indexPath.row].date
            break
        case 1:
            if peopleOweMe.isEmpty {
                break;
            } else {
            cell.debtorDebteeName!.text = peopleOweMe[indexPath.row].debtorDebteeName
            cell.amountOwed!.text = peopleOweMe[indexPath.row].money
            cell.dueDate!.text = peopleOweMe[indexPath.row].date
            }
        
        default:
            break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
                if (currentTableView == 0) {
                    iOwe.remove(at: indexPath.row);
                    debtTableView.reloadData()
                    updateTotal()
                } else {
                    peopleOweMe.remove(at: indexPath.row);
                    debtTableView.deleteRows(at: [indexPath ], with: .automatic)
                    debtTableView.reloadData()
                    updateTotal()
                
                }
            }
       }
    
    @IBAction func unwindToDebtTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "debtSaveUnwind",
        let sourceViewController = segue.source as?
        AddDebtTableViewController,
        let debt = sourceViewController.debt else { return}
        if debt.oweOrOwed == "Owe" {
            iOwe.append(debt)
            debtTableView.reloadData()
        
        } else {
            peopleOweMe.append(debt)
            debtTableView.reloadData()
        }
        updateTotal()
    }
    
    @IBAction func segValChanged(_ sender: UISegmentedControl) {
        currentTableView = sender.selectedSegmentIndex
        self.debtTableView.reloadData()
    }
    
    
    func updateTotal() {
        var oweMoney: Int = 0
        var moneyOwed: Int = 0
        let debtOwe = iOwe
        let debtOwedTo = peopleOweMe
        for debt in debtOwe {
            oweMoney += Int(debt.money)!
        }
        for debt in debtOwedTo {
            moneyOwed += Int(debt.money)!
        }
        totalMoneyLabel.text = "$" + String(oweMoney - moneyOwed)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debtTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "editDebt", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? IndividualDebtViewController {
            if (currentTableView == 0) {
                let indexPath = sender as! IndexPath
                destination.debt = iOwe[indexPath.row]
            } else {
                let indexPath = sender as! IndexPath
                destination.debt = peopleOweMe[indexPath.row]
            }
        }
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
