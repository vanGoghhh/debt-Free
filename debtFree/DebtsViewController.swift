//
//  DebtsViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 15/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
// oof

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import BetterSegmentedControl


class DebtsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var iOwe = debtsData.debtsOwe
    var peopleOweMe = debtsData.debtsOwedTo
    var editedDebtIndex: Int?
    var editedDebt: Debt?
    var currentTableView: Int!
    var newDebtName: String!
    var newDueDate: String!
    var paidDebt: Debt?
    var usedAcc: Account?
    var usedAccIndex: Int?
    var tableIndex: Int!
    var masterArray = debtsData.debtsOwe
    
    @IBOutlet var debtTableView: UITableView!
    @IBOutlet var totalMoneyLabel: UILabel!
    @IBOutlet var typeOfDebts: BetterSegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTableView = 0;
        updateTotal()
        debtTableView?.delegate = self
        debtTableView?.dataSource = self
        self.debtTableView?.separatorStyle = .none
        self.debtTableView?.estimatedRowHeight = 100
        self.debtTableView?.rowHeight =  UITableView.automaticDimension
        self.debtTableView?.allowsSelection = true
        self.debtTableView?.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.view.backgroundColor =  UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.totalMoneyLabel?.textColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        configSeg()
    }
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = debtTableView.dequeueReusableCell(withIdentifier: "debtCell", for: indexPath) as! DebtTableViewCell
        cell.debtorDebteeName!.text = masterArray[indexPath.row].debtorDebteeName
        cell.amountOwed!.text = "$" + masterArray[indexPath.row].money
        cell.dueDate!.text = masterArray[indexPath.row].date
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @IBAction func unwindToDebtTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "debtSaveUnwind",
        let sourceViewController = segue.source as?
        AddDebtTableViewController,
        let debt = sourceViewController.debt else { return}
        if debt.oweOrOwed == "Owe" {
            iOwe.append(debt)
            //debtsData.addDebtOwe(debt: debt)
            //print(debtsData.debtsOwedTo)
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
            debtTableView?.reloadData()

        } else {
            peopleOweMe.append(debt)
            //debtsData.addDebtOwedTo(debt: debt)
            //notification for oweing others
            //print(debtsData.debtsOwe)
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
        if (segue.identifier == "showUpdatedAcc") {
            if let destination = segue.destination as? AccountsViewController {
                destination.usedAcc = self.usedAcc
                destination.usedAccIndex = self.usedAccIndex
            }
        } else {
            super.prepare(for: segue, sender: sender)
            if let destination = segue.destination as? IndividualDebtViewController {
                let indexPath = sender as! IndexPath
                destination.debt = masterArray[indexPath.row]
                destination.arrIndex = indexPath.row
            }
        }
    }
    
    @IBAction func unwindFromEditing(segue: UIStoryboardSegue) {
        if (segue.identifier == "editingUnwind") {
            if (self.editedDebt?.oweOrOwed == "Owe") {
                debtsData.debtsOwe[editedDebtIndex!] = editedDebt!
                iOwe[editedDebtIndex!] = editedDebt!
                updateTotal()
                debtsData.updateFireBase()
                self.debtTableView.reloadData()
            } else {
                debtsData.debtsOwedTo[editedDebtIndex!] = editedDebt!
                peopleOweMe[editedDebtIndex!] = editedDebt!
                debtsData.updateFireBase()
                updateTotal()
                self.debtTableView.reloadData()
            }
        }
        if (segue.identifier == "removeDebt" || segue.identifier == "payOffDebt") {
            guard let sourceViewController = segue.source as? IndividualDebtViewController,
                var debt = sourceViewController.debt else {return}
            if (debt.oweOrOwed == "Owe") {
                debtsData.debtsOwe.remove(at: editedDebtIndex!)
                iOwe.remove(at: editedDebtIndex!)
                self.fireBaseDebtRefresh()
                updateTotal()
                self.debtTableView.reloadData()
            } else {
                debtsData.debtsOwedTo.remove(at: editedDebtIndex!)
                peopleOweMe.remove(at: editedDebtIndex! )
                self.fireBaseDebtRefresh()
                updateTotal()
                self.debtTableView.reloadData()
            }
        }
        if (segue.identifier == "payOffDebtWithAcc") {
            guard segue.source is SelectAnAccountViewController else { return}
            if (paidDebt!.oweOrOwed == "Owe") {
                if let index = self.iOwe.firstIndex(of: paidDebt!) {
                    self.iOwe.remove(at: index)
                }
            } else {
                if let index = self.peopleOweMe.firstIndex(of: paidDebt!) {
                    self.peopleOweMe.remove(at: index)
                }
            }
            let dest = AccountsViewController()
            dest.accounts[usedAccIndex!] = usedAcc!
            print(dest.accounts)
            self.fireBaseDebtRefresh()
            updateTotal()
            self.debtTableView.reloadData()
            let showUpdatedAcc = UIAlertController(title: nil, message: "Your Accounts have been updated!", preferredStyle: .alert)
            let okShowMe = UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.performSegue(withIdentifier: "showUpdatedAcc", sender: self)
            })
            showUpdatedAcc.addAction(okShowMe)
            self.present(showUpdatedAcc, animated: true, completion: nil)
        }
    }
    
    func fireBaseDebtRefresh() {
        let db = Firestore.firestore()
        let docID = Auth.auth().currentUser?.email
        db.collection("users").document(docID!).collection("Debts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting doc :\(err)")
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    db.collection("users").document(docID!).collection("Debts").document(id).delete()
                }
            }
            debtsData.updateFireBase()
        }
    }
    
    func setCellBorderColour(view: UIView) {
        let topColour = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        let bottomColour = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [bottomColour, topColour]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
        // Randomly generate number in closure
        let randomColorGenerator = { ()-> CGFloat in
            CGFloat(arc4random() % 256 ) / 256
        }
            
        var red: CGFloat = randomColorGenerator()
        var green: CGFloat = randomColorGenerator()
        var blue: CGFloat = randomColorGenerator()
            
        // Mix the color
        if let mixColor = mixColor {
            var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
            mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
            
            red = (red + mixRed) / 2;
            green = (green + mixGreen) / 2;
            blue = (blue + mixBlue) / 2;
        }
            
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    
    
    func configSeg() {
        typeOfDebts.addTarget(self, action: #selector(handleChangeVals(_:)), for: .valueChanged)
        typeOfDebts.segments = LabelSegment.segments(withTitles: ["Debts I Owe", "Debts People Owe Me"],normalFont: UIFont(name: "HelveticaNeue-Light", size: 14.0)!,
        normalTextColor: .lightGray,
        selectedFont: UIFont(name: "HelveticaNeue-Bold", size: 14.0)!,
        selectedTextColor: .white)
        
        typeOfDebts.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        typeOfDebts.indicatorViewBackgroundColor = UIColor(red: 65/255, green: 65/255, blue: 75/255, alpha: 1)
    
        
    }
    
    @objc func handleChangeVals(_ sender: BetterSegmentedControl) {
        switch (sender.index) {
        case 0:
            masterArray = debtsData.debtsOwe
        case 1:
            masterArray = debtsData.debtsOwedTo
        default:
            break
        }
        self.debtTableView.reloadData()
    }
}
