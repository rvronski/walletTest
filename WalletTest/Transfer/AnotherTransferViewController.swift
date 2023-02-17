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
    var indexFrom = 0
    var isPhonePayments:Bool
    var wallets = [Wallet]()
    var contactName = String()
    init(user: User, isPhonePayments: Bool) {
        self.user = user
        self.isPhonePayments = isPhonePayments
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    private let contactImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "contactBook")
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
//        view.tintColor = #colorLiteral(red: 0.05413367599, green: 0.5092155337, blue: 0.7902257442, alpha: 1)
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
    
    private lazy var toNameLabel: UILabel = {
        let sumTextField = UILabel()
        sumTextField.translatesAutoresizingMaskIntoConstraints = false
        sumTextField.textColor = .black
        sumTextField.font = UIFont.systemFont(ofSize: 15)
        sumTextField.layer.borderColor = UIColor.lightGray.cgColor
        sumTextField.textAlignment = .center
        sumTextField.isUserInteractionEnabled = true
        return sumTextField
    }()
    
    private lazy var numberLabel = WeatherLabels(size: 20, weight: .regular, color: .black)
    private lazy var transferButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let title = isPhonePayments ? "Оплатить" : "Перевести"
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemYellow
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
        self.gestureImage()
        let nameWalletFrom = wallets.isEmpty ? "Выберите счет" : wallets[indexFrom].nameWallet
        let balanceFrom = wallets.isEmpty ? "" : wallets[indexFrom].balance 
        self.fromLabel.text = " " + nameWalletFrom! + " " + balanceFrom! + "₽"
        self.numberLabel.isUserInteractionEnabled = true
    }
    
    private func setupNavigationBar() {
        let title = isPhonePayments ? "Оплата телефона" : "Перевод"
        self.navigationItem.title = title
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentReachabilityStatus == .notReachable {
            self.alertOk(title: "Проверьте интернет соединение", message: nil)
        }
        self.indexFrom = 0
        let nameWalletFrom = wallets.isEmpty ? "Выберите счет" : wallets[indexFrom].nameWallet
        let balanceFrom = wallets.isEmpty ? "" : wallets[indexFrom].balance
        self.fromLabel.text = " " + nameWalletFrom! + " " + balanceFrom! + "₽"
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.transferView)
        self.transferView.addSubview(self.fromInLabel)
        self.transferView.addSubview(self.fromLabel)
        self.transferView.addSubview(self.cardImageView)
        self.transferView.addSubview(self.nextButton)
        self.view.addSubview(self.contactImage)
        self.view.addSubview(self.sumLabel)
        self.view.addSubview(self.sumTextField)
        self.view.addSubview(self.transferButton)
        self.view.addSubview(self.toNameLabel)
        self.view.addSubview(self.numberLabel)
        self.view.addSubview(self.activityIndicator)
        self.numberLabel.text =  isPhonePayments ? "Номер телефона" : "Кому перевести"
        self.numberLabel.textAlignment = .left
        NSLayoutConstraint.activate([
//
//            <NSLayoutYAxisAnchor:0x6000034ec780 \"UIImageView:0x7fbb1e143800.top\"> and <NSLayoutYAxisAnchor:0x6000034ec600 \"UIView:0x7fbb1e339430.bottom\"> because they have no common ancestor.  Does the constraint or its anchors reference items in different view hierarchies?  That's illegal."
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
            
            self.contactImage.topAnchor.constraint(equalTo: self.transferView.bottomAnchor, constant: 50),
            self.contactImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.16),
            self.contactImage.heightAnchor.constraint(equalTo: self.contactImage.widthAnchor),
           
            self.contactImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),

            self.numberLabel.centerYAnchor.constraint(equalTo: self.contactImage.centerYAnchor),
            self.numberLabel.leftAnchor.constraint(equalTo: self.contactImage.rightAnchor, constant: 16),
            self.numberLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),

            self.toNameLabel.bottomAnchor.constraint(equalTo: self.numberLabel.topAnchor, constant: -10),
            self.toNameLabel.leftAnchor.constraint(equalTo: self.numberLabel.leftAnchor),
            
            self.sumLabel.topAnchor.constraint(equalTo: self.numberLabel.bottomAnchor, constant: 46),
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
    
    
    @objc private func nextWalletFrom() {
        if (self.indexFrom + 1) == wallets.count {
            self.indexFrom = -1
        }
        self.indexFrom += 1
       
            let nameWalletFrom = wallets.isEmpty ? "Выберите счет" : wallets[self.indexFrom].nameWallet
            let balanceFrom = wallets.isEmpty ? "" : wallets[self.indexFrom].balance
           
            self.fromLabel.text = " " + nameWalletFrom! + " " + balanceFrom! + "₽"
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
        popVC.delegate = self
        self.navigationController?.pushViewController(popVC, animated: true)
        
    }
    
    private func gesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapContact))
        gesture.numberOfTapsRequired = 1
        self.numberLabel.addGestureRecognizer(gesture)
    }
    
    private func gestureImage(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapContact))
        gesture.numberOfTapsRequired = 1
        self.contactImage.addGestureRecognizer(gesture)
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
               let toText = self.toNameLabel.text, !toText.isEmpty
        else {
            let title = isPhonePayments ? "Укажите счет и номер телефона" : "Укажите счета для перевода"
            self.alertOk(title: "Ошибка!", message: title)
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
        guard let sum1 = Int(wallets[self.indexFrom].balance!) else { return }
        guard let sum2 = Int(text) else { return }
        if sum2 > sum1 {
            let title = isPhonePayments ? "Cумма оплаты превышает остаток" : "Cумма перевода превышает остаток"
            self.alertOk(title: title, message: nil)
        } else {
            guard let fromId = wallets[self.indexFrom].id else { return }
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            let title = isPhonePayments ? "Оплата мобильной связи \(toText)" : "Перевод \(toText)"
            networkManager.debit(amount: text, id: fromId, reference: title) { balance in
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
        self.indexFrom = index
    }
}
extension AnotherTransferViewController: ContactViewDelegate {
    func present(name: String, number: String) {
        self.toNameLabel.text = name
        self.numberLabel.text = number
    }
    
    
}
