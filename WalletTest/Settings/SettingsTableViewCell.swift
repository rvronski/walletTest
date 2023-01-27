//
//  TableViewCell.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 27.01.2023.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    private lazy var setLabel: UILabel = {
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
    
    
    func setup(text: String) {
        self.setLabel.text = text
    }
    
    private func setupView(){
        
        self.contentView.addSubview(self.setLabel)
       
        
        NSLayoutConstraint.activate([
            self.setLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.setLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
           
            
          
            
            
            
            
        ])
        
        
    }
    
}
