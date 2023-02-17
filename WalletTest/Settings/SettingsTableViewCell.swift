//
//  TableViewCell.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 27.01.2023.
//

import UIKit
import Contacts
class SettingsTableViewCell: UITableViewCell {

    private lazy var setLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    private lazy var stackView: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var numberLabel = WeatherLabels(size: 14, weight: .light, color: .black)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContact(contact: PhoneContact) {
        self.setLabel.text = contact.givenName + "" + contact.familyName
        let text = contact.phoneNumber
        if text.count > 1 {
            self.numberLabel.text = "\(text.first ?? "") и еще \(text.count - 1)"
        } else {
            self.numberLabel.text = text.first?.trimmingCharacters(in: .whitespaces)
        }
        
    }
    
    func setup(text: String) {
        self.stackView.removeArrangedSubview(numberLabel)
        self.setLabel.text = text
        
    }
    
   
    private func setupView(){
        
        self.contentView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.setLabel)
        self.stackView.addArrangedSubview(self.numberLabel)
       
        
        
        NSLayoutConstraint.activate([
            
            
            
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.stackView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.numberLabel.leftAnchor.constraint(equalTo: self.stackView.leftAnchor),
          
            
//            self.numberLabel.topAnchor.constraint(equalTo: self.setLabel.bottomAnchor,constant: 10),
//            self.numberLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
//            self.numberLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -10),
            
        ])
        
        
    }
    
}
