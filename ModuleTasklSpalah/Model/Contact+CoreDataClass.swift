//
//  Contact+CoreDataClass.swift
//  ModuleTasklSpalah
//
//  Created by mac on 14.01.2018.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {

}

extension Contact {
    var fullName: String {
        if let name = name, let surname = surname {
            return name + " " + surname
        }
        return ""
    }
}
