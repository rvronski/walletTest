//
//  WalletViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 21.01.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let networkManager = NetworkManager.shared
    let coreManager = CoreDataManager.shared
    let user: User
    var wallets = [Wallet]()
    
    let settings = ["Выйти из аккаунта", "Удалить счет", "Удалить аккаунт", "Очистить кэш"]
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero , style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "setCell")
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigationBar()
        self.wallets = coreManager.wallets(user: self.user)
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Настройки"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.tintColor = .systemYellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.wallets = coreManager.wallets(user: self.user)
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.activityIndicator)
        NSLayoutConstraint.activate([
            
            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            self.activityIndicator.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -16),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
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
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Настройки"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setCell", for: indexPath) as! SettingsTableViewCell
        cell.setup(text: settings[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 0 {
            UserDefaults.standard.set(false, forKey: "isLogin")
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            if self.wallets.count == 0 {
                self.alertOk(title: "У вас нет счетов", message: nil)
            } else {
                self.navigationController?.pushViewController(DeleteViewController(user: self.user), animated: true)
            }
        }
        if indexPath.section == 0 && indexPath.row == 2 {
            self.alertDismiss(title: "Вы уверенны что хотите удалить аккаунт?", message: "Операцию нельзя будет отменить. Все ваши счета автоматически удалятся") {
                if  self.wallets.count > 0 {
                    for i in self.wallets {
                        if i.balance != "0" {
                            self.alertOk(title: "Переведите деньги на другие счета", message: nil)
                            return
                        }
                    }
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    for i in self.wallets {
                        guard let id = i.id else {return}
                        self.networkManager.deleteWallet(id: id) {
                            self.coreManager.deleteUser(user: self.user) {
                                DispatchQueue.main.async {
                                    self.activityIndicator.isHidden = true
                                    self.activityIndicator.stopAnimating()
                                    UserDefaults.standard.set(false, forKey: "isLogin")
                                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                                }
                            }
                        }
                        
                    }
                } else {
                    self.coreManager.deleteUser(user: self.user) {
                        DispatchQueue.main.async {
                            self.activityIndicator.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.navigationController?.pushViewController(LoginViewController(), animated: true)
                        }
                    }
                }
                
            }
        }
        if indexPath.section == 0 && indexPath.row == 3 {
            self.alertDismiss(title: "Очистить кэш?", message: nil) {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                self.coreManager.deleteTransactions {
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.alertOk(title: "Кэш очищен", message: nil)
                    }
                }
            }
        }
    }
}
