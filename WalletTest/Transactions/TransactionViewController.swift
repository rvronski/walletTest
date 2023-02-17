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
    var user: User
    let email = UserDefaults.standard.string(forKey: "email")
    var wallets = [Wallet]()
    var transactions = [Transaction]()
    var indexFrom = 0
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
    
    private lazy var transferView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9294117689, green: 0.9294117093, blue: 0.9294117689, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.right.to.line.compact"), for: .normal)
        button.tintColor = .systemYellow
        button.addTarget(self, action: #selector(nextWalletFrom), for: .touchUpInside)
        return button
    }()

    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "card")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let fromInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Со счета"
        label.font = UIFont.systemFont(ofSize: 15, weight: .thin)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let fromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
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
        } else {
            self.fromLabel.text = "Создайте счет"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentReachabilityStatus == .notReachable {
            self.alertOk(title: "Проверьте интернет соединение", message: nil)
        }
        self.indexFrom = 0
        guard let email else {return}
        coreManager.getUser(email: email) { user in
            guard let user else {return}
            self.user = user
        }
        self.wallets = coreManager.wallets(user: user)
        if self.wallets.count > 0 {
            self.updateTransactions()
        } else {
            self.fromLabel.text = "Создайте счет"
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
        let wallet = self.wallets[indexFrom]
        guard let id = wallet.id else {return}
        self.transactions = self.coreManager.transaction(wallet: wallet)
        guard let nameWallet = self.wallets[indexFrom].nameWallet else { return }
        guard let balance = self.wallets[indexFrom].balance else { return }
        fromLabel.text = " " + nameWallet + " " + balance + "₽"
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
        self.view.addSubview(self.transferView)
        self.transferView.addSubview(self.fromInLabel)
        self.transferView.addSubview(self.fromLabel)
        self.transferView.addSubview(self.cardImageView)
        self.transferView.addSubview(self.nextButton)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicator)
        
        
        NSLayoutConstraint.activate([
            
            self.transferView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            self.transferView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.transferView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.transferView.heightAnchor.constraint(equalToConstant: 120),
            
            self.fromInLabel.topAnchor.constraint(equalTo: self.transferView.topAnchor, constant: 10),
            self.fromInLabel.leftAnchor.constraint(equalTo: self.transferView.leftAnchor, constant: 16),
            
             
            self.cardImageView.centerYAnchor.constraint(equalTo: self.transferView.centerYAnchor),
            self.cardImageView.leftAnchor.constraint(equalTo: self.transferView.leftAnchor,constant: 20),
            self.cardImageView.widthAnchor.constraint(equalTo: self.transferView.widthAnchor, multiplier: 0.11),
            self.cardImageView.heightAnchor.constraint(equalTo: self.cardImageView.widthAnchor, multiplier: 0.75),
            
            self.nextButton.centerYAnchor.constraint(equalTo: self.transferView.centerYAnchor),
            self.nextButton.rightAnchor.constraint(equalTo: self.transferView.rightAnchor,constant: -10),
            self.nextButton.widthAnchor.constraint(equalToConstant: 16),
            
            self.fromLabel.centerYAnchor.constraint(equalTo: self.transferView.centerYAnchor),
            self.fromLabel.heightAnchor.constraint(equalToConstant: 80),
            self.fromLabel.leftAnchor.constraint(equalTo: self.cardImageView.rightAnchor, constant: 16),
            self.fromLabel.rightAnchor.constraint(equalTo: self.nextButton.leftAnchor),
            
            self.tableView.topAnchor.constraint(equalTo: self.transferView.bottomAnchor,constant: 10),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.fromInLabel.centerYAnchor),
        ])
    }
    
    @objc private func nextWalletFrom() {
        if (self.indexFrom + 1) == wallets.count {
            self.indexFrom = -1
        }
        self.indexFrom += 1
        
        let nameWalletFrom = wallets.isEmpty ? "Выберите счет" : wallets[self.indexFrom].nameWallet
        let balanceFrom = wallets.isEmpty ? "" : wallets[self.indexFrom].balance
        self.fromLabel.text = " " + nameWalletFrom! + " " + balanceFrom! + "₽"
        let view = self.fromLabel as UIView
        transferNameWallet(index: indexFrom, view: view)
        self.tableView.reloadData()
    }
    
    
    @objc private func tapFromLabel() {
        self.wallets = coreManager.wallets(user: user)
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
        let label = view as! UILabel
        guard let nameWallet = self.wallets[index].nameWallet else { return }
        guard let balance = self.wallets[index].balance else { return }
        label.text = " " + nameWallet + " " + balance + "₽"
        label.tag = index
        self.indexFrom = index
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
        let index = self.fromLabel.tag
        let wallet = self.wallets[index]
        let transaction = self.transactions[indexPath.row]
        self.navigationController?.pushViewController(DetailTransViewController(transaction: transaction, wallet: wallet), animated: true)
    }
}
