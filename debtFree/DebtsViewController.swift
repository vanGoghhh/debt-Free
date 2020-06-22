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
    var editedDebtIndex: Int?
    var editedDebt: Debt?
    var currentTableView: Int!
    var newDebtName: String!
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
            cell.amountOwed!.text = "$" + iOwe[indexPath.row].money
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
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//           if editingStyle == .delete {
//                if (currentTableView == 0) {
//                    iOwe.remove(at: indexPath.row);
//                    debtTableView.reloadData()
//                    updateTotal()
//                } else {
//                    peopleOweMe.remove(at: indexPath.row);
//                    debtTableView.deleteRows(at: [indexPath ], with: .automatic)
//                    debtTableView.reloadData()
//                    updateTotal()
//
//                }
//            }
//       }
    
    @IBAction func unwindToDebtTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "debtSaveUnwind",
        let sourceViewController = segue.source as?
        AddDebtTableViewController,
        let debt = sourceViewController.debt else { return}
        if debt.oweOrOwed == "Owe" {
            iOwe.append(debt)

            //notification for oweing others
            let content = UNMutableNotificationContent()
            content.title = "Hey its time to pay that debt!"
            content.body = "You owe \(debt.debtorDebteeName) a total of $\(debt.money)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let date = dateFormatter.date(from: debt.date)
            let dateComponents = Calendar.current.dateComponents([.month, .day, .year], from: date!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in print("error in notifications") }
            
            //reload view of debt table
            debtTableView.reloadData()

        } else {
            peopleOweMe.append(debt)
            
            //notification for oweing others
            let content = UNMutableNotificationContent()
            content.title = "Hey its time to collect that debt!"
            content.body = "\(debt.debtorDebteeName) owes you a total of $\(debt.money)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy"
            let date = dateFormatter.date(from: debt.date)
            let dateComponents = Calendar.current.dateComponents([.month, .day, .year], from: date!)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in print("error in notifications") }
            
            debtTableView?.reloadData()
        }
        //update total for insights section perhaps
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
        totalMoneyLabel?.text = "$" + String(oweMoney - moneyOwed)
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
                destination.arrIndex =  indexPath.row
                
            } else {
                let indexPath = sender as! IndexPath
                destination.debt = peopleOweMe[indexPath.row]
                destination.arrIndex = indexPath.row
            }
        }
    }
    
    @IBAction func unwindFromEditing(segue: UIStoryboardSegue) {
        guard segue.identifier == "editingUnwind",
            let sourceViewController = segue.source as? IndividualDebtViewController,
            var debt = sourceViewController.debt else {return}
        if (debt.oweOrOwed == "Owe") {
            debt.debtorDebteeName = self.newDebtName!
            iOwe[editedDebtIndex!] = debt
            //debtTableView.reloadData()
            updateTotal()
        } else {
            peopleOweMe[editedDebtIndex!] = debt
            //debtTableView?.reloadData()
            updateTotal()
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
