//
//  LoginViewController.swift
//  FileManagerHomework
//
//  Created by Мария Межова on 23.03.2022.
//

import UIKit
import KeychainAccess

class LoginViewController: UIViewController {
    
    private let keychain = Keychain()
    private let scrollView = UIScrollView()
    private let containerView: UIView = {
        let container = UIView()
        container.toAutoLayout()
        return container
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Create password"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.toAutoLayout()
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "to keep your data safe"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.toAutoLayout()
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.clipsToBounds = true
        textField.placeholder = "type password"
        textField.isSecureTextEntry = true
        textField.toAutoLayout()
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        button.tag = 1
        button.layer.cornerRadius = 5
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 7
        button.layer.shadowOpacity = 0.5
        button.setTitle("Create", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.toAutoLayout()
        return button
    }()
    
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    var firstEntryPassword = ""
    var secondEntryPassword = ""
    var entry = ""
    
    func firstPassword() {
        entry = passwordTextField.text ?? ""

        guard entry != "" else {
            showAlert(message: "Password is required")
            return
        }
        
        guard entry.count > 3 else {
            passwordTextField.text = ""
            showAlert(message: "Password should be not less then 4 characters")
            return
        }
        
        infoLabel.text = "Repeat your password"
        loginButton.setTitle("Confirm", for: .normal)
        firstEntryPassword = entry
        passwordTextField.text = ""
        loginButton.tag = 2
    }
    
    
    func confirmPassword() {
        if passwordTextField.text == "" {
            showAlert(message: "Password is required")
        } else {
            secondEntryPassword = passwordTextField.text!
        }
        if  secondEntryPassword == firstEntryPassword {
            loginLabel.text = "Log in"
            infoLabel.text = "Enter your password"
            loginButton.setTitle("Sign in", for: .normal)
            try? keychain.set(secondEntryPassword, key: "savedPassword")
            passwordTextField.text = ""
            let fileManagerVC = FileManagerViewController()
            navigationController?.pushViewController(fileManagerVC, animated: true)
            loginButton.tag = 3
        } else {
            showAlert(message: "Passwords does not match!")
            passwordTextField.text = ""
        }
    }
    
    func logIn() {
        if passwordTextField.text == secondEntryPassword {
            passwordTextField.text = ""
            let fileManagerVC = FileManagerViewController()
            navigationController?.pushViewController(fileManagerVC, animated: true)
        } else {
            showAlert(message: "Wrong password!")
            passwordTextField.text = ""
        }
    }
    
    @objc private func buttonTapped() {
        if loginButton.tag == 1{
            firstPassword()
        } else if loginButton.tag == 2{
            confirmPassword()
        } else if loginButton.tag == 3{
            logIn()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        
        scrollView.toAutoLayout()
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubviews(loginLabel, infoLabel, passwordTextField, loginButton)
        
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            loginLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 150),
            loginLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            loginLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            loginLabel.heightAnchor.constraint(equalToConstant: 30),
            
            infoLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 15),
            infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            infoLabel.heightAnchor.constraint(equalToConstant: 30),
            
            passwordTextField.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 70),
            passwordTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Keyboard
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}



