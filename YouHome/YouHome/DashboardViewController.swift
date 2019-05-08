//
//  DashboardViewController.swift
//  YouHome
//
//  Created by Daniel Xiong on 5/2/19.
//  Copyright © 2019 danielxiong523. All rights reserved.
//

import UIKit
import Contacts

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("successfully granted access to contacts")
                self.fetchContacts()
            }
            else {
                print("not granted access to contacts")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let contactToShow = contacts[indexPath.row]
        cell.textLabel?.text = contactToShow.givenName + " " + contactToShow.familyName
        cell.detailTextLabel?.text = contactToShow.number
        return cell
        
    }
    
    func fetchContacts() {
        
        let requestedKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: requestedKeys)
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                let givenName = contact.givenName
                let familyName = contact.familyName
                let phoneNumber = (contact.phoneNumbers[0].value).value(forKey: "digits") as! String
                
                let contactToAdd = ContactStruct(givenName: givenName, familyName: familyName, number: phoneNumber)
                self.contacts.append(contactToAdd)
            }
            tableView.reloadData()
            print(contacts.first?.givenName)
        }
        catch {
            print("some error with enumerating contacts")
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
