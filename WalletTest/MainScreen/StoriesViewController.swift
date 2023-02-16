//
//  StoriesView.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 07.02.2023.
//

import UIKit



class StoriesViewController: UIViewController {
    
    var touch = false
   var isDraging = false
    var newY:CGFloat = 0
    var oldY:CGFloat = 0
    var oldX: CGFloat = 0
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
        progress.progressTintColor = .systemYellow
        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupGesture()
    }
    var timer = Timer()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       timer = Timer.scheduledTimer(withTimeInterval: 0.1,
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
    
    private func setupGesture() {
        let tapGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissView))
        tapGesture.direction = [.up,.down]
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.timer.invalidate()
        guard  let touch = touches.first else {return}
        oldY = backgroundImageView.frame.origin.y
        oldX = backgroundImageView.frame.origin.x
        let location = touch.location(in: self.backgroundImageView)
        if backgroundImageView.bounds.contains(location) {
           isDraging = true
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDraging, let touch = touches.first else {
            return
        }
        
        
        let location = touch.location(in: view)
        print(location.x)
       
        backgroundImageView.frame.origin.x = location.x - (backgroundImageView.frame.size.width / 2)
        backgroundImageView.frame.origin.y = location.y - (backgroundImageView.frame.size.height / 2)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        newY = backgroundImageView.frame.origin.y
        timer = Timer.scheduledTimer(withTimeInterval: 0.1,
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
        let location = newY - oldY
        if location > 0 {
            if location > 500 {
                self.dismissView()
            } else {
                backgroundImageView.frame.origin.y = oldY
                backgroundImageView.frame.origin.x = oldX
            }
        } else if location < 0  {
            if location < 500 {
                self.dismissView()
            } else {
                backgroundImageView.frame.origin.y = oldY
                backgroundImageView.frame.origin.x = oldX
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
    
    @objc private func dismissView() {
        self.dismiss(animated: true)
    }
}
