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
import CoreLocation
import GooglePlaces

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CNContactViewControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var homeTextField: UILabel!
    let locationManager:CLLocationManager = CLLocationManager()
    
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()
    //var CNContacts = [CNContact]()
    //var trustedContacts = [ContactStruct]()
    var homeAddress = "9500 Gilman Drive" //DEFAULT VALUE
    var homeLatitude = CLLocationDegrees(32.878466)
    var homeLongitude = CLLocationDegrees(-117.229582)
    static let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 100
        
        //print("CREATING GEOFENCE WITH \(homeLatitude) , \(homeLongitude)")
        
        //let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(homeLatitude, homeLongitude), radius: 75, identifier: "Home")
        //locationManager.startMonitoring(for: geoFenceRegion)
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for currentLocation in locations{
            print("\(index): \(currentLocation)")
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("ENTERED REGION: will alert contacts")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("EXITED REGION")
    }
    
    @IBAction func onAlert(_ sender: Any) {
        //if current user location is within home region....
        
        //if current user location is not within home region, didEnterRegion
        //should alert contacts
        print("in onAlert: CREATING GEOFENCE WITH \(homeLatitude) , \(homeLongitude)")
        let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(homeLatitude, homeLongitude), radius: 75, identifier: "Home")
        locationManager.startMonitoring(for: geoFenceRegion)
    }
    @IBAction func onSetHome(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
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
        if cell.trustedSwitch.isOn {
            contacts[indexPath.row].trusted = true
        }
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
                //self.CNContacts.append(contact)
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
    
    override func viewDidAppear(_ animated: Bool) {
        homeTextField.text = UserDefaults.standard.string(forKey: "homeAddress")
        //homeLongitude = UserDefaults.standard.double(forKey: "homeLongitude")
        //homeLatitude = UserDefaults.standard.double(forKey: "homeLatitude")
        print("CURRENT HOME LOCATION IS: \(homeAddress)")
        print(UserDefaults.standard.double(forKey: "homeLatitude"))
        print(UserDefaults.standard.double(forKey: "homeLongitude"))
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

extension DashboardViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Successfully selected address")
        print("Place name: \(place.name)")
        UserDefaults.standard.set(place.name, forKey: "homeAddress")
        homeAddress = UserDefaults.standard.string(forKey: "homeAddress")!
        homeLatitude = place.coordinate.latitude
        homeLongitude = place.coordinate.longitude
        UserDefaults.standard.set(homeLatitude, forKey: "homeLatitude")
        UserDefaults.standard.set(homeLongitude, forKey: "homeLongitude")
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("USER CANCELLED OPERATION")
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
