//
//  ViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 21.01.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let networkManager = NetworkManager.shared
    private let coreManager = CoreDataManager.shared
    private var isBackView = false
    let user: User
    let wallet: Wallet
    
    init(user: User, wallet: Wallet) {
        self.user = user
        self.wallet = wallet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Card View
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var cardImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.image = UIImage(named: "card")
        return view
    }()
    
    private lazy var cardView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
//        view.layer.borderWidth = 0.5
//        view.layer.borderColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cardBackImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.image = UIImage(named: "card")
        return view
    }()
    
    private lazy var cardBackView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var cardNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .clear
        label.text = wallet.nameWallet ?? ""
        return label
    }()
    
    private lazy var cardCVCLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    // MARK: WalletCollectionVIew
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return layout
    }()
    
    private lazy var detailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    //MARK: Transfer View
    
    private lazy var transferView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9294117689, green: 0.9294117093, blue: 0.9294117689, alpha: 1)
        view.layer.cornerRadius = 30
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    private lazy var transferImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "shuffle")
        imageView.tintColor = .systemYellow
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var payLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "????????????????"
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.gestureView()
        self.gestureBackView()
        self.gestureTransferView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentReachabilityStatus == .notReachable {
            self.alertOk(title: "?????????????????? ???????????????? ????????????????????", message: nil)
        }
        self.detailCollectionView.reloadData()
        self.navigationItem.title = wallet.nameWallet
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.conteinerView)
        self.view.addSubview(self.transferView)
        self.view.addSubview(self.detailCollectionView)
        self.view.addSubview(self.activityIndicator)
        self.conteinerView.addSubview(self.cardBackView)
        self.cardBackView.addSubview(self.cardBackImageView)
        self.cardBackView.addSubview(self.cardCVCLabel)
        self.conteinerView.addSubview(self.cardView)
        self.cardView.addSubview(self.cardImageView)
        self.cardView.addSubview(self.cardNameLabel)
        self.cardView.bringSubviewToFront(cardNameLabel)
        self.transferView.addSubview(self.transferImageView)
        self.transferView.addSubview(self.payLabel)
        
        
        NSLayoutConstraint.activate([
            
            self.conteinerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.conteinerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.conteinerView.heightAnchor.constraint(equalToConstant: 185),
            self.conteinerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 51),
            self.conteinerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -51),
            
            self.cardBackView.topAnchor.constraint(equalTo: self.conteinerView.topAnchor),
            self.cardBackView.trailingAnchor.constraint(equalTo: self.conteinerView.trailingAnchor),
            self.cardBackView.leadingAnchor.constraint(equalTo: self.conteinerView.leadingAnchor),
            self.cardBackView.bottomAnchor.constraint(equalTo: self.conteinerView.bottomAnchor),
            
            self.cardBackImageView.topAnchor.constraint(equalTo: self.cardBackView.topAnchor),
            self.cardBackImageView.trailingAnchor.constraint(equalTo: self.cardBackView.trailingAnchor),
            self.cardBackImageView.leadingAnchor.constraint(equalTo: self.cardBackView.leadingAnchor),
            self.cardBackImageView.bottomAnchor.constraint(equalTo: self.cardBackView.bottomAnchor),
            
            self.cardView.topAnchor.constraint(equalTo: self.conteinerView.topAnchor),
            self.cardView.trailingAnchor.constraint(equalTo: self.conteinerView.trailingAnchor),
            self.cardView.leadingAnchor.constraint(equalTo: self.conteinerView.leadingAnchor),
            self.cardView.bottomAnchor.constraint(equalTo: self.conteinerView.bottomAnchor),
            
            self.cardImageView.topAnchor.constraint(equalTo: self.cardView.topAnchor),
            self.cardImageView.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor),
            self.cardImageView.leadingAnchor.constraint(equalTo: self.cardView.leadingAnchor),
            self.cardImageView.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor),
            
            self.cardNameLabel.bottomAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: -5),
            self.cardNameLabel.trailingAnchor.constraint(equalTo: self.cardView.trailingAnchor, constant: -20),
            
            self.cardCVCLabel.trailingAnchor.constraint(equalTo: self.cardBackView.trailingAnchor, constant: -16),
            self.cardCVCLabel.topAnchor.constraint(equalTo: self.cardBackView.topAnchor, constant: 50),
            
            self.detailCollectionView.topAnchor.constraint(equalTo: self.conteinerView.bottomAnchor, constant: 16),
            self.detailCollectionView.heightAnchor.constraint(equalToConstant: 190),
            self.detailCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.detailCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.transferView.topAnchor.constraint(equalTo: self.detailCollectionView.bottomAnchor, constant: 10),
            self.transferView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.transferView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.transferView.heightAnchor.constraint(equalToConstant: 150),
            
            self.transferImageView.centerYAnchor.constraint(equalTo: self.transferView.centerYAnchor),
            self.transferImageView.leftAnchor.constraint(equalTo: self.transferView.leftAnchor, constant: 16),
            self.transferImageView.heightAnchor.constraint(equalTo: self.transferView.heightAnchor, multiplier: 0.3),
            self.transferImageView.widthAnchor.constraint(equalTo: self.transferImageView.heightAnchor),
            
            self.payLabel.centerYAnchor.constraint(equalTo: self.transferImageView.centerYAnchor),
            self.payLabel.centerXAnchor.constraint(equalTo: self.transferView.centerXAnchor),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
        ])
    }
    
    private func gestureView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(flip))
        gesture.numberOfTapsRequired = 1
        self.cardImageView.addGestureRecognizer(gesture)
    }
    
    private func gestureBackView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(flip))
        gesture.numberOfTapsRequired = 1
        self.cardBackImageView.addGestureRecognizer(gesture)
    }
    
    @objc private func flip() {
        
        let toView = isBackView ? self.cardView :  self.cardBackView
        let fromView = isBackView ? self.cardBackView : self.cardView
        
        UIView.transition(from: fromView, to: toView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews] )
        isBackView.toggle()
    }
    private func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "????", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    private func alertAction(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "?????????????? ??????????"
        }
        
        let saveAction = UIAlertAction(title: "??????????????????", style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            guard  let text = firstTextField.text, !text.isEmpty
            else { self.alertOk(title: "?????????????? ??????????", message: nil)
                return
            }
            guard Int(text) != nil else { self.alertOk(title: "???????????? ?????????????????? ?????????? ????", message: "?????????????? ?????????? ??????????????")
                return
            }
            guard let id = self.wallet.id else {return}
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.networkManager.credit(amount: text, id: id) { balance in
                self.coreManager.changeBalance(id: id, newBalance: balance) {
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.detailCollectionView.reloadData()
                    }
                }
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "????????????", style: .cancel, handler: nil )
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc private func tapTransButton() {
        let alertController = UIAlertController(title: "??????????????", message: nil, preferredStyle: .actionSheet)
        
        let anotherBank = UIAlertAction(title: "?????????????? ???? ????????????????", style: .default) {_ in
            let vc = AnotherTransferViewController(user: self.user, isPhonePayments: false)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        let services = UIAlertAction(title: "???????????? ??????????", style: .default) {_ in
            let vc = ServicesViewController(user: self.user)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        let betweenAction = UIAlertAction(title: "?????????? ???????????? ??????????????", style: .default) {_ in
            let vc = TransferViewController(user: self.user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let cancelAction = UIAlertAction(title: "????????????", style: .cancel, handler: nil )
        
        alertController.addAction(betweenAction)
        alertController.addAction(anotherBank)
        alertController.addAction(services)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
extension DetailViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as! DetailCollectionViewCell
        cell.setup(wallet: wallet)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (collectionView.frame.width - 32)
        
        return CGSize(width: itemWidth, height: 150)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.alertAction(title: "?????????????? ????????????", message: nil)
    
    }
    private func gestureTransferView(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapTransButton))
        gesture.numberOfTapsRequired = 1
        self.transferView.addGestureRecognizer(gesture)
    }
}
