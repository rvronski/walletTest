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
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setup(transaction: Transaction)  {
        let sum = transaction.amount ?? "0"
        guard let sum1 = Int(sum) else {return}
        if sum1 < 0 {
            self.sumLabel.textColor = .systemRed
            self.sumLabel.text = sum
        } else {
            self.sumLabel.textColor = .systemGreen
            self.sumLabel.text = "+" + sum
        }
        self.operationLabel.text = transaction.reference
       
        self.dateLabel.text = transaction.stringDate
    }
    
    private func setupView(){
        
        self.contentView.addSubview(self.operationLabel)
        self.contentView.addSubview(self.sumLabel)
        self.contentView.addSubview(self.dateLabel)
        
        NSLayoutConstraint.activate([
            self.operationLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 10),
            self.operationLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.operationLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            self.operationLabel.widthAnchor.constraint(equalToConstant: 150),
            
            self.sumLabel.centerYAnchor.constraint(equalTo: self.operationLabel.centerYAnchor),
            self.sumLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -16),
            
            self.dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.dateLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 10),
            
            
            
            
        ])
        
        
    }
}
