//
//  ViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 21.01.2023.
//

import UIKit

class UserViewController: UIViewController {
    private let coreManager = CoreDataManager.shared
    private var isBackView = false
    let user: User
    let wallet: Wallet
    var users = [User]()
    init(user: User, wallet: Wallet) {
        self.user = user
        self.wallet = wallet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Card View
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var cardImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "CardImageNewMW")
        return view
    }()
    
    private lazy var cardView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cardBackImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "BackCardImageNew")
        return view
    }()
    
    private lazy var cardBackView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .clear
        label.text = wallet.nameWallet ?? ""
        return label
    }()
    
    private lazy var cardCVCLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    // MARK: Wallet View
    
//    private lazy var layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 16
//        layout.minimumInteritemSpacing = 16
//        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//        return layout
//    }()
//
//    private lazy var detailCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCell")
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        return collectionView
//    }()
    
    private lazy var walletView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
//        view.layer.borderWidth = 0.09
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    private lazy var rubleImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "rublesign.circle")
        imageView.tintColor = .systemRed
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = wallet.balance
        return label
    }()
    
    private lazy var creditButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Пополнить", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(tapCreditButton), for: .touchUpInside)
        return button
    }()
   
    
   //MARK: Transfer View
    
    private lazy var transferView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
//        view.layer.borderWidth = 0.09
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    private lazy var transferImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "shuffle")
        imageView.tintColor = .systemRed
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var transferButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Перевести", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(tapTransButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.wallet = coreManager.users[counter].wallets
        self.setupView()
        self.gestureView()
        self.gestureBackView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.conteinerView)
        self.view.addSubview(self.transferView)
        self.view.addSubview(self.walletView)
        self.walletView.addSubview(self.balanceLabel)
        self.walletView.addSubview(self.rubleImageView)
        self.walletView.addSubview(self.creditButton)
        self.conteinerView.addSubview(self.cardBackView)
        self.cardBackView.addSubview(self.cardBackImageView)
        self.cardBackView.addSubview(self.cardCVCLabel)
        self.conteinerView.addSubview(self.cardView)
        self.cardView.addSubview(self.cardImageView)
        self.cardView.addSubview(self.cardNameLabel)
        self.cardView.bringSubviewToFront(cardNameLabel)
        self.transferView.addSubview(self.transferImageView)
        self.transferView.addSubview(self.transferButton)
       
        
        NSLayoutConstraint.activate([
            
            self.conteinerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.conteinerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.conteinerView.heightAnchor.constraint(equalToConstant: 185),
            self.conteinerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 51),
            self.conteinerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -51),
            
            self.cardBackView.topAnchor.constraint(equalTo: self.conteinerView.topAnchor),
            self.cardBackView.trailingAnchor.constraint(equalTo: self.conteinerView.trailingAnchor),
            self.cardBackView.leadingAnchor.constraint(equalTo: self.conteinerView.leadingAnchor),
            self.cardBackView.bottomAnchor.constraint(equalTo: self.conteinerView.bottomAnchor),
            
            self.cardBackImageView.topAnchor.constraint(equalTo: self.cardBackView.topAnchor),
            self.cardBackImageView.trailingAnchor.constraint(equalTo: self.cardBackView.trailingAnchor),
            self.cardBackImageView.leadingAnchor.constraint(equalTo: self.cardBackView.leadingAnchor),
            self.cardBackImageView.bottomAnchor.constraint(equalTo: self.cardBackView.bottomAnchor),
            
            self.cardView.topAnchor.constraint(equalTo: self.conteinerView.topAnchor),
            self.cardView.trailingAnchor.constraint(equalTo: self.conteinerView.trailingAnchor),
            self.cardView.leadingAnchor.constraint(equalTo: self.conteinerView.leadingAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.conteinerView.bottomAnchor),
            
            self.cardImageView.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            self.cardImageView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.cardImageView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.cardImageView.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            
            self.cardNameLabel.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -10),
            self.cardNameLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            
            self.cardCVCLabel.trailingAnchor.constraint(equalTo: self.cardBackView.trailingAnchor, constant: -16),
            self.cardCVCLabel.topAnchor.constraint(equalTo: self.cardBackView.topAnchor, constant: 50),
            
            self.walletView.topAnchor.constraint(equalTo: self.conteinerView.bottomAnchor, constant: 16),
            self.walletView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.walletView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.walletView.heightAnchor.constraint(equalToConstant: 150),
            
            self.rubleImageView.centerYAnchor.constraint(equalTo: self.walletView.centerYAnchor),
            self.rubleImageView.leftAnchor.constraint(equalTo: self.walletView.leftAnchor, constant: 16),
            self.rubleImageView.heightAnchor.constraint(equalTo: self.walletView.heightAnchor, multiplier: 0.3),
            self.rubleImageView.widthAnchor.constraint(equalTo: self.rubleImageView.heightAnchor),
            
            self.balanceLabel.centerYAnchor.constraint(equalTo: self.rubleImageView.centerYAnchor),
            self.balanceLabel.leftAnchor.constraint(equalTo: self.rubleImageView.rightAnchor, constant: 16),
            
            self.creditButton.centerYAnchor.constraint(equalTo: self.walletView.centerYAnchor),
            self.creditButton.rightAnchor.constraint(equalTo: self.walletView.rightAnchor, constant: -16),
            
            self.transferView.topAnchor.constraint(equalTo: self.walletView.bottomAnchor, constant: 16),
            self.transferView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.transferView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.transferView.heightAnchor.constraint(equalToConstant: 150),
            
            self.transferImageView.centerYAnchor.constraint(equalTo: self.transferView.centerYAnchor),
            self.transferImageView.leftAnchor.constraint(equalTo: self.transferView.leftAnchor, constant: 16),
            self.transferImageView.heightAnchor.constraint(equalTo: self.transferView.heightAnchor, multiplier: 0.3),
            self.transferImageView.widthAnchor.constraint(equalTo: self.transferImageView.heightAnchor),
            
            self.transferButton.centerYAnchor.constraint(equalTo: self.transferImageView.centerYAnchor),
            self.transferButton.leftAnchor.constraint(equalTo: self.transferImageView.rightAnchor, constant: 16),
            
        ])
    }
    
    private func gestureView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(flip))
        gesture.numberOfTapsRequired = 1
        self.cardImageView.addGestureRecognizer(gesture)
    }
    
    private func gestureBackView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(flip))
        gesture.numberOfTapsRequired = 1
        self.cardBackImageView.addGestureRecognizer(gesture)
    }
    
    @objc private func flip() {
        
        let toView = isBackView ? self.cardView :  self.cardBackView
        let fromView = isBackView ? self.cardBackView : self.cardView
        
        UIView.transition(from: fromView, to: toView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews] )
        isBackView.toggle()
    }
    
    private func alertAction(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Введите сумму"
        }

        let saveAction = UIAlertAction(title: "Пополнить", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let text = firstTextField.text else {return}
            guard let id = self.wallet.id else {return}
            NetworkManager().credit(amount: text, id: id) { balance in
                self.coreManager.changeBalance(id: id, newBalance: balance) {
                    DispatchQueue.main.async {
                        self.balanceLabel.text = balance
                    }
                }
            }
            
            
        })

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil )


        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    
    }
    
    @objc private func tapTransButton() {
        let vc = TransferViewController(user: self.user)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc private func tapCreditButton() {
        self.alertAction(title: "Полнить баланс", message: nil)
    }
    
}
