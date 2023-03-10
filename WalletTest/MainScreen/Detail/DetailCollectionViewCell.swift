
//  DetailCollectionViewCell.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 24.01.2023.


import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    private lazy var walletView: UIView = {
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
    
    private lazy var rubleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "rublesign.circle")
        imageView.tintColor = .systemYellow
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private lazy var creditLable: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Пополнить"
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(wallet: Wallet) {
        self.balanceLabel.text = "\(wallet.balance ?? "")  ₽"
    }
    
    private func setupView() {
        self.contentView.addSubview(self.walletView)
        self.walletView.addSubview(self.balanceLabel)
        self.walletView.addSubview(self.rubleImageView)
        self.walletView.addSubview(self.creditLable)
        
        NSLayoutConstraint.activate([
            
            self.walletView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.walletView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.walletView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.walletView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            self.rubleImageView.centerYAnchor.constraint(equalTo: self.walletView.centerYAnchor),
            self.rubleImageView.leftAnchor.constraint(equalTo: self.walletView.leftAnchor, constant: 16),
            self.rubleImageView.heightAnchor.constraint(equalTo: self.walletView.heightAnchor, multiplier: 0.3),
            self.rubleImageView.widthAnchor.constraint(equalTo: self.rubleImageView.heightAnchor),
            
            self.balanceLabel.centerYAnchor.constraint(equalTo: self.rubleImageView.centerYAnchor),
            self.balanceLabel.leftAnchor.constraint(equalTo: self.rubleImageView.rightAnchor, constant: 16),
            
            self.creditLable.centerYAnchor.constraint(equalTo: self.walletView.centerYAnchor),
            self.creditLable.rightAnchor.constraint(equalTo: self.walletView.rightAnchor, constant: -25),
        ])
    }
    
}
