//
//  StoriesCollectionViewCell.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 08.02.2023.
//

import UIKit

class StoriesCollectionViewCell: UICollectionViewCell {
    
    
    
    lazy var backgroundImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(named: "background_image")
        imageView.layer.cornerRadius = self.frame.width/2
        imageView.layer.borderColor = UIColor.systemRed.cgColor
        imageView.layer.borderWidth = 5
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupImage(image: UIImage) {
        self.backgroundImageView.image = image
    }
    
    func changeColor() {
        backgroundImageView.layer.borderColor = UIColor.white.cgColor
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.backgroundImageView.layer.cornerRadius = self.backgroundImageView.frame.height/2
//    }
    
    private func setupView() {
        self.contentView.addSubview(self.backgroundImageView)
        
        
        NSLayoutConstraint.activate([
            
            self.backgroundImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.backgroundImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor),
            self.backgroundImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
        ])
    }
    
}