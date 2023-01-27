//
//  PaymentsViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 21.01.2023.
//

import UIKit

class TransactionViewController: UIViewController {
   
    let networkManager = NetworkManager.shared
    let coreManager = CoreDataManager.shared
    let user: User
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var wallets = [Wallet]()
    
//    init(user: User) {
//        self.user = user
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.estimatedRowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
//        tableView.register(InfoTableVIewCell.self, forCellReuseIdentifier: "InfoCell")
        return tableView
    }()
    
    private let fromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 30
        label.layer.borderWidth = 0.09
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let fromInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Со счета"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wallets = coreManager.wallets(user: self.user)
        self.setupView()
        self.gestureFromLabel()
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Транзакции"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = .systemRed
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.fromLabel)
        self.view.addSubview(self.fromInLabel)
        self.view.addSubview(self.tableView)
        
        
        NSLayoutConstraint.activate([
        
            self.fromInLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            self.fromInLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromInLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.fromLabel.topAnchor.constraint(equalTo: self.fromInLabel.bottomAnchor, constant: 16),
            self.fromLabel.heightAnchor.constraint(equalToConstant: 80),
            self.fromLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            self.tableView.topAnchor.constraint(equalTo: self.fromLabel.bottomAnchor,constant: 10),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            
        ])
    }
    
    @objc private func tapFromLabel() {
         let popVC = MenuTableViewController(wallet: self.wallets)
        
        popVC.modalPresentationStyle = .popover
        popVC.delegate = self
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.fromLabel
        popOverVC?.sourceRect = CGRect(x: self.fromLabel.bounds.midX, y: self.fromLabel.bounds.maxY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
            
    }
    
    private func gestureFromLabel(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapFromLabel))
        gesture.numberOfTapsRequired = 1
        self.fromLabel.addGestureRecognizer(gesture)
    }
}
extension TransactionViewController:  UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension TransactionViewController:  TableViewDelegate {
    func transferNameWallet(index: Int, view: UIView) {
        func transferNameWallet(index: Int, view: UIView) {
            let label = view as! UILabel
            guard let nameWallet = wallets[index].nameWallet else { return }
            guard let balance = wallets[index].balance else { return }
            label.text = " " + nameWallet + " " + balance + "₽"
            label.tag = index
        }
    }
}
extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        namesResidents.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! TransactionsTableViewCell
       
        return cell
        
    }
}
