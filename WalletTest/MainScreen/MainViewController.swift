//
//  MainViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 24.01.2023.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    var storiesCentrY = 0.0
    var storiesCentrX = 0.0
    let transition = CircularTransition()
    let coreManager = CoreDataManager.shared
    let user: User
    var wallets = [Wallet]()
    var isStoriesIncreased = false
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var storiesCollection: StoriesCollection = {
       let stories = StoriesCollection()
        stories.translatesAutoresizingMaskIntoConstraints = false
        return stories
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
       
        return scrollView
    }()
    private lazy var storiesView: UIImageView = {
        let stories = UIImageView()
        stories.translatesAutoresizingMaskIntoConstraints = false
        stories.isUserInteractionEnabled = true
        stories.layer.borderWidth = 3
        stories.image = UIImage(named: "background_image")
        stories.clipsToBounds = true
        stories.layer.borderColor = UIColor.systemRed.cgColor
        return stories
    }()
    
    private lazy var storiesView1: UIImageView = {
        let stories = UIImageView()
        stories.translatesAutoresizingMaskIntoConstraints = false
        stories.isUserInteractionEnabled = true
        stories.layer.borderWidth = 3
        stories.image = UIImage(named: "background_image")
        stories.clipsToBounds = true
        stories.layer.borderColor = UIColor.systemRed.cgColor
        return stories
    }()
    private lazy var storiesView2: UIImageView = {
        let stories = UIImageView()
        stories.translatesAutoresizingMaskIntoConstraints = false
        stories.isUserInteractionEnabled = true
        stories.layer.borderWidth = 3
        stories.image = UIImage(named: "background_image")
        stories.clipsToBounds = true
        stories.layer.borderColor = UIColor.systemRed.cgColor
        return stories
    }()
    private lazy var storiesView3: UIImageView = {
        let stories = UIImageView()
        stories.translatesAutoresizingMaskIntoConstraints = false
        stories.isUserInteractionEnabled = true
        stories.layer.borderWidth = 3
        stories.image = UIImage(named: "background_image")
        stories.clipsToBounds = true
        stories.layer.borderColor = UIColor.systemRed.cgColor
        return stories
    }()
    
    private lazy var storiesView4: UIImageView = {
        let stories = UIImageView()
        stories.translatesAutoresizingMaskIntoConstraints = false
        stories.isUserInteractionEnabled = true
        stories.layer.borderWidth = 3
        stories.image = UIImage(named: "background_image")
        stories.clipsToBounds = true
        stories.layer.borderColor = UIColor.systemRed.cgColor
        return stories
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
    let vc = StoriesViewController()

    private lazy var transferView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        return view
    }()
    
    private lazy var nameUserLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        return label
    }()
//    
//    override func loadView() {
//        super.loadView()
//        view = storiesCollection
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.wallets = coreManager.wallets(user: user)
        self.setupNavigationBar()
        UserDefaults.standard.set(true, forKey: "isLogin")
        self.storiesGesture()
        self.vc.delegate = self
        self.getCentrView()
    }
    
    private func setupNavigationBar() {
        self.nameUserLabel.text = user.userName?.capitalized
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = .systemRed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wallets = coreManager.wallets(user: user)
        self.chekCollectionView.reloadData()
    }
    
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.storiesView.layer.cornerRadius = self.storiesView.frame.height/2
        self.storiesView1.layer.cornerRadius = self.storiesView.frame.height/2
        self.storiesView2.layer.cornerRadius = self.storiesView.frame.height/2
        self.storiesView3.layer.cornerRadius = self.storiesView.frame.height/2
       
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.chekCollectionView)
        self.scrollView.addSubview(self.addWalletButton)
        self.scrollView.addSubview(self.nameUserLabel)
        self.scrollView.addSubview(self.storiesView)
        self.scrollView.addSubview(self.storiesView1)
        self.scrollView.addSubview(self.storiesView2)
        self.scrollView.addSubview(self.storiesView3)
//        self.scrollView.addSubview(self.storiesView4)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.nameUserLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10),
            self.nameUserLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            
            
            self.storiesView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 16),
            self.storiesView.topAnchor.constraint(equalTo: self.nameUserLabel.bottomAnchor,constant: 16),
            self.storiesView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.25),
            self.storiesView.widthAnchor.constraint(equalTo: self.storiesView.heightAnchor),
//
            self.storiesView1.leftAnchor.constraint(equalTo: self.storiesView.rightAnchor, constant: 16),
//            self.storiesView1.topAnchor.constraint(equalTo: self.scrollView.topAnchor,constant: 16),
            self.storiesView1.centerYAnchor.constraint(equalTo: self.storiesView.centerYAnchor),
            self.storiesView1.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3),
            self.storiesView1.widthAnchor.constraint(equalTo: self.storiesView.heightAnchor),
        
            self.storiesView2.leftAnchor.constraint(equalTo: self.storiesView1.rightAnchor, constant: 16),
//            self.storiesView2.topAnchor.constraint(equalTo: self.scrollView.topAnchor,constant: 16),
            self.storiesView2.centerYAnchor.constraint(equalTo: self.storiesView1.centerYAnchor),
            self.storiesView2.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3),
            self.storiesView2.widthAnchor.constraint(equalTo: self.storiesView.heightAnchor),

            self.storiesView3.leftAnchor.constraint(equalTo: self.storiesView2.rightAnchor, constant: 16),
//            self.storiesView3.topAnchor.constraint(equalTo: self.scrollView.topAnchor,constant: 16),
            self.storiesView3.centerYAnchor.constraint(equalTo: self.storiesView2.centerYAnchor),
            self.storiesView3.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3),
            self.storiesView3.widthAnchor.constraint(equalTo: self.storiesView.heightAnchor),
            self.storiesView3.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: -16),
            
            self.addWalletButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            self.addWalletButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            self.addWalletButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -16),
            self.addWalletButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.chekCollectionView.topAnchor.constraint(equalTo: self.storiesView.bottomAnchor, constant: 10),
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
    
    private func getCentrView() {
            self.storiesCentrY = self.storiesView.frame.origin.x + (self.storiesView.frame.height/2) - 16
            self.storiesCentrX = self.storiesView.frame.origin.y + (self.storiesView.frame.height/2) - 16
      print(storiesCentrY)
        print(storiesCentrX)
        
    }
    
   @objc func changeLayoutAvatar() {
//       if self.isStoriesIncreased == false {
//           getCentrView()
//       }
//        let stories = self.storiesView
//
        let widthScreen = UIScreen.main.bounds.width
        let heightScreen = UIScreen.main.bounds.height
//        let widthStories = stories.bounds.width
//        let width = widthScreen / widthStories
//        let height = heightScreen / widthStories
//      let hidden = self.isStoriesIncreased ? false : true
//        UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeCubic) {
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) { [self] in
//                self.tabBarController?.tabBar.isHidden = hidden
////                navigationController?.navigationBar.isHidden = hidden
//                self.view.bringSubviewToFront(stories)
//                stories.transform = self.isStoriesIncreased ? .identity : CGAffineTransform(scaleX: width, y: height)
//                stories.layer.borderWidth = self.isStoriesIncreased ? 3 : 0
//                stories.center = self.isStoriesIncreased ? CGPoint(x: self.storiesCentrX, y: self.storiesCentrY): CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
////                stories.bringSubviewToFront(self)
//
//                stories.layer.cornerRadius = self.isStoriesIncreased ? stories.frame.height/2 : 0
//
//                stories.layoutIfNeeded()
//            }
//
//            } completion: { _ in
//
//                if self.isStoriesIncreased == false {
//                    self.navigationController?.pushViewController(self.vc, animated: false)
//                }
//                self.isStoriesIncreased.toggle()
//        }
       let popVC = StoriesViewController()
       
       popVC.transitioningDelegate = self
       popVC.modalPresentationStyle = .custom
     
//       let popOverVC = popVC.popoverPresentationController
//       popOverVC?.delegate = self
//       popOverVC?.sourceView = self.storiesView
//       popOverVC?.sourceRect = CGRect(x: self.storiesView.bounds.midX , y: self.storiesView.bounds.maxY, width: 0, height: 0)
//       popVC.preferredContentSize = CGSize(width: widthScreen, height: heightScreen)
       self.present(popVC, animated: true)
            
            
    }
    
    private func storiesGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(changeLayoutAvatar))
        gesture.numberOfTapsRequired = 1
        self.storiesView.addGestureRecognizer(gesture)
//        self.storiesView1.addGestureRecognizer(gesture)
//        self.storiesView2.addGestureRecognizer(gesture)
//        self.storiesView3.addGestureRecognizer(gesture)
    }
}
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallets.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChekCell", for: indexPath) as! CheckCollectionViewCell
        
        cell.setup(wallet: wallets[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = (collectionView.frame.width - 32)
        
        return CGSize(width: itemWidth, height: 150)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let walletVC = DetailViewController(user: user, wallet: wallets[indexPath.row])
        self.navigationController?.pushViewController(walletVC, animated: true)
    }
    
}
extension MainViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.chekCollectionView.reloadData()
    }
}
extension MainViewController: StoriesViewDelegate {
    func pop() {
        
        self.vc.navigationController?.popViewController(animated: false)
        changeLayoutAvatar()
    }
    
    
}
extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = self.storiesView.center
        transition.circleColor = self.storiesView.backgroundColor ?? .systemRed
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = self.storiesView.center
        transition.circleColor = self.storiesView.backgroundColor ?? .systemRed
        
        return transition
    }
}
