# Honey-Im-Home

App Name
Honey, I’m Home (??)
<!--Honey, I'm Not Dead
SOS
SafeAlert
HomeAlert
SafeText
TextSafe
AlertSafe
HomeSafe
AlertU
TextAlert
WYA?
Honey, I'm Safe
Text Me When You're Home
SaveMe
Help
LMKWhenUHome
PartySafeAlert
SaveMePlease-->

Unit 8: Group Milestone
===

# TUNIN

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)

## Overview
### Description
Sends text messages notifying selected contacts when user has reached his or her home. 

### App Evaluation
- **Category:** Social Networking 
- **Mobile:** This app would be limited to mobile because it uses text messaging. There could be an option to configure setting through a website/web app, but this seems unnecessary because phones are typically the most convenient. 
- **Story:** Allows users to select important contacts to notify when they have reached their home. They can change their location and input more contacts as they go.
- **Market:** Any individual that is away from home and wishes to contact friends or family when he/she gets home.
- **Habit:** This app could be used as often or unoften as the user wanted depending on how often they go out
- **Scope:** Anybody with access to iMessage can use this app. We can eventually implement an android version. 

## Product Spec
### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* Register Account/Set Up
* Sign in to account
* Add contacts through iPhone contacts
* Input location 
* Toggle Alert for Contacts
* Change location for home

**Optional Nice-to-have Stories**

* Customized Text Alert messages
* Add option for multiple "Home" locations
* Distress Signal

### 2. Screen Archetypes

* Register - User signs up or logs into their account
   * Inputs phone number and access code
* Dashboard/Home Screen
   * User can toggle which contacts gets alerts
* Settings
   * Allows users to change location
   * Logout

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Dashboard
* Add Contacts Screen
* Settings

**Flow Navigation** (Screen to Screen)
* Login Screen
    * -> Dashboard
    * -> Registration/Signup
* Registration/Sign up
    * -> Dashboard
* Settings 
    * -> Location Screen

## Wireframes
<img src="https://i.imgur.com/0FGYV2z.jpg" width=800><br>

## Schema 
### Models
#### Contact

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | name      | String   | name of contact |
   | number        | Number| phone number of contact |
   | mode         | Boolean     | whether message will be sent to contact or not |
#### Location
| Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | address       | String   | address of location |
   | updatedAt     | Number   | when location is updated |
   
   
### Networking
#### List of network requests by screen
   - Dashboard
       - (Read/GET) Fetch all trusted contacts
         ```swift
         let query = PFQuery(className:"Contacts")
         query.order(byDescending: "name")
         query.findObjectsInBackground { (Contacts: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let contact = contacts {
               print("Successfully retrieved contacts")
           // TODO: Do something with posts...
            }
         }
         ```
      - (Read/GET) Query current location
         ```swift
         let query = PFQuery(className:"currentLocation")
         query.whereKey("address", equalTo: currentLoc)
         query.order(byDescending: "updatedAt")
         query.findObjectsInBackground { (currentLocation: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let location = locations {
               print("Successfully retrieved current location")
           // TODO: Do something with posts...
            }
         }
         ```
      - (Update/PUT) Update mode of contact (on/off)
          ```swift
          let query = PFQuery(className:"Contacts")
        query.getObjectInBackground(withId: "someName") {         
        (gameScore: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let someUser = someUser {
                someUser["mode"] = true
                someUser.saveInBackground()
            }
        }

   - Location
      - (Update/PUT) Update location of home
        ```swift
          let query = PFQuery(className:"currentLocation")
          query.getObjectInBackground(withId: "someLoc") {         
          (gameScore: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let currLoc =  currLoc {
                someLoc["addresss"] = currLoc
                someLoc.saveInBackground()
            }
        }
   - Add Contacts
       - (Create/POST) Add a new contact
         ```swift
            let newContact = PFObject(className:"Contacts")
            newContact["name"] = "Some Name"
            newContact["number"] = 11111111
            newContact["mode"] = false // default mode
            newContact.saveInBackground {
              (success: Bool, error: Error?) in
                  if (success) {
                    // The object has been saved.
                  } else {
                    // check error.description
                  }
            }
            
#### [OPTIONAL:] Existing API Endpoints
##### An API Of Ice And Fire
- Base URL - [http://www.anapioficeandfire.com/api](http://www.anapioficeandfire.com/api)

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /characters | get all characters
    `GET`    | /characters/?name=name | return specific character by name
    `GET`    | /houses   | get all houses
    `GET`    | /houses/?name=name | return specific house by name

##### Game of Thrones API
- Base URL - [https://api.got.show/api](https://api.got.show/api)

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /cities | gets all cities
    `GET`    | /cities/byId/:id | gets specific city by :id
    `GET`    | /continents | gets all continents
    `GET`    | /continents/byId/:id | gets specific continent by :id
    `GET`    | /regions | gets all regions
    `GET`    | /regions/byId/:id | gets specific region by :id
    `GET`    | /characters/paths/:name | gets a character's path with a given name
