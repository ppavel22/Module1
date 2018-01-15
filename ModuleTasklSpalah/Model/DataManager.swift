//
//  DataManager.swift
//  ModuleTasklSpalah
//
//  Created by mac on 10.12.2017.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import CoreData
import  UIKit

final class DataManager {
    static let instance = DataManager()
    private init() {}
    private(set) var contactsStorage: [ String: [Contact] ] = [:]
    private(set) var allContacts: [Contact] = []
    private(set) var massOfLetters: [String] = []
    
    // MARK: - Private methods
    
    private func setupLetters() {
        let letters = Array(contactsStorage.keys)
        massOfLetters = letters.sorted()
    }
    
    private func contacts(of firstLetter: String) -> [Contact] {
        return contactsStorage[firstLetter.uppercased()] ?? []
    }
    private func stringFirstLetter(of character: Character?) -> String? {
        if let firstLetter = character {
            let firstLetterString = String(firstLetter)
            return firstLetterString.uppercased()
        }
        return nil
    }
    private func getById(id: NSManagedObjectID) -> Contact? {
        let context = CoreDataManager.instance.persistentContainer.viewContext
        return context.object(with: id) as? Contact
    }
    
    // MARK: - Storage Actions
    
    func loadData() {
        allContacts = []
        contactsStorage = [:]
        let context = CoreDataManager.instance.persistentContainer.viewContext
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            allContacts = try context.fetch(request)
        } catch {
            debugPrint("Fetching failed")
        }
        for contact in allContacts {
            guard let name = contact.name else { return }
            guard let firstLetter = stringFirstLetter(of: name.characters.first) else { return }
            var newContacts = contactsStorage[firstLetter] ?? []
            newContacts.append(contact)
            contactsStorage[firstLetter] = newContacts
        }
        setupLetters()
    }
    
    func deleteContact(_ contact: Contact) {
        CoreDataManager.instance.persistentContainer.viewContext.delete(contact)
        CoreDataManager.instance.saveContext()
        NotificationCenter.default.post(name: .ContactDeleted, object: nil)
    }
    
    func editContact(_ editedContact: Contact) {
        
        if let contact = getById(id: editedContact.objectID) {
            contact.name = editedContact.name
            contact.surname = editedContact.surname
            contact.email = editedContact.email
            contact.phone = editedContact.phone
            contact.image = editedContact.image
        }
        CoreDataManager.instance.saveContext()
        NotificationCenter.default.post(name: .ContactChanged, object: nil)
    }
    
    func addContact(name: String?, surname: String?, email: String?, phone: String?, image: NSData?) {
        let context = CoreDataManager.instance.persistentContainer.viewContext
        let newContact = Contact(context: context)
        newContact.name = name
        newContact.surname = surname
        newContact.email = email
        newContact.phone = phone
        newContact.image = image
        CoreDataManager.instance.saveContext()
        NotificationCenter.default.post(name: .ContactAdded, object: nil)
    }
}
