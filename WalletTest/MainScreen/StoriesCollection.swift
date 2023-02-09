//
//  StoriesCollectionViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 08.02.2023.
//

import UIKit

protocol StoriesViewDelegate: AnyObject {
    func present()
}

class StoriesCollection: UIView {
    var delegate: StoriesViewDelegate?
    private let reuseIdentifier = "Cell"
    private var isStoriesIncreased = false
    let transition = CircularTransition()
    var indexPath = IndexPath()
    var indexArray = [IndexPath]()
    var images = [UIImage(named: "weatherLogo"),UIImage(named: "background_image"),UIImage(named: "MyWalletLogo1"), ]
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
     lazy var storiesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(StoriesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupView() {
        self.backgroundColor = .white
        self.addSubview(self.storiesCollectionView)
        
        NSLayoutConstraint.activate([
        
            self.storiesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            self.storiesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.storiesCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.storiesCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
        
        ])
        
    }
}
extension StoriesCollection: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StoriesCollectionViewCell
        
        cell.setupImage(image: self.images[indexPath.row]!)
        
       for i in indexArray {
           if i == indexPath {
               cell.changeColor()
           }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let itemWidth = (collectionView.frame.width - 64) / 3

        return CGSize(width: itemWidth, height: itemWidth)

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.indexPath = indexPath
        self.indexArray.append(indexPath)
        self.delegate?.present()
    }
}
extension StoriesCollection: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = self.storiesCollectionView.cellForItem(at: self.indexPath)!.center
        transition.circleColor = .systemRed
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = self.storiesCollectionView.cellForItem(at: self.indexPath)!.center
        transition.circleColor = .systemRed
        
        return transition
    }
}
