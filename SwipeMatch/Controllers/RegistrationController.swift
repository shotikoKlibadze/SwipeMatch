//
//  RegistrationController.swift
//  SwipeMatch
//
//  Created by Shotiko Klibadze on 03.02.22.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationController: UIViewController {
    
    let photoButton : UIButton = {
        let button = UIButton()
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 270).isActive = true
        return button
    }()
   
    let fullNameTextField : CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        return tf
    }()
    
    let emailTextField : CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter email"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        return tf
    }()
    
    let passwordTextField : CustomTextField = {
        let tf = CustomTextField(padding: 16)
        tf.placeholder = "Enter password"
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 25
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        return tf
    }()
    
    let registerButton : UIButton = {
        let bt = UIButton()
        bt.setTitle("Register", for: .normal)
        bt.setTitleColor(.darkGray, for: .disabled)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bt.backgroundColor = .gray
        bt.layer.cornerRadius = 25
        bt.isEnabled = false
        bt.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return bt
    }()
    
    lazy var mainStackView = UIStackView(arrangedSubviews: [
        photoButton,
        fullNameTextField,
        emailTextField,
        passwordTextField,
        registerButton
    ])
    
    var viewModel = RegistrationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientLayer()
        setupLayout()
        setupNotificationObservers()
        setUpTapGesture()
        setUpViewModelObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    fileprivate func setUpViewModelObserver() {
        viewModel.isFormValidObserver = { [weak self] isValid in
            guard let self = self else {return}
            self.registerButton.isEnabled = isValid
            if isValid {
                self.registerButton.backgroundColor = .red
                self.registerButton.setTitleColor(.white, for: .normal)
            } else {
                self.registerButton.backgroundColor = .gray
                self.registerButton.setTitleColor(.darkGray, for: .disabled)
            }
        }
    }
    
    fileprivate func setUpTapGesture() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))
    }
    
    fileprivate func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDismiss), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func setupLayout() {
        view.addSubview(mainStackView)
        mainStackView.axis = .vertical
        mainStackView.spacing = 8
        mainStackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50))
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func  setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        view.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [UIColor.link.cgColor, UIColor.systemPink.cgColor]
        gradientLayer.locations = [0,1]
        gradientLayer.frame = view.bounds
    }
    
    @objc func handleTapGesture() {
        self.view.endEditing(true)
    }
    
    @objc func handleKeyboardDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.transform = .identity
        }
    }
    
    @objc func handleKeyboardShow(notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyBoardFrame = value.cgRectValue
        let bottomSpace = view.frame.height - mainStackView.frame.origin.y - mainStackView.frame.height
        let difference = keyBoardFrame.height - bottomSpace
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
        }
    }
    
    @objc func handleTextFieldChange(textField: UITextField) {
        if textField == passwordTextField {
            viewModel.password = textField.text
        } else if textField == emailTextField {
            viewModel.email = textField.text
        } else {
            viewModel.fullName = textField.text
        }
    }
    
    @objc func handleRegister() {
        handleTapGesture()
        guard let email = emailTextField.text , let password = passwordTextField.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.showHudWithError(error: error)
                return
            }
            print("registraiotion successful : \(result?.user.uid)")
        }
        
    }
    
    func showHudWithError(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed Registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
   
}
