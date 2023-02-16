//
//  AnotherTransferViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 25.01.2023.
//

import UIKit
import Contacts
class AnotherTransferViewController: UIViewController {

    let networkManager = NetworkManager.shared
    let coreManager = CoreDataManager.shared
    let user: User
    var wallets = [Wallet]()
    var contactName = String()
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
    
    private let contactImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "phone.fill.arrow.up.right")
        view.clipsToBounds = true
        view.tintColor = .systemRed
        return view
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
    
    private lazy var toTextLabel: UILabel = {
        let sumTextField = UILabel()
        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        sumTextField.textColor = .black
        sumTextField.font = UIFont.systemFont(ofSize: 20)
        sumTextField.layer.borderColor = UIColor.lightGray.cgColor
        sumTextField.layer.borderWidth = 0.5
        sumTextField.layer.cornerRadius = 20
        sumTextField.text = "Кому перевести" 
        sumTextField.textAlignment = .center
        sumTextField.isUserInteractionEnabled = true
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.wallets = coreManager.wallets(user: user)
        self.gestureFromLabel()
        self.setupNavigationBar()
        self.setupGesture()
        self.gesture()
        let nameWalletFrom = wallets.first?.nameWallet ?? "Выберите счет"
        let balanceFrom = wallets.first?.balance ?? ""
        self.fromLabel.text = " " + nameWalletFrom + " " + balanceFrom + "₽"
       
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Перевод"
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentReachabilityStatus == .notReachable {
            self.alertOk(title: "Проверьте интернет соединение", message: nil)
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.fromLabel)
        self.view.addSubview(self.contactImage)
        self.view.addSubview(self.fromInLabel)
        self.view.addSubview(self.sumLabel)
        self.view.addSubview(self.sumTextField)
        self.view.addSubview(self.transferButton)
        self.view.addSubview(self.toTextLabel)
        self.view.addSubview(self.activityIndicator)
        
        
        NSLayoutConstraint.activate([
            
            self.fromInLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            self.fromInLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromInLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.fromLabel.topAnchor.constraint(equalTo: self.fromInLabel.bottomAnchor, constant: 16),
            self.fromLabel.heightAnchor.constraint(equalToConstant: 80),
            self.fromLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            self.contactImage.topAnchor.constraint(equalTo: self.fromLabel.bottomAnchor, constant: 36),
            self.contactImage.heightAnchor.constraint(equalToConstant: 30),
            self.contactImage.widthAnchor.constraint(equalToConstant: 30),
            self.contactImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            self.toTextLabel.centerYAnchor.constraint(equalTo: self.contactImage.centerYAnchor),
            self.toTextLabel.leftAnchor.constraint(equalTo: self.contactImage.rightAnchor, constant: 16),
            self.toTextLabel.heightAnchor.constraint(equalToConstant: 50),
            self.toTextLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            self.sumLabel.topAnchor.constraint(equalTo: self.toTextLabel.bottomAnchor, constant: 46),
            self.sumLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            
            self.sumTextField.centerYAnchor.constraint(equalTo: self.sumLabel.centerYAnchor),
            self.sumTextField.leftAnchor.constraint(equalTo: self.sumLabel.rightAnchor, constant: 16),
            self.sumTextField.heightAnchor.constraint(equalToConstant: 50),
            self.sumTextField.widthAnchor.constraint(equalToConstant: 200),
            
            self.transferButton.topAnchor.constraint(equalTo: self.sumTextField.bottomAnchor, constant: 20),
            self.transferButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            self.transferButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -16),
            self.transferButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.fromInLabel.centerYAnchor),
            
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
    
    @objc private func tapContact() {
        let popVC = ContactViewController()
        self.navigationController?.pushViewController(popVC, animated: true)
        
    }
    
    private func gesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapContact))
        gesture.numberOfTapsRequired = 1
        self.toTextLabel.addGestureRecognizer(gesture)
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
               let toText = self.toTextLabel.text, !toText.isEmpty
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
        guard let sum1 = Int(wallets[self.fromLabel.tag].balance!) else { return }
        guard let sum2 = Int(text) else { return }
        if sum2 > sum1 {
            self.alertOk(title: "Cумма перевода превышает остаток", message: nil)
        } else {
            guard let fromId = wallets[self.fromLabel.tag].id else { return }
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            networkManager.debit(amount: text, id: fromId, reference: "Перевод \(toText)") { balance in
                self.coreManager.changeBalance(id: fromId, newBalance: balance) {
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.navigationController?.popViewController(animated: true)
                    }
                    
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
extension AnotherTransferViewController: ContactViewDelegate {
    func present(name: String) {
        self.toTextLabel.text = name
    }
    
    
}
