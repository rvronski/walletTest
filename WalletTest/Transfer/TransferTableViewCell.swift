//
//  TransferTableViewCell.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 26.01.2023.
//

import UIKit

class TransferTableViewCell: UITableViewCell {
    
    private lazy var cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "card")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private lazy var walletNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContacts() {
        
    }
    
    func setup(wallet: Wallet) {
        self.balanceLabel.text = "\(wallet.balance ?? "")  ₽"
        self.walletNameLabel.text = wallet.nameWallet
        
    }
    
    
    private func setupView() {
        self.contentView.addSubview(self.cardImageView)
        self.contentView.addSubview(self.balanceLabel)
        self.contentView.addSubview(self.walletNameLabel)
        
        
        NSLayoutConstraint.activate([
            
            self.cardImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.cardImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.cardImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10 ),
            self.cardImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.11),
            self.cardImageView.heightAnchor.constraint(equalTo: self.cardImageView.widthAnchor,multiplier: 0.75),
            
            self.walletNameLabel.centerYAnchor.constraint(equalTo: self.cardImageView.centerYAnchor),
            self.walletNameLabel.leftAnchor.constraint(equalTo: self.cardImageView.rightAnchor, constant: 10),
            self.walletNameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            self.balanceLabel.centerYAnchor.constraint(equalTo: self.cardImageView.centerYAnchor),
            self.balanceLabel.leftAnchor.constraint(equalTo: self.walletNameLabel.rightAnchor, constant: 16 ),
            self.balanceLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
        ])
    }
    
}
