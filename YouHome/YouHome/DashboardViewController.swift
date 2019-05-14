//
//  DashboardViewController.swift
//  YouHome
//
//  Created by Daniel Xiong on 5/2/19.
//  Copyright © 2019 danielxiong523. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Parse

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()
    var CNContacts = [CNContact]()
    var trustedContacts = [ContactStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if let error = error {
                print("Failed to request access", error)
                return
            }
            if success {
                print("successfully granted access to contacts")
                self.fetchContacts()
            }
        }
        // Do any additional setup after loading the view.
    }
    
    //func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        //return true
    //}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactCell
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let contactToShow = contacts[indexPath.row]
        cell.nameLabel.text = contactToShow.givenName + " " + contactToShow.familyName
        cell.phoneNumberLabel.text = contactToShow.number
        cell.trustedSwitch.setOn(false, animated: false)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func fetchContacts() {
        
        let requestedKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: requestedKeys)
        do {
            try contactStore.enumerateContacts(with: request) { (contact, stop) in
                let givenName = contact.givenName
                let familyName = contact.familyName
                let phoneNumber = contact.phoneNumbers[0].value.stringValue     //uses the first given number
                
                let contactToAdd = ContactStruct(givenName: givenName, familyName: familyName, number: phoneNumber, trusted: false)
                self.contacts.append(contactToAdd)
                self.CNContacts.append(contact)
            }
            tableView.reloadData()
            //print(contacts.first?.givenName)
            
        }
        catch {
            print("some error with enumerating contacts")
        }
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        
        PFUser.logOut()
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginViewController
        
    }
    
    func testContact() {
        let unkvc = CNContactViewController(forUnknownContact: CNContacts[0])
        unkvc.message = "He knows his trees"
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = false
        self.navigationController?.pushViewController(unkvc, animated: true)
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
