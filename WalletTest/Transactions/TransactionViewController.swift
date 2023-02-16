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
    var wallets = [Wallet]()
    var transactions = [Transaction]()
    var index = 0
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(TransactionsTableViewCell.self, forCellReuseIdentifier: "transCell")
        return tableView
    }()
    
    private let walletLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        label.textColor = .black
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wallets = coreManager.wallets(user: user)
        self.setupView()
        self.gestureFromLabel()
        self.setupNavigationBar()
        if self.wallets.count > 0 {
            self.updateTransactions()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentReachabilityStatus == .notReachable {
            self.alertOk(title: "Проверьте интернет соединение", message: nil)
        }
        self.wallets = coreManager.wallets(user: user)
        if self.wallets.count > 0 {
            self.updateTransactions()
        }
        self.tableView.reloadData()
    }
    private func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    private func setupNavigationBar() {
        self.navigationItem.title = "Транзакции"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = .systemRed
    }
    
    private func updateTransactions() {
        let wallet = self.wallets[index]
        guard let id = wallet.id else {return}
        self.transactions = self.coreManager.transaction(wallet: wallet)
        guard let nameWallet = self.wallets[index].nameWallet else { return }
        guard let balance = self.wallets[index].balance else { return }
        walletLabel.text = " " + nameWallet + " " + balance + "₽"
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        networkManager.transactions(id: id) { trans in
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            self.coreManager.createTransactions(transactions: trans, wallet: wallet) {
                self.transactions = self.coreManager.transaction(wallet: wallet)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.walletLabel)
        self.view.addSubview(self.fromInLabel)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicator)
        
        
        NSLayoutConstraint.activate([
            
            self.fromInLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            self.fromInLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromInLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.walletLabel.topAnchor.constraint(equalTo: self.fromInLabel.bottomAnchor, constant: 16),
            self.walletLabel.heightAnchor.constraint(equalToConstant: 80),
            self.walletLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.walletLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            self.tableView.topAnchor.constraint(equalTo: self.walletLabel.bottomAnchor,constant: 10),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.fromInLabel.centerYAnchor),
        ])
    }
    
    @objc private func tapFromLabel() {
        self.wallets = coreManager.wallets(user: user)
        let popVC = MenuTableViewController(wallet: self.wallets)
        popVC.modalPresentationStyle = .popover
        popVC.delegate = self
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.walletLabel
        popOverVC?.sourceRect = CGRect(x: self.walletLabel.bounds.midX, y: self.walletLabel.bounds.maxY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
    }
    
    private func gestureFromLabel(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapFromLabel))
        gesture.numberOfTapsRequired = 1
        self.walletLabel.addGestureRecognizer(gesture)
    }
}
extension TransactionViewController:  UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension TransactionViewController:  TableViewDelegate {
    func transferNameWallet(index: Int, view: UIView) {
        let label = view as! UILabel
        guard let nameWallet = self.wallets[index].nameWallet else { return }
        guard let balance = self.wallets[index].balance else { return }
        label.text = " " + nameWallet + " " + balance + "₽"
        label.tag = index
        self.index = index
        let wallet = self.wallets[index]
        guard let id = self.wallets[index].id else {return}
        self.transactions = self.coreManager.transaction(wallet: wallet)
        self.tableView.reloadData()
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        networkManager.transactions(id: id) { trans in
            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            self.coreManager.createTransactions(transactions: trans, wallet: wallet) {
                self.transactions = self.coreManager.transaction(wallet: wallet)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension TransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transCell", for: indexPath) as! TransactionsTableViewCell
        cell.setup(transaction: self.transactions[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = self.walletLabel.tag
        let wallet = self.wallets[index]
        let transaction = self.transactions[indexPath.row]
        self.navigationController?.pushViewController(DetailTransViewController(transaction: transaction, wallet: wallet), animated: true)
    }
}
