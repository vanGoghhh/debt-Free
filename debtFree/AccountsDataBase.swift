//
//  AccountsDataBase.swift
//  debtFree
//
//  Created by Nigel Ng on 28/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AccountsDataBase {
    
    static var Accs: [Account] = []
    
    static func addAccount(acc: Account) {
        Accs.append(acc)
    }
    
    static func addToFireBase() {
        let db = Firestore.firestore()
        let docID = Auth.auth().currentUser?.email
        for (index, acc) in Accs.enumerated() {
            db.collection("users").document(docID!).collection("Accounts").document("Account \(index + 1)").setData([
                "Account Name" : "\(acc.accName)",
                "Account Money" : "\(acc.accMoney)"])
        }
    }
}
