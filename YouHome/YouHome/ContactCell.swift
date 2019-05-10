//
//  ContactCell.swift
//  YouHome
//
//  Created by Daniel Xiong on 5/9/19.
//  Copyright © 2019 danielxiong523. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var trustedSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
