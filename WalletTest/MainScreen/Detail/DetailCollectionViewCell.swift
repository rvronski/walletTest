//
//  DetailCollectionViewCell.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 24.01.2023.
//

//import UIKit
//
//protocol DetailCollectionViewDelegate: AnyObject {
//    func credit()
//}
//
//class DetailCollectionViewCell: UICollectionViewCell {
//    private lazy var walletView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 30
////        view.layer.borderWidth = 0.09
//        view.layer.shadowOffset = CGSize(width: 3, height: 3)
//        view.layer.shadowRadius = 5
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.6
//        return view
//    }()
//    
//    private lazy var rubleImageView: UIImageView = {
//       let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(systemName: "rublesign.circle")
//        imageView.tintColor = .systemRed
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    
//    var delegate: DetailCollectionViewDelegate?
//    
//    private lazy var balanceLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.systemFont(ofSize: 30)
//        return label
//    }()
//    
//    private lazy var creditButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Пополнить", for: .normal)
//        button.setTitleColor(.systemRed, for: .normal)
//        button.addTarget(self, action: #selector(tapCreditButton), for: .touchUpInside)
//        return button
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setup(wallet: Wallet) {
//        self.balanceLabel.text = "\(wallet.balance ?? "")  ₽"
//    }
//    
//    private func setupView() {
//        self.contentView.addSubview(self.walletView)
//        self.walletView.addSubview(self.balanceLabel)
//        self.walletView.addSubview(self.rubleImageView)
//        self.walletView.addSubview(self.creditButton)
//        
//        NSLayoutConstraint.activate([
//            
//            self.walletView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
//            self.walletView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
//            self.walletView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
//            self.walletView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
//            
//            self.rubleImageView.centerYAnchor.constraint(equalTo: self.walletView.centerYAnchor),
//            self.rubleImageView.leftAnchor.constraint(equalTo: self.walletView.leftAnchor, constant: 16),
//            self.rubleImageView.heightAnchor.constraint(equalTo: self.walletView.heightAnchor, multiplier: 0.3),
//            self.rubleImageView.widthAnchor.constraint(equalTo: self.rubleImageView.heightAnchor),
//            
//            self.balanceLabel.centerYAnchor.constraint(equalTo: self.rubleImageView.centerYAnchor),
//            self.balanceLabel.leftAnchor.constraint(equalTo: self.rubleImageView.rightAnchor, constant: 16),
//            
//            self.creditButton.centerYAnchor.constraint(equalTo: self.walletView.centerYAnchor),
//            self.creditButton.rightAnchor.constraint(equalTo: self.walletView.rightAnchor, constant: -16),
//        ])
//    }
//    
//    @objc private func tapCreditButton() {
//        self.delegate?.credit()
//    }
//    
//}
