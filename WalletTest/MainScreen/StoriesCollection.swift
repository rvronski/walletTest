//
//  StoriesCollectionViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 08.02.2023.
//

import UIKit



class StoriesCollection: UIView {
    private let reuseIdentifier = "Cell"
    private var isStoriesIncreased = false
//    private lazy var layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 16
//        layout.minimumInteritemSpacing = 16
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        return layout
//    }()
//    
//    private lazy var storiesCollectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(StoriesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        collectionView.dataSource = self
//        collectionView.delegate = self 
//        return collectionView
//    }()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.
//    }
    
    private func setupView() {
        self.backgroundColor = .white
//        self.addSubview(self.storiesCollectionView)
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.storiesView)
        self.scrollView.addSubview(self.storiesView1)
        self.scrollView.addSubview(self.storiesView2)
        self.scrollView.addSubview(self.storiesView3)
        NSLayoutConstraint.activate([
            
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            self.storiesView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor,constant: 16),
            self.storiesView.topAnchor.constraint(equalTo: self.topAnchor,constant: 16),
            self.storiesView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor),
            self.storiesView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -16),
            self.storiesView.widthAnchor.constraint(equalTo: self.storiesView.heightAnchor),
//
            self.storiesView1.leftAnchor.constraint(equalTo: self.storiesView.rightAnchor,constant: 16),
            self.storiesView1.topAnchor.constraint(equalTo: self.topAnchor,constant: 16),
            self.storiesView1.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor),
            self.storiesView1.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -16),
            self.storiesView1.widthAnchor.constraint(equalTo: self.storiesView.heightAnchor),
            
            self.storiesView2.leftAnchor.constraint(equalTo: self.storiesView1.rightAnchor,constant: 16),
            self.storiesView2.topAnchor.constraint(equalTo: self.topAnchor,constant: 16),
            self.storiesView2.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor),
            self.storiesView2.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -16),
            self.storiesView2.widthAnchor.constraint(equalTo: self.storiesView.heightAnchor),

            self.storiesView3.leftAnchor.constraint(equalTo: self.storiesView2.rightAnchor,constant: 16),
            self.storiesView3.topAnchor.constraint(equalTo: self.topAnchor,constant: 16),
            self.storiesView3.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor),
            self.storiesView3.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -16),
            self.storiesView3.widthAnchor.constraint(equalTo: self.storiesView.heightAnchor),
            self.storiesView3.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor,constant: -16),
            
            
            
            
//            self.storiesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
//            self.storiesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            self.storiesCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
//            self.storiesCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
        
        ])
        
    }
    
    
    
}
//extension StoriesCollection: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoriesCollectionViewCell
//
//        cell.layer.cornerRadius = cell.frame.height/2
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let itemWidth = (collectionView.frame.width - 32) / 4
//
//        return CGSize(width: itemWidth, height: itemWidth)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
//        //        let storiesCentrY = self.storiesView.frame.origin.x + (self.storiesView.frame.height/2)
//        //        let storiesCentrX = self.storiesView.frame.origin.y + (self.storiesView.frame.height/2)
//        //        print(storiesCentrY,storiesCentrX)
//        let widthScreen = UIScreen.main.bounds.width
//        let heightScreen = UIScreen.main.bounds.height
//        let widthStories = cell!.bounds.width
//        let width = widthScreen / widthStories
//        let height = heightScreen / widthStories
////        let hidden = self.isStoriesIncreased ? false : true
//        UIView.animateKeyframes(withDuration: 1, delay: 0, options: .calculationModeCubic) {
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) { [self] in
//                cell?.transform = self.isStoriesIncreased ? .identity : CGAffineTransform(scaleX: width, y: height)
//                //                 cell.layer.borderWidth = self.isStoriesIncreased ? 3 : 0
//                cell?.center = self.isStoriesIncreased ? CGPoint(x: 69.16666666666666, y:264.8333333333333): CGPoint(x: self.bounds.midX, y: self.bounds.midY)
//                //                 self.view.bringSubviewToFront(cell)
//                //                 self.tabBarController?.tabBar.isHidden = hidden
//                //                 navigationController?.navigationBar.isHidden = hidden
//                cell?.layer.cornerRadius = self.isStoriesIncreased ? (cell?.frame.height)!/2 : 0
//
//                cell?.layoutIfNeeded()
//                self.isStoriesIncreased.toggle()
//            }
//
//            //             } completion: { _ in
//            //
//            //                 if self.isStoriesIncreased == false {
//            //                     self.navigationController?.pushViewController(self.vc, animated: false)
//            //                 }
//            //                 self.isStoriesIncreased.toggle()
//            //         }
//
//        }
//    }
//}
