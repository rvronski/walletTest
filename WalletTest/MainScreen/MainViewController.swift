//
//  MainViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 24.01.2023.
//

import UIKit
import CoreData
import CoreLocation

class MainViewController: UIViewController {
    var locationManager = CLLocationManager()
    var storiesCentrY = 0.0
    var storiesCentrX = 0.0
    let transition = CircularTransition()
    let coreManager = CoreDataManager.shared
    let user: User
    var wallets = [Wallet]()
    var isStoriesIncreased = false
    var indexPath = IndexPath()
    private var lat: Double = 0
    private var lon: Double = 0
    private var weather = [WheatherAnswer]()
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
        stories.delegate = self
        return stories
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
       
        return scrollView
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
 
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.wallets = coreManager.wallets(user: user)
        self.setupNavigationBar()
        UserDefaults.standard.set(true, forKey: "isLogin")
        self.locationManager.requestWhenInUseAuthorization()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            self.location()
            group.leave()
        }
        group.notify(queue: .main) {
            self.getWeather()
        }
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
        self.storiesCollection.storiesCollectionView.reloadData()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.chekCollectionView)
        self.view.addSubview(self.addWalletButton)
        self.view.addSubview(self.nameUserLabel)
        self.view.addSubview(self.storiesCollection)
        
        NSLayoutConstraint.activate([
           
            self.nameUserLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10),
            self.nameUserLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            
            
            self.storiesCollection.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.storiesCollection.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.storiesCollection.topAnchor.constraint(equalTo: self.nameUserLabel.bottomAnchor,constant: 16),
            self.storiesCollection.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3),
            self.storiesCollection.widthAnchor.constraint(equalTo: self.storiesCollection.heightAnchor),
           
            self.addWalletButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            self.addWalletButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            self.addWalletButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -16),
            self.addWalletButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.chekCollectionView.topAnchor.constraint(equalTo: self.storiesCollection.bottomAnchor, constant: 10),
            self.chekCollectionView.bottomAnchor.constraint(equalTo: self.addWalletButton.topAnchor),
            self.chekCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.chekCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            
        ])
    }
    
    private func getWeather() {
        getNowWeather(lat: self.lat, lon: self.lon) { weather in
           
            DispatchQueue.main.async {
                self.weather.insert(weather, at: 0)
            }
        }
    }
    
    private func location() {
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
        self.locationManager.delegate = self
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
    func present() {
        self.indexPath = storiesCollection.indexPath
        if self.indexPath.row == 0 {
            let vc = WeatherStoriesViewController(weather: self.weather.first!)
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true)
        } else {
            let popVC = StoriesViewController()
            popVC.transitioningDelegate = self
            popVC.modalPresentationStyle = .custom
            self.present(popVC, animated: true)
            
        }
    }
    
}
extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let centrViewX = self.storiesCollection.storiesCollectionView.cellForItem(at: self.indexPath)!.frame.midX
        let centrViewY = self.storiesCollection.storiesCollectionView.cellForItem(at: self.indexPath)!.frame.midY + 120
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: centrViewX, y: centrViewY)
        print("🍎 \(centrViewX), \(centrViewY)")
        transition.circleColor = .systemRed
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let centrViewX = self.storiesCollection.storiesCollectionView.cellForItem(at: self.indexPath)!.frame.midX
        let centrViewY = self.storiesCollection.storiesCollectionView.cellForItem(at: self.indexPath)!.frame.midY + 120
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: centrViewX, y: centrViewY)
        transition.circleColor = .systemRed
        self.storiesCollection.storiesCollectionView.reloadData()
        return transition
        
    }
}
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lat = manager.location?.coordinate.latitude ?? 0
        let lon = manager.location?.coordinate.longitude ?? 0
        manager.stopUpdatingLocation()
        self.lat = lat
        self.lon = lon
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get location")
        
    }
}
