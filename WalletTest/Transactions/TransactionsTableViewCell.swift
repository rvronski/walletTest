//
//  TransactionsTableViewCell.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 27.01.2023.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {

    private lazy var operationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var sumLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
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
    
    
    func setup(transaction: Transaction) {
        self.operationLabel.text = transaction.reference
    }
    
    private func setupView(){
        
        self.contentView.addSubview(self.operationLabel)
//        self.contentView.addSubview(self.sumLabel)
//        self.contentView.addSubview(self.dateLabel)
        
        NSLayoutConstraint.activate([
            self.operationLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.operationLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.operationLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            self.operationLabel.widthAnchor.constraint(equalToConstant: 150),
            
            
            
        
        
        ])
        
        
    }
}
