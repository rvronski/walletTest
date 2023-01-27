//
//  AnotherTransferViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 25.01.2023.
//

import UIKit

class AnotherTransferViewController: UIViewController {
    
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
    
    
    private let fromInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Со счета"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.isUserInteractionEnabled = true
        return label
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
    
    private let toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.textAlignment = .center
        label.text = "Кому"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        return label
    }()
    
    private let sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сумма:"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = .systemRed
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var sumTextField: UITextField = {
        let sumTextField = UITextField()
        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        sumTextField.textColor = .black
        sumTextField.font = UIFont.systemFont(ofSize: 20)
        sumTextField.layer.borderColor = UIColor.lightGray.cgColor
        sumTextField.layer.borderWidth = 0.5
        sumTextField.layer.cornerRadius = 20
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        sumTextField.leftView = paddingView
        sumTextField.leftViewMode = .always
        return sumTextField
    }()
    
    private lazy var toTextField: UITextField = {
        let sumTextField = UITextField()
        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        sumTextField.textColor = .black
        sumTextField.font = UIFont.systemFont(ofSize: 20)
        sumTextField.layer.borderColor = UIColor.lightGray.cgColor
        sumTextField.layer.borderWidth = 0.5
        sumTextField.layer.cornerRadius = 20
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        sumTextField.leftView = paddingView
        sumTextField.leftViewMode = .always
        return sumTextField
    }()
    
    private lazy var transferButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перевести", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapTransferButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.wallets = coreManager.wallets(user: user)
        self.gestureFromLabel()
        self.setupNavigationBar()
        self.setupGesture()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Перевод"
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    private func setupView() {
        self.view.backgroundColor = .white
       
        self.view.addSubview(self.fromLabel)
        self.view.addSubview(self.toLabel)
        self.view.addSubview(self.fromInLabel)
        self.view.addSubview(self.sumLabel)
        self.view.addSubview(self.sumTextField)
        self.view.addSubview(self.transferButton)
        self.view.addSubview(self.toTextField)
        
        
        NSLayoutConstraint.activate([
        
            self.fromInLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            self.fromInLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromInLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.fromLabel.topAnchor.constraint(equalTo: self.fromInLabel.bottomAnchor, constant: 16),
            self.fromLabel.heightAnchor.constraint(equalToConstant: 80),
            self.fromLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            self.toLabel.topAnchor.constraint(equalTo: self.fromLabel.bottomAnchor, constant: 36),
            self.toLabel.heightAnchor.constraint(equalToConstant: 20),
            self.toLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            self.toTextField.centerYAnchor.constraint(equalTo: self.toLabel.centerYAnchor),
            self.toTextField.centerXAnchor.constraint(equalTo: self.sumTextField.centerXAnchor),
            self.toTextField.heightAnchor.constraint(equalToConstant: 50),
            self.toTextField.widthAnchor.constraint(equalToConstant: 200),
            
            self.sumLabel.topAnchor.constraint(equalTo: self.toLabel.bottomAnchor, constant: 46),
            self.sumLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            self.sumTextField.centerYAnchor.constraint(equalTo: self.sumLabel.centerYAnchor),
            self.sumTextField.leftAnchor.constraint(equalTo: self.sumLabel.rightAnchor, constant: 16),
            self.sumTextField.heightAnchor.constraint(equalToConstant: 50),
            self.sumTextField.widthAnchor.constraint(equalToConstant: 200),
            
            self.transferButton.topAnchor.constraint(equalTo: self.sumTextField.bottomAnchor, constant: 20),
            self.transferButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            self.transferButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -16),
            self.transferButton.heightAnchor.constraint(equalToConstant: 50),
            
        
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
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func didTapTransferButton() {
        guard  let fromText = self.fromLabel.text, !fromText.isEmpty,
              let toText = self.toTextField.text, !toText.isEmpty
              else {
            self.alertOk(title: "Ошибка!", message: "Укажите счета для перевода")
            return
        }
        guard sumTextField.text != nil else { self.alertOk(title: "Введите сумму", message: nil)
            return
        }
        
        guard  let text = self.sumTextField.text, !text.isEmpty
         else { self.alertOk(title: "Введите сумму", message: nil)
            return
        }
        
        guard Int(text) != nil else { self.alertOk(title: "Нельзя перевести буквы 😀", message: "Укажите сумму цифрами")
            return
        }
        guard let fromId = wallets[self.fromLabel.tag].id else { return }
        networkManager.debit(amount: text, id: fromId, reference: toText) { balance in
            self.coreManager.changeBalance(id: fromId, newBalance: balance) {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }
    }
}
extension AnotherTransferViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension AnotherTransferViewController: TableViewDelegate {
    func transferNameWallet(index: Int, view: UIView) {
        let label = view as! UILabel
        guard let nameWallet = wallets[index].nameWallet else { return }
        guard let balance = wallets[index].balance else { return }
        label.text = " " + nameWallet + " " + balance + "₽"
        label.tag = index
    }
}
