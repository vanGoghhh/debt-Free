//
//  SelectAccountTableViewCell.swift
//  debtFree
//
//  Created by Nigel Ng on 2/7/20.
//  Copyright © 2020 Nigel Ng. All rights reserved.
//

import UIKit

class SelectAccountTableViewCell: UITableViewCell {
    
    @IBOutlet var accountName: UILabel!
    @IBOutlet var accountMoney: UILabel!
    @IBOutlet var cellView: UIView!
    @IBOutlet var AccountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellView.backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 75/255, alpha: 1)
        self.contentView.backgroundColor = UIColor(red: 45/255, green: 45/255, blue: 55/255, alpha: 1)
        self.AccountLabel.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        self.accountName.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.cellView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
