//
//  CheckCollectionViewCell.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 24.01.2023.
//

import UIKit

class CheckCollectionViewCell: UICollectionViewCell {
    
    private lazy var walletView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
//        view.layer.borderWidth = 0.1
        view.layer.shadowOffset = CGSize(width: 16, height: 16)
        view.layer.shadowRadius = 5.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        return view
    }()
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        NSLayoutConstraint.activate([
            self.walletView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.walletView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.walletView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.walletView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            
        ])
    }
}
