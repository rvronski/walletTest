//
//  LoginViewController.swift
//  WalletTest
//
//  Created by ROMAN VRONSKY on 24.01.2023.
//

import UIKit

class LoginViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.textColor = .black
        passwordTextField.font = UIFont(name: "sysemFont", size: 16)
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        passwordTextField.leftView = paddingView
        passwordTextField.leftViewMode = .always
        return passwordTextField
    }()
    
    private lazy var loginTextField: UITextField = {
        var loginTextfield = UITextField()
        loginTextfield.translatesAutoresizingMaskIntoConstraints = false
        loginTextfield.placeholder = "Login/email"
        loginTextfield.layer.borderColor = UIColor.gray.cgColor
        loginTextfield.font = UIFont(name: "sysemFont", size: 16)
        loginTextfield.textColor = .black
        loginTextfield.autocapitalizationType = .none
        loginTextfield.textAlignment = .justified
        loginTextfield.keyboardType = .emailAddress
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        loginTextfield.leftView = paddingView
        loginTextfield.leftViewMode = .always
        loginTextfield.becomeFirstResponder()
        return loginTextfield
    }()
    
   
    
    private lazy var signUpButton: UIButton = {
        let signUpButton = UIButton()
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("SignUp", for: .normal)
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.addTarget(self, action: #selector(didPushSignUpButton), for: .touchUpInside)
        return signUpButton
    }()
    
   
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemRed
        button.setTitle("Log in", for: .normal)
        button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.backgroundColor = .clear
        logoImage.image = UIImage(named: "MyWalletLogo1.png")
        logoImage.clipsToBounds = true
        return logoImage
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupGesture()
        self.tabBarController?.tabBar.isHidden = true
        
      
    }
    private func setupView() {
        self.view.addSubview(scrollView)
        self.view.backgroundColor = .white
        self.scrollView.addSubview(self.stackView)
        self.scrollView.addSubview(self.signUpButton)
        self.stackView.addArrangedSubview(loginTextField)
        self.stackView.addArrangedSubview(passwordTextField)
        self.scrollView.addSubview(self.button)
        self.scrollView.addSubview(self.logoImage)
       
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.logoImage.centerYAnchor.constraint(lessThanOrEqualTo: self.scrollView.centerYAnchor, constant: -123),
            self.logoImage.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.logoImage.heightAnchor.constraint(equalToConstant: 150),
            self.logoImage.widthAnchor.constraint(equalTo: self.logoImage.heightAnchor, multiplier: 1),
            
            self.stackView.topAnchor.constraint(lessThanOrEqualTo: self.logoImage.bottomAnchor, constant: 50),
            self.stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16),
            self.stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16),
            self.stackView.heightAnchor.constraint(equalToConstant: 100),
            
            self.button.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 16),
            self.button.leftAnchor.constraint(equalTo: self.stackView.leftAnchor),
            self.button.rightAnchor.constraint(equalTo: self.stackView.rightAnchor),
            self.button.heightAnchor.constraint(equalToConstant: 50),
            
            self.signUpButton.topAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 10),
            self.signUpButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.signUpButton.widthAnchor.constraint(equalToConstant: 100),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 20),
            
           
            
        ])
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginTextField.becomeFirstResponder()
    }
    
    
    @objc private func didTapButton() {
        
        
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
            
    @objc private func didPushSignUpButton() {
        self.navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }
    
    private func alertDismiss(title: String, message: String?, completionHandler: @escaping () -> Void) {
         
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let ok = UIAlertAction(title: "ОК", style: .default) { _ in
             completionHandler()
         }
         alertController.addAction(ok)
         
         present(alertController, animated: true, completion: nil)
     }
    
    private func alertOk(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ОК", style: .default)
        
        alertController.addAction(ok)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func tapAlert()  {
        let alertControler = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
       let firstAction = UIAlertAction(title: "Ok", style: .default){ _ in
           self.loginTextField.becomeFirstResponder()
       }

       alertControler.addAction(firstAction)
        self.present(alertControler, animated: true)

   }
    @objc func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let loginButtonBottomPointY = self.signUpButton.frame.origin.y + self.signUpButton.frame.height
            let keyboardOriginY = self.view.frame.height - keyboardHeight
            
            let offset = keyboardOriginY <= loginButtonBottomPointY
            ? loginButtonBottomPointY - keyboardOriginY + 16
            : 0
            
            self.scrollView.contentOffset = CGPoint(x: 0, y: offset)
        }
    }
    @objc private func didHideKeyboard(_ notification: Notification) {
        self.hideKeyboard()
    }
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
}
