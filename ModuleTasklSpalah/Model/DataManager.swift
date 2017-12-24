//
//  DataManager.swift
//  ModuleTasklSpalah
//
//  Created by mac on 10.12.2017.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation

final class DataManager {
    static let instance = DataManager()
    private init() {
        generateStartContactsStorage()
    }
    private(set) var contactsStorage: [ String: [Contact] ] = [:]
    private(set) var massOfLetters: [String] = []
    private(set) var allContacts: [[Contact]] = [[]]
    
    // MARK: - Private methods
    
    private func generateStartContacts() -> [Contact] {
        var contactsArray: [Contact] = []
        contactsArray.append(Contact(firstName: "Misha", lastName: "Yuminov"))
        contactsArray.append(Contact(firstName: "Pavel", lastName: "Chekalkin"))
        contactsArray.append(Contact(firstName: "Alise", lastName: "Krutienko"))
        contactsArray.append(Contact(firstName: "Daniel", lastName: "Pilipets"))
        contactsArray.append(Contact(firstName: "Dima", lastName: "Potapov"))
        return contactsArray
    }
    
    private func setupLetters() {
        let letters = Array(contactsStorage.keys)
        massOfLetters = letters.sorted()
    }
    private func setupAllContacts() {
        allContacts = Array(contactsStorage.values)
    }
    private func generateKeysAndValues() {
        setupLetters()
        setupAllContacts()
    }
    
    private func generateStartContactsStorage() {
        for contact in generateStartContacts() {
            guard let firstLetter = stringFirstLetter(of: contact.firstName.characters.first) else { return }
            var newContacts = contactsStorage[firstLetter] ?? []
            newContacts.append(contact)
            contactsStorage[firstLetter] = newContacts
        }
        generateKeysAndValues()
    }
    
    private func stringFirstLetter(of character: Character?) -> String? {
        if let firstLetter = character {
            let firstLetterString = String(firstLetter)
            return firstLetterString.uppercased()
        }
        return nil
    }
    
    private func getIndex(of contact: Contact, in contactArray: [Contact]) -> Int? {
        var indexOfContact: Int?
        for (index, item) in contactArray.enumerated() {
            if item.id == contact.id {
                indexOfContact = index
                break
            }
        }
        return indexOfContact
    }
    
    private func contacts(of firstLetter: String) -> [Contact] {
        return contactsStorage[firstLetter.uppercased()] ?? []
    }
    
    private func findOldContact(_ newContact: Contact) -> Contact? {
        for array in allContacts {
            for contact in array {
                if contact.id == newContact.id {
                    return contact
                }
            }
        }
        return nil
    }
    private func add(contact: Contact) {
        guard let firstLetter = stringFirstLetter(of: contact.firstName.characters.first) else { return }
        if let oldContact = findOldContact(contact) {
            deleteContact(oldContact)
        }
        var newContacts = contactsStorage[firstLetter] ?? []
        newContacts.append(contact)
        contactsStorage[firstLetter] = newContacts
        generateKeysAndValues()
    }
    private func edit(contact: Contact) {
        guard let firstLetter = stringFirstLetter(of: contact.firstName.characters.first) else { return }
        if let oldContact = findOldContact(contact) {
            deleteContact(oldContact)
        }
        var newContacts = contactsStorage[firstLetter] ?? []
        newContacts.append(contact)
        contactsStorage[firstLetter] = newContacts
        generateKeysAndValues()
    }
    
    // MARK: - Storage Actions
    
    func deleteContact(_ contact: Contact) {
        guard let firstLetter = stringFirstLetter(of: contact.firstName.characters.first) else { return }
        var currentContacts = contacts(of: firstLetter)
        guard !currentContacts.isEmpty else { return }
        guard let index = getIndex(of: contact, in: currentContacts) else { return }
        currentContacts.remove(at: index)
        contactsStorage[firstLetter] = currentContacts
        if currentContacts.isEmpty {
            contactsStorage[firstLetter] = nil
        }
        generateKeysAndValues()
        
        NotificationCenter.default.post(name: .ContactDeleted, object: nil)
    }
    
    func editContact(_ contact: Contact) {
        edit(contact: contact)
        NotificationCenter.default.post(name: .ContactChanged, object: nil)
    }
    
    func addContact(_ contact: Contact) {
        add(contact: contact)
        NotificationCenter.default.post(name: .ContactAdded, object: nil)
    }
}
