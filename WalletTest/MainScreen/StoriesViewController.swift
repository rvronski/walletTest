//
//  StoriesView.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 07.02.2023.
//

import UIKit

protocol StoriesViewDelegate: AnyObject {
    func pop()
}

class StoriesViewController: UIViewController {
    
    var touch = false
    var delegate: StoriesViewDelegate?
    lazy var backgroundImageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "background_image")
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progressTintColor = .systemRed
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
    }
    var timer = Timer()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Timer.scheduledTimer(withTimeInterval: 0.1,
                             repeats: true) { timer in
            if self.progressView.progress == 1 {
                self.dismiss(animated: true)
                self.progressView.setProgress(0, animated: false)
                self.index = Float(0)
                timer.invalidate()
            } else {
                
                self.setProgress()
            }
        }
    }
    
    private func setupView() {
        self.view.addSubview(self.backgroundImageView)
        self.backgroundImageView.addSubview(self.progressView)
        
        
        NSLayoutConstraint.activate([
            
            self.backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.backgroundImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.backgroundImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.backgroundImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.progressView.topAnchor.constraint(equalTo: self.backgroundImageView.topAnchor,constant: 80),
            self.progressView.leftAnchor.constraint(equalTo: self.backgroundImageView.leftAnchor,constant: 20),
            self.progressView.rightAnchor.constraint(equalTo: self.backgroundImageView.rightAnchor,constant: -20),
        ])
    }
    
    
    //
    
    
    
    var index = Float(0)
    func setProgress() {
        
        self.progressView.setProgress(self.index, animated: true)
        self.index += Float(0.02)
        
    }
}
