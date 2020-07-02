//
//  DebtsDataBase.swift
//  
//
//  Created by Nigel Ng on 25/6/20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class debtsData {
    static var debtsOwe: [Debt] = []
    static var debtsOwedTo: [Debt] = []
    
    static func addDebtOwe(debt: Debt) {
        debtsOwe.append(debt)
    }
    
    static func addDebtOwedTo(debt: Debt) {
        debtsOwedTo.append(debt)
    }
    
    static func recalculateDebtOwe() -> Int {
        var moneyOwed = 0
        for debt in debtsOwe {
            moneyOwed += Int(debt.money)!
        }
        return moneyOwed
    }
    
    static func recalculateDebtOwedTo() -> Int {
        var moneyOwedTo = 0
        for debt in debtsOwedTo {
            moneyOwedTo += Int(debt.money)!
        }
        return moneyOwedTo
    }
    
    static func updateFireBase() {
        let allDebts = debtsOwe + debtsOwedTo
        let db = Firestore.firestore()
        let docID = Auth.auth().currentUser?.email
        for (index, debt) in allDebts.enumerated() {
            db.collection("users").document(docID!).collection("Debts").document("Debt \(index+1)").setData([
                "Debtee or Debtor Name" : "\(debt.debtorDebteeName )",
                "Amount Of Money" : "\(debt.money)",
                "Due-Date" : "\(debt.date)",
                "Owe or Owed" : "\(debt.oweOrOwed)",
                "Notes" : "\(debt.notes)"])
        }
    }
}
