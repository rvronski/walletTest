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
    var storiesCentrY = CGFloat(0)
    var storiesCentrX = CGFloat(0)
    let transition = CircularTransition()
    let coreManager = CoreDataManager.shared
    let email = UserDefaults.standard.string(forKey: "email")
    var user: User
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
    
    private lazy var storiesCollection: StoriesCollectionReusebleView = {
       let stories = StoriesCollectionReusebleView()
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
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTapWalletButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var chekCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CheckCollectionViewCell.self, forCellWithReuseIdentifier: "ChekCell")
        collectionView.register(StoriesCollectionReusebleView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
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
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
    private lazy var activityIndicatorSmall: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        return activityIndicator
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.wallets = coreManager.wallets(user: self.user)
        print("🍎 \(self.user.userName ?? "no user")")
        UserDefaults.standard.set(true, forKey: "isLogin")
        self.locationManager.requestWhenInUseAuthorization()
        if currentReachabilityStatus == .notReachable {
            self.alertOk(title: "Проверьте интернет соединение", message: nil)
        }
        guard let email else {return}
        coreManager.getUser(email: email) { user in
            guard let user else {return}
            self.user = user
        }
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            self.location()
           
            group.leave()
        }
        group.notify(queue: .main) {
            self.getWeather()
            self.setupNavigationBar()
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = self.user.userName?.capitalized
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.tintColor = .systemYellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentReachabilityStatus == .notReachable {
            self.alertOk(title: "Проверьте интернет соединение", message: nil)
        }
        self.getWeather()
        self.wallets = coreManager.wallets(user: self.user)
        self.chekCollectionView.reloadData()
        self.storiesCollection.storiesCollectionView.reloadData()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.chekCollectionView)
        self.view.addSubview(self.addWalletButton)
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(self.activityIndicatorSmall)
        NSLayoutConstraint.activate([
           
            
            self.addWalletButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,constant: -20),
            self.addWalletButton.leftAnchor.constraint(equalTo: self.view.leftAnchor,constant: 16),
            self.addWalletButton.rightAnchor.constraint(equalTo: self.view.rightAnchor,constant: -16),
            self.addWalletButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.chekCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.chekCollectionView.bottomAnchor.constraint(equalTo: self.addWalletButton.topAnchor),
            self.chekCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.chekCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.activityIndicatorSmall.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70.3),
            self.activityIndicatorSmall.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 70.3),
            
            
        ])
    }
    
    private func getWeather() {
        getNowWeather(lat: self.lat, lon: self.lon) { weather in
            DispatchQueue.main.async {
                self.weather.insert(weather, at: 0)
            }
        }
    }
    
    private func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
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
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            NetworkManager().createWallet(name: name) { wallet in
                self.coreManager.createWallet(newWallet: wallet, user: self.user) {
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! StoriesCollectionReusebleView
        header.delegate = self
        self.indexPath = header.indexPath
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 117)
    }
    
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
    func present(indexPath: IndexPath, centrX: CGFloat, centrY: CGFloat) {
        self.storiesCentrX = centrX
        self.storiesCentrY = centrY + 120
        self.indexPath = indexPath
        if indexPath.row == 0  {
            let vc = WeatherStoriesViewController()
            vc.weather = self.weather.first
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
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: self.storiesCentrX, y: self.storiesCentrY)
        transition.circleColor = .systemRed
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: self.storiesCentrX, y: self.storiesCentrY)
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
