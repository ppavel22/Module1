//
//  Contact.swift
//  ModuleTasklSpalah
//
//  Created by mac on 10.12.2017.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import UIKit

struct Contact {
    private static var objectCounter = 0
    let id: Int
    var firstName: String
    var lastName: String
    var email: String?
    var phoneNumber: String?
    var image: UIImage?
    
    init(firstName: String, lastName: String) {
        Contact.objectCounter += 1
        self.id = Contact.objectCounter
        self.firstName = firstName
        self.lastName = lastName
        self.email = ""
        self.phoneNumber = ""
        self.image = #imageLiteral(resourceName: "user-5")
    }
}

extension Contact {
    var fullName: String {
        return firstName + " " + lastName
    }
}
