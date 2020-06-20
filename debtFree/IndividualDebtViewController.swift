//
//  IndividualDebtViewController.swift
//  debtFree
//
//  Created by Nigel Ng on 18/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
// 

import UIKit

class IndividualDebtViewController: UIViewController {
    
    var debt: Debt?

    @IBOutlet var money: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var duedate: UILabel!
    @IBOutlet var notes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        money.text = debt!.money
        name.text = debt!.debtorDebteeName
        duedate.text = debt!.date
        notes.text = debt!.notes
        money.isUserInteractionEnabled = true
        let tapChangeMoney = UITapGestureRecognizer(target: self, action: #selector(IndividualDebtViewController.tapChangeMoney(sender:)))
        money.addGestureRecognizer(tapChangeMoney)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func tapChangeMoney(sender: UITapGestureRecognizer) {
        let changeDebtAlert =  UIAlertController(title: nil, message: "Changing Debt", preferredStyle: .actionSheet)
        let increaseDebt = UIAlertAction(title: "Increase Debt", style: .default) {
            (action) in
            let increaseDebtController = UIAlertController(title: nil, message: "Enter Increment Amount", preferredStyle: .alert)
            increaseDebtController.addTextField {
                (textField) in textField.text = "$0.00"
             }

        }
        let decreaseDebt = UIAlertAction(title: "Decrease Debt", style: .default)
        let cancelAction =  UIAlertAction(title: "Cancel", style: .default)
        changeDebtAlert.addAction(increaseDebt)
        changeDebtAlert.addAction(decreaseDebt)
        changeDebtAlert.addAction(cancelAction)
        self.present(changeDebtAlert, animated: true, completion: nil)
        
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
