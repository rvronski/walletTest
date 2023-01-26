//
//  TransferViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 25.01.2023.
//

import UIKit

class TransferViewController: UIViewController {
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
    
    
//    private lazy var layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 16
//        layout.minimumInteritemSpacing = 16
//        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//        return layout
//    }()
//
//    private lazy var fromCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(CheckCollectionViewCell.self, forCellWithReuseIdentifier: "ChekCell")
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        return collectionView
//    }()
    
    private let toInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "На счет"
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
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
        label.layer.borderWidth = 0.09
        label.layer.cornerRadius = 30
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.isUserInteractionEnabled = true
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
        self.gestureToLabel()
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
        self.view.addSubview(self.toInLabel)
        self.view.addSubview(self.fromInLabel)
        self.view.addSubview(self.sumLabel)
        self.view.addSubview(self.sumTextField)
        self.view.addSubview(self.transferButton)
        
        
        NSLayoutConstraint.activate([
        
            self.fromInLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
            self.fromInLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromInLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.fromLabel.topAnchor.constraint(equalTo: self.fromInLabel.bottomAnchor, constant: 16),
            self.fromLabel.heightAnchor.constraint(equalToConstant: 80),
            self.fromLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            self.toInLabel.topAnchor.constraint(equalTo: self.fromLabel.bottomAnchor, constant: 16),
            self.toInLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.toInLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            self.toLabel.topAnchor.constraint(equalTo: self.toInLabel.bottomAnchor, constant: 16),
            self.toLabel.heightAnchor.constraint(equalToConstant: 80),
            self.toLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.toLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            self.sumLabel.topAnchor.constraint(equalTo: self.toLabel.bottomAnchor, constant: 30),
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
    
    @objc private func tapToLabel() {
         let popVC = MenuTableViewController(wallet: self.wallets)
        
        popVC.modalPresentationStyle = .popover
        popVC.delegate = self
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.toLabel
        popOverVC?.sourceRect = CGRect(x: self.toLabel.bounds.midX , y: self.toLabel.bounds.maxY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
    }
    
    
    
    private func gestureFromLabel(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapFromLabel))
        gesture.numberOfTapsRequired = 1
        self.fromLabel.addGestureRecognizer(gesture)
    }
    
    private func gestureToLabel(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapToLabel))
        gesture.numberOfTapsRequired = 1
        self.toLabel.addGestureRecognizer(gesture)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
    }
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapTransferButton() {
        guard let fromId = wallets[self.fromLabel.tag].id else { return }
        guard let toId = wallets[self.toLabel.tag].id else { return }
        guard (wallets[self.toLabel.tag].balance != nil) else {return}
        guard (wallets[self.fromLabel.tag].balance != nil) else {return}
        guard let sum1 = Int(wallets[self.fromLabel.tag].balance!) else { return }
        guard let sum2 = Int(wallets[self.toLabel.tag].balance!) else { return }
        guard sumTextField.text != nil else {return}
        guard let sum = Int(sumTextField.text!) else {return}
        
        let fromBalance = sum1 - sum
        let toBalance = sum2 + sum
        let fromNewBalance = String(fromBalance)
        let toNewBalance = String(toBalance)
        
        coreManager.changeBalance(id: fromId, newBalance: fromNewBalance) {
            self.coreManager.changeBalance(id: toId, newBalance: toNewBalance) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
extension TransferViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension TransferViewController: TableViewDelegate {
    func transferNameWallet(index: Int, view: UIView) {
        let label = view as! UILabel
        guard let nameWallet = wallets[index].nameWallet else { return }
        guard let balance = wallets[index].balance else { return }
        label.text = " " + nameWallet + " " + balance + "₽"
        label.tag = index
    }
}
//extension TransferViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return  self.wallets.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChekCell", for: indexPath) as! CheckCollectionViewCell
//
////        cell.setup(wallet: wallets[indexPath.row])
//        cell.setup(wallet: wallets[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let itemWidth = (collectionView.frame.width - 32)
////        let itemHeight = (collectionView.frame.height)
//        return CGSize(width: itemWidth, height: 150)
//
//    }
////
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if fromLabel.text == nil {
//            fromLabel.text = wallets[indexPath.row].nameWallet
//        } else {
//            toLabel.text = wallets[indexPath.row].nameWallet
//        }
//    }
//
//}
