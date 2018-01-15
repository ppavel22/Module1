//
//  ContactListTableViewController.swift
//  ModuleTasklSpalah
//
//  Created by mac on 10.12.2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ContactListTableViewController: UIViewController {

    @IBOutlet private weak var ibSearchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    var datasource: [ String: [Contact] ] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    private var massOfLetters: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var newData: [Contact] = []
    private var isSearchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDatasource()
        addObservers()
        title = "Contacts"
        ibSearchBar.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? EditContactViewController else { return }
        if let identifier = segue.identifier {
            switch identifier {
            case "editContact":
                guard let cell = sender as? UITableViewCell else { return }
                guard let indexPath = tableView.indexPath(for: cell) else { return }
                guard let item = getContact(for: indexPath) else { return }
                destinationVC.contact = item
            case "addContact":
                destinationVC.contact = nil
            default:
                break
            }
        }
        
    }
    
    // MARK: - Private methods
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(contactDeleted), name: .ContactDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactChanged), name: .ContactChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(contactAdded), name: .ContactAdded, object: nil)
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func setupDatasource() {
        loadData()
        datasource = DataManager.instance.contactsStorage
        massOfLetters = DataManager.instance.massOfLetters
        updateSearchContentIfNeeded()
    }
    
    private func updateSearchContentIfNeeded() {
        guard isSearchActive else { return }
        let searcText = ibSearchBar.text ?? ""
        filteredContent(byName: searcText)
        
    }
    
    private func filteredContent(byName name: String) {
        isSearchActive = !name.isEmpty
        newData = []
        
        for contact in DataManager.instance.allContacts {
            if contact.fullName.lowercased().contains(name.lowercased()) {
                newData.append(contact)
            }
        }
        tableView.reloadData()
    }
    
    private func getContact(for indexPath: IndexPath) -> Contact? {
        if !isSearchActive {
            let key = massOfLetters[indexPath.section]
            let contactForSection = datasource[key]
            return contactForSection?[indexPath.row]
        } else {
            return newData[indexPath.row]
        }
    }
    private func loadData() {
        DataManager.instance.loadData()
    }
}

// MARK: - UITableViewDataSourse

extension ContactListTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchActive ? 1 : massOfLetters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearchActive {
            let key = massOfLetters[section]
            let contactForSection = datasource[key] ?? []
            return contactForSection.count
        } else {
            return newData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableCell") as? ContactTableViewCell else {
            fatalError("Error: Cell doesn't exist")
        }
        guard let item = getContact(for: indexPath) else {
            fatalError("Error: Cell has wrong index path")
        }
        if let firstName = item.name, let lastName = item.surname {
            cell.update(firstName: firstName, lastName: lastName)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchActive ? "search" : massOfLetters[section]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let item = getContact(for: indexPath) else { return }
        DataManager.instance.deleteContact(item)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

// MARK: - Notification

extension ContactListTableViewController {
    
    @objc private func contactDeleted() {
        setupDatasource()
    }
    
    @objc private func contactChanged() {
        setupDatasource()
    }
    
    @objc private func contactAdded() {
        setupDatasource()
    }
}

// MARK: - UISearchBarDelegate

extension ContactListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredContent(byName: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
