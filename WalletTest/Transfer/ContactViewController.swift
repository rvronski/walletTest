//
//  ContactViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 10.02.2023.
//

import UIKit
import Contacts

protocol ContactViewDelegate: AnyObject {
    func present(name: String)
}

class ContactViewController: UIViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //
    }
    
    var delegate: ContactViewDelegate?
    var contacts = [PhoneContact]()
    var string = [String]()
    private lazy var contactTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "ContactCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        self.setupView()
        self.setupNavigationBar()
        gets{
            self.contactTableView.reloadData()
        }
//        self.contacts = contacts
    }
        //        self.contact = PhoneContacts().getContacts()
    
    func gets(completion: () -> Void) {
        let contacts = self.getContactFromCNContact()
        for contact in contacts {
//            self.string.append(contact.givenName + "" + contact.middleName)
//            print(contact.middleName)
//            print(contact.familyName)
//            print(contact.givenName)
            let givenName = contact.givenName
            let middleName = contact.middleName
//            let phoneNumber = contact.phoneNumbers.first?.label ?? ""
            let phoneContact = PhoneContact(givenName: givenName, familyName: middleName)
            self.contacts.append(phoneContact)
            
        }
        completion()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        self.contact = PhoneContacts().getContacts()
        //        self.string = phoneNumberWithContryCode()
        self.contactTableView.reloadData()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Понравившиеся публикции"
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.contactTableView)
        
        NSLayoutConstraint.activate([
            self.contactTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.contactTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.contactTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.contactTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])
    }
    
    // `contacts` Contains all details of Phone Contacts
        

    func getContactFromCNContact() -> [CNContact] {

        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactEmailAddressesKey,
            ] as [Any]

        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }

        var results: [CNContact] = []

        
        for container in allContainers {

            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)

            } catch {
                print("Error fetching results for container")
            }
        }

        return results
    }

}
extension ContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! SettingsTableViewCell
        cell.setupContact(contact: contacts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userName = contacts[indexPath.row].givenName + "" + contacts[indexPath.row].familyName
        self.delegate?.present(name: userName)
        self.dismiss(animated: true)
        
    }
    
}
