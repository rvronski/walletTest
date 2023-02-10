//
//  DetailTransViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 27.01.2023.
//

import UIKit

class DetailTransViewController: UIViewController {
    
    let wallet: Wallet
    let transaction: Transaction
    
    init(transaction: Transaction, wallet: Wallet) {
        self.transaction = transaction
        self.wallet = wallet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var transferView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    
    private lazy var operationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = transaction.reference
        label.textAlignment = .center
        return label
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 40)
        label.text = transaction.stringDate
        return label
    }()
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "CardImageNewMW")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupNavigationBar()
        let sum = transaction.amount ?? "0"
        guard let sum1 = Int(sum) else {return}
        if sum1 < 0 {
            self.sumLabel.textColor = .systemRed
            self.sumLabel.text = sum
        } else {
            self.sumLabel.textColor = .systemGreen
            self.sumLabel.text = "+" + sum
        }
    }
   private func setupNavigationBar() {
       self.navigationItem.title = self.transaction.stringDate
       self.navigationController?.navigationBar.prefersLargeTitles = false
       self.navigationController?.setNavigationBarHidden(false, animated: false)
       self.navigationController?.navigationBar.tintColor = .systemRed
    }
    
    private func setupView(){
        self.view.backgroundColor = .white
        self.view.addSubview(self.transferView)
        self.transferView.addSubview(self.operationLabel)
        self.transferView.addSubview(self.sumLabel)
        self.transferView.addSubview(self.dateLabel)
        self.transferView.addSubview(self.cardImageView)
        
        self.view.addSubview(self.sumLabel)
        self.view.addSubview(self.dateLabel)
        
        NSLayoutConstraint.activate([
            
            self.transferView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.transferView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.transferView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.transferView.heightAnchor.constraint(equalToConstant: 350),
            
            
            self.dateLabel.centerXAnchor.constraint(equalTo: self.transferView.centerXAnchor),
            self.dateLabel.topAnchor.constraint(equalTo: self.transferView.topAnchor,constant: 20),
            
            self.operationLabel.centerYAnchor.constraint(equalTo: self.transferView.centerYAnchor),
            self.operationLabel.leftAnchor.constraint(equalTo: self.transferView.leftAnchor, constant: 16),
            self.operationLabel.widthAnchor.constraint(equalToConstant: 300),
            
            self.sumLabel.centerYAnchor.constraint(equalTo: self.operationLabel.centerYAnchor),
            self.sumLabel.rightAnchor.constraint(equalTo: self.transferView.rightAnchor, constant: -16),
            
            self.cardImageView.bottomAnchor.constraint(equalTo: self.transferView.bottomAnchor,constant: -20),
            self.cardImageView.centerXAnchor.constraint(equalTo: self.transferView.centerXAnchor),
            self.cardImageView.heightAnchor.constraint(equalToConstant: 50),
            self.cardImageView.widthAnchor.constraint(equalToConstant: 75),
            
        ])
    }
}
