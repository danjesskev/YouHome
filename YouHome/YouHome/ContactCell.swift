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
    var indexNum:Int!
    
    
    @IBOutlet weak var trustedSwitch: UISwitch!
    
    let userDefaults = UserDefaults.standard
    
    
    @IBAction func onSwitch(_ sender: UISwitch) {
        let decoded = userDefaults.data(forKey: "contacts")
        let decodedContacts = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [ContactStruct]
        if( sender.isOn ) {
            decodedContacts[indexNum].trusted = true
        } else {
            decodedContacts[indexNum].trusted = false
        }
        
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: decodedContacts)
        userDefaults.set(encodedData, forKey: "contacts")
        userDefaults.synchronize()
        
    }
    
    func something() {
    let decoded = userDefaults.data(forKey: "contacts")
    let decodedContacts = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [ContactStruct]
    print(decodedContacts[indexNum].givenName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
