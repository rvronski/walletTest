//
//  MainViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 24.01.2023.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
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
    
    private let fetchResultController: NSFetchedResultsController = {
        let fetchRequest = Wallet.fetchRequest()
        fetchRequest.sortDescriptors = []
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return layout
    }()
    
    private lazy var addWalletButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать кошелек", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapWalletButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var chekCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CheckCollectionViewCell.self, forCellWithReuseIdentifier: "ChekCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var transferView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
//        view.layer.borderWidth = 0.09
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.wallets = coreManager.wallets(user: user)
        fetchResultController.delegate = self
        try? self.fetchResultController.performFetch()
        self.setupNavigationBar()
        print(wallets[0].id)
//        print(wallets[1].id)
        
    }
    
    private func setupNavigationBar() {
        self.navigationItem.title = "Мои счета"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = .systemRed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chekCollectionView.reloadData()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.chekCollectionView)
        self.view.addSubview(self.addWalletButton)
        
        NSLayoutConstraint.activate([
        
            self.addWalletButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            self.addWalletButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            self.addWalletButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -16),
            self.addWalletButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.chekCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.chekCollectionView.bottomAnchor.constraint(equalTo: self.addWalletButton.topAnchor),
            self.chekCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.chekCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
        
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
                        self.chekCollectionView.reloadData()
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
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
//        return  self.wallets.count÷
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChekCell", for: indexPath) as! CheckCollectionViewCell
        
//        cell.setup(wallet: wallets[indexPath.row])
        cell.setup(wallet: fetchResultController.object(at: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (collectionView.frame.width - 32)
//        let itemHeight = (collectionView.frame.height)
        return CGSize(width: itemWidth, height: 150)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let walletVC = UserViewController(user: user, wallet: wallets[indexPath.row])
        self.navigationController?.pushViewController(walletVC, animated: true)
    }
    
}
extension MainViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.chekCollectionView.reloadData()
    }
}
