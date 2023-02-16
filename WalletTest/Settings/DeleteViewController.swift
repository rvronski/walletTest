//
//  DeleteViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 27.01.2023.
//

import UIKit

class DeleteViewController: UIViewController {
  
    
    
    let networkManager = NetworkManager.shared
    let coreManager = CoreDataManager.shared
    let user: User
    var wallets = [Wallet]()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero , style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(TransferTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigationBar()
        self.wallets = coreManager.wallets(user: self.user)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Удалить счет"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = .systemYellow
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wallets = coreManager.wallets(user: self.user)
        self.tableView.reloadData()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            
            
        ])
        
        
    }
    
    private func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    private func alertDismiss(title: String, message: String?, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .destructive) { _ in
            completionHandler()
        }
        let cancel = UIAlertAction(title: "Отмена", style: .default)
        alertController.addAction(ok)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}
extension DeleteViewController:  UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransferTableViewCell
        cell.setup(wallet: wallets[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.alertDismiss(title: "Удалить счет?", message: nil) {
            self.tableView(self.tableView, commit: .delete, forRowAt: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let walletForDel = wallets[indexPath.row]
            if walletForDel.balance == "0" {
                let nameWallet = walletForDel.nameWallet
                guard let id = wallets[indexPath.row].id else {return}
                wallets.remove(at: indexPath.row)
                self.coreManager.deleteWallet(wallet: walletForDel)
                tableView.deleteRows(at: [indexPath], with: .fade)
                networkManager.deleteWallet(id: id) {
                    DispatchQueue.main.async {
                        self.alertOk(title: "Счет \(nameWallet ?? "") удален", message: nil )
                    }
                }
            } else {
                self.alertOk(title: "Для удаления переведите деньги на другой счет", message: nil )
            }
        } else if editingStyle == .insert {
            //
        }
    }
}
