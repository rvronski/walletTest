//
//  ContactViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 10.02.2023.
//

import UIKit
import Contacts

protocol ContactViewDelegate: AnyObject {
    func present(name: String, number: String)
}

class ContactViewController: UIViewController, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        getsSearch(searchText: searchController.searchBar.text ?? "")
        self.contactTableView.reloadData()
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
    }
    
    
    func getsSearch(searchText: String) {
        if let number = Int(searchText) {
            self.getNumber(search: number)
        } else {
            let contacts = self.getContactFromCNContact(searchText: searchText)
            var cont = [PhoneContact]()
            for contact in contacts {
                var numer = [String]()
                let givenName = contact.givenName
                let middleName = contact.middleName
                let number = contact.phoneNumbers
                for i in number {
                    let value = i.value.stringValue
                    numer.append(value)
                }
                let phoneNumber = numer
                let phoneContact = PhoneContact(givenName: givenName, familyName: middleName, phoneNumber: phoneNumber)
                cont.append(phoneContact)
            }
            self.contacts = cont
            self.contactTableView.reloadData()
        }
    }
    
    func getNumber(search: Int) {
        var mo = [PhoneContact]()
        for i in self.contacts {
            let phone = i.phoneNumber.first ?? ""
            if phone.contains(String(search)) {
                mo.append(i)
            }
        }
        
        self.contacts = mo
        self.contactTableView.reloadData()
        
    }
    
    func gets(completion: () -> Void) {
        let contacts = self.getContactFromCNContact()
        for contact in contacts {
            var numer = [String]()
            let givenName = contact.givenName
            let middleName = contact.middleName
            let number = contact.phoneNumbers
            for i in number {
                let value = i.value.stringValue
                numer.append(value)
            }
            let phoneNumber = numer
            let phoneContact = PhoneContact(givenName: givenName, familyName: middleName, phoneNumber: phoneNumber)
            self.contacts.append(phoneContact)
            
        }
        completion()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentReachabilityStatus == .notReachable {
            self.alertOk(title: "Проверьте интернет соединение", message: nil)
        }
        self.contactTableView.reloadData()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Контакты"
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
        

    func getContactFromCNContact(searchText: String?=nil) -> [CNContact] {
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactGivenNameKey,
            CNContactMiddleNameKey,
            CNContactFamilyNameKey,
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey
        ] as [Any]
        
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        
        
        var results: [CNContact] = []
        //        555-478-7672
        //        id    String    "5F19F581-D078-4FA5-A721-AD8C7B30B529"
        for container in allContainers {
            if let searchText, searchText != "" {
                let fetchPredicate = CNContact.predicateForContacts(matchingName: searchText)
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                    
                } catch {
                    print("Error fetching results for container")
                }
        } else {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
                
            } catch {
                print("Error fetching results for container")
            }
        }
    }
        return results
    }
    
    
    private func tapCell(numbers: [String], completion: @escaping (_ number: String) -> Void) {
        let alertController = UIAlertController(title: "Выберите номер", message: nil, preferredStyle: .actionSheet)
        var actions = [UIAlertAction]()
        for n in numbers {
            let action = UIAlertAction(title: n, style: .default) {_ in
                completion(n)
            }
            actions.append(action)
        }
       let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil )
       
        for a in actions {
            alertController.addAction(a)
        }
       alertController.addAction(cancelAction)
       self.present(alertController, animated: true, completion: nil)
   }

    
    private func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
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
        let numbers = contacts[indexPath.row].phoneNumber
        if numbers.count > 1 {
            tapCell(numbers: numbers) { number in
                DispatchQueue.main.async {
                    self.delegate?.present(name: userName, number: number)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            self.delegate?.present(name: userName, number: numbers.first ?? "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
