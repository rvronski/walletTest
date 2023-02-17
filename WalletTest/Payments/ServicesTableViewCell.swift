//
//  ServicesTableViewCell.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 17.02.2023.
//

import UIKit

class ServicesTableViewCell: UITableViewCell {

        private lazy var setLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 20)
            return label
        }()

        private lazy var iconsImageView: UIImageView = {
            let view = UIImageView()
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super .init(style: style, reuseIdentifier: reuseIdentifier)
            self.setupView()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
       
        func setupServices(text: String, image: String) {
           
            self.iconsImageView.image = UIImage(named: image)
            self.setLabel.text = text
            
        }
        
        private func setupView(){
            self.iconsImageView.layer.cornerRadius = self.iconsImageView.bounds.width/2
            self.contentView.addSubview(self.iconsImageView)
            self.contentView.addSubview(self.setLabel)
        
            NSLayoutConstraint.activate([
                self.iconsImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 5),
                self.iconsImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -5),
                self.iconsImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor,constant: 16),
//                self.iconsImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                self.iconsImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.11),
                self.iconsImageView.heightAnchor.constraint(equalTo: self.iconsImageView.widthAnchor),
                
                self.setLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
                self.setLabel.leftAnchor.constraint(equalTo: self.iconsImageView.rightAnchor, constant: 16),
//                self.setLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -10),
                
            ])
            
            
        }
        
    }
