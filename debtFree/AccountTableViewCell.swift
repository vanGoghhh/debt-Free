//
//  AccountTableViewCell.swift
//  debtFree
//
//  Created by Nigel Ng on 3/6/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet var accName: UILabel!
    @IBOutlet var accMoney: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with account: Account) {
        accName.text = account.accName
        accMoney.text = account.accMoney
    }
    

}
