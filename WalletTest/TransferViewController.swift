//
//  TransferViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 25.01.2023.
//

import UIKit

class TransferViewController: UIViewController {
    let coreManager = CoreDataManager.shared
    let user: User
    var wallets = [Wallet]()
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return layout
    }()
    
    private lazy var fromCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CheckCollectionViewCell.self, forCellWithReuseIdentifier: "ChekCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let fromLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.layer.borderWidth = 0.09
        label.layer.cornerRadius = 30
        return label
    }()
    
    private let toLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .white
        label.layer.borderWidth = 0.09
        label.layer.cornerRadius = 30
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.wallets = coreManager.wallets(user: user)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.fromCollectionView)
        self.view.addSubview(self.fromLabel)
        self.view.addSubview(self.toLabel)
        
        
        
        NSLayoutConstraint.activate([
        
            self.fromCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.fromCollectionView.heightAnchor.constraint(equalToConstant: 200),
            self.fromCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.fromCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.fromLabel.topAnchor.constraint(equalTo: self.fromCollectionView.bottomAnchor, constant: 25),
            self.fromLabel.heightAnchor.constraint(equalToConstant: 50),
            self.fromLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.fromLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
            self.toLabel.topAnchor.constraint(equalTo: self.fromLabel.bottomAnchor, constant: 16),
            self.toLabel.heightAnchor.constraint(equalToConstant: 50),
            self.toLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.toLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            
        
        ])
    }
    @objc private func didTapWalletButton() {
        self.alertAction()
    }
    
    private func alertAction() {
        let alertController = UIAlertController(title: "Создать новый кошелек?", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Имя кошелька"
        }

        let saveAction = UIAlertAction(title: "Создать", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard let name = firstTextField.text else {return}
           
            NetworkManager().createWallet(name: name) { wallet in
                self.coreManager.createWallet(newWallet: wallet, user: self.user) {
                    DispatchQueue.main.async {
                        self.wallets = self.coreManager.wallets(user: self.user)
                        self.fromCollectionView.reloadData()
                    }
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil )


        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    
    }

}
extension TransferViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return  self.wallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChekCell", for: indexPath) as! CheckCollectionViewCell
        
//        cell.setup(wallet: wallets[indexPath.row])
        cell.setup(wallet: wallets[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (collectionView.frame.width - 32)
//        let itemHeight = (collectionView.frame.height)
        return CGSize(width: itemWidth, height: 150)
        
    }
//    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if fromLabel.text == nil {
            fromLabel.text = wallets[indexPath.row].nameWallet
        } else {
            toLabel.text = wallets[indexPath.row].nameWallet
        }
    }
    
}
