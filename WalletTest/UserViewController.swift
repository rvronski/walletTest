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
    private var wallet = [Wallet]()
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
    
    
    private lazy var addUserButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
//        button.addTarget(self, action: #selector(createCard), for: .touchUpInside)
        return button
    }()
    
    private lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .clear
        label.text = wallet[0].userName ?? ""
        return label
    }()
    
    private let balanceView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemRed.withAlphaComponent(0.1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Баланс \(String(describing: wallet[0].balance ?? ""))"
        return label
    }()
    
    private lazy var cardCVCLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wallet = coreManager.wallet
        print("🍋 \(String(describing: wallet[0].id))")
        self.setupView()
        self.gestureView()
        self.gestureBackView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.conteinerView)
        self.view.addSubview(self.balanceView)
        self.balanceView.addSubview(self.balanceLabel)
        self.conteinerView.addSubview(self.cardBackView)
        self.cardBackView.addSubview(self.cardBackImageView)
        self.cardBackView.addSubview(self.cardCVCLabel)
        self.conteinerView.addSubview(self.cardView)
        self.cardView.addSubview(self.cardImageView)
//        self.cardView.addSubview(self.addUserButton)
        self.cardView.addSubview(self.cardNameLabel)
        self.cardView.bringSubviewToFront(cardNameLabel)
        
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
            
            self.balanceView.topAnchor.constraint(equalTo: self.conteinerView.bottomAnchor, constant: 20),
            self.balanceView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.balanceView.heightAnchor.constraint(equalToConstant: 100),
            self.balanceView.widthAnchor.constraint(equalToConstant: 120),
            
            self.balanceLabel.centerYAnchor.constraint(equalTo: self.balanceView.centerYAnchor),
            self.balanceLabel.centerXAnchor.constraint(equalTo: self.balanceView.centerXAnchor),
            
            
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
    
//    private func alertAction(title: String, message: String?, completionHandler: @escaping (String,String) -> Void) {
//
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alertController.addTextField()
//        alertController.addTextField()
////        alertController.textFields[0]
//
//        let ok = UIAlertAction(title: "ОК", style: .default) {[unowned alertController] _ in
//            guard  let name = alertController.textFields?[0] else {return}
//            let lastName = alertController.textFields?[1]
//            completionHandler(name,lastName)
//        }
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//        alertController.addAction(ok)
//        alertController.addAction(cancel)
////        alertController.view.addSubview(nameTextView)
////        alertController.view.addSubview(nameLastTextView)
//
//        present(alertController, animated: true, completion: nil)
//    }
//
//    @objc private func createCard() {
//        self.alertAction(title: "Выпустить новую карту?", message: nil) { name, lastName in
//            downloadCard { cards in
//                CoreDataManager().addUser(name: name, lastName: lastName, cards: cards) {
//                    DispatchQueue.main.async {
//
//                    }
//                }
//            }
//        }
//
//        self.cardImageView.image = UIImage(named: "CardImageNewMW")
//        self.cardBackImageView.image = UIImage(named: "BackCardImageNew")
//        self.cardNameLabel.backgroundColor = .clear
//        self.cardNameLabel.text = "Roman Vronsky"
//        self.cardCVCLabel.text = "CVC"
//        self.cardNumberLabel.text = "1234 5678 9012 3456"
//        self.cardInvalidDateLabel.text = "12/25"
//        self.cardView.bringSubviewToFront(cardNameLabel)
//        self.addUserButton.isHidden = true
//        self.addUserButton.isEnabled = true
//    }
}

