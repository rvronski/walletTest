//
//  TabBarViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 27.01.2023.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate  {
    
    let user: User
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        self.setupTabBar()
    }
    var layerHeight = CGFloat()
    func setupTabBar() {
        let layer = CAShapeLayer()
        
        
        let firstVC = UINavigationController(rootViewController: MainViewController(user: self.user))
        let secondVC = UINavigationController(rootViewController: TransactionViewController(user: self.user))
        let thirdVC = UINavigationController(rootViewController: SettingsViewController(user: self.user))
        self.viewControllers = [firstVC, secondVC, thirdVC]
        let itemsImage = ["creditcard", "arrow.left.arrow.right.square","hammer" ]
        let selectedImage = ["creditcard.fill", "arrow.left.arrow.right.square.fill","hammer.fill" ]
        firstVC.title = "Главная"
        secondVC.title = "Транзакции"
        thirdVC.title = "Настройки"
        guard let items = self.tabBar.items else {return}
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: itemsImage[i])
            items[i].selectedImage = UIImage(systemName: selectedImage[i])
        }
        
        let x: CGFloat = 10
        let y: CGFloat = 10
        
        let width = self.tabBar.bounds.width - x * 2
        let height = self.tabBar.bounds.height + y * 1.5
        layerHeight = height
        layer.fillColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.path = UIBezierPath(roundedRect: CGRect(x: x,
                                                      y: self.tabBar.bounds.minY - y,
                                                      width: width,
                                                      height: height),
                                  cornerRadius: height / 2).cgPath
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1
        
        self.tabBar.layer.insertSublayer(layer, at: 0)
        self.tabBar.tintColor = .systemRed
        self.tabBar.itemWidth = width/6
        self.tabBar.itemPositioning = .automatic
        self.tabBar.unselectedItemTintColor = .black
        
    }
}
