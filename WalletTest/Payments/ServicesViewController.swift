//
//  PaymentsViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 10.02.2023.
//

import UIKit

class ServicesViewController: UIViewController {
    
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var services:[String] = ["Квартира", "Мобильная связь", "Интернет", "Транспорт","Телевидение"]

    private lazy var contactTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "PayCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }()
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigationBar()
    }
        
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentReachabilityStatus == .notReachable {
            self.alertOk(title: "Проверьте интернет соединение", message: nil)
        }
        self.contactTableView.reloadData()
    }
    
    private func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = "Оплата"
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
}
extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayCell", for: indexPath) as! SettingsTableViewCell
        cell.setup(text: services[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            self.navigationController?.pushViewController(AnotherTransferViewController(user: self.user, isPhonePayments: true), animated: true)
        } else {
            self.self.navigationController?.pushViewController(PaymentsViewController(user: self.user, titleScreen: self.services[indexPath.row]), animated: true)
        }
        
    }
    
}

    
