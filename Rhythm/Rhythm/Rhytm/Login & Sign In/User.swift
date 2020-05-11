//
//  User.swift
//  Rhytm
//
//  Created by Ramses Sanchez Hernandez on 5/10/20.
//  Copyright © 2020 NYUiOS. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class User: NSObject, Codable {
    var firstName: String
    var lastName: String
    var email: String
    
    init(fName: String, lName: String, eMail: String){
        self.firstName = fName
        self.lastName = lName
        self.email = eMail
    }
    override init()
    {
        self.firstName = ""
        self.lastName = ""
        self.email = ""
    }
}
