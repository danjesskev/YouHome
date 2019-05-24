//
//  ContactStruct.swift
//  YouHome
//
//  Created by Daniel Xiong on 5/7/19.
//  Copyright © 2019 danielxiong523. All rights reserved.
//

import Foundation
//import Contacts

class ContactStruct: NSObject, NSCoding {
    let givenName: String
    let familyName: String
    let number: String
    var trusted: Bool
    
    init(givenName: String, familyName: String, number: String, trusted: Bool) {
        self.givenName = givenName
        self.familyName = familyName
        self.number = number
        self.trusted = trusted
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let givenName = aDecoder.decodeObject(forKey: "givenName") as! String
        let familyName = aDecoder.decodeObject(forKey: "familyName") as! String
        let number = aDecoder.decodeObject(forKey: "number") as! String
        let trusted = aDecoder.decodeBool(forKey: "trusted")
        self.init(givenName: givenName, familyName: familyName, number: number, trusted: trusted)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(givenName, forKey: "givenName")
        aCoder.encode(familyName, forKey: "familyName")
        aCoder.encode(number, forKey: "number")
        aCoder.encode(trusted, forKey: "trusted")
    }
}
