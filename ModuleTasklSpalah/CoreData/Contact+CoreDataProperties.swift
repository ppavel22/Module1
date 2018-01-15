//
//  Contact+CoreDataProperties.swift
//  ModuleTasklSpalah
//
//  Created by mac on 14.01.2018.
//  Copyright © 2018 mac. All rights reserved.
//
//

import Foundation
import CoreData

extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var email: String?
    @NSManaged public var phone: String?
    @NSManaged public var image: NSData?

}
