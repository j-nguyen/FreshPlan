//
//  RegisterViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import RxSwift
import MaterialComponents
import SnapKit

public final class RegisterViewController: UIViewController {
    
	private var router: RegisterRouter!
	private var viewModel: RegisterViewModelProtocol!
    
    // MARK: - Stack Views
    private var stackView: UIStackView!
    
    // MARK - Labels
    private var loginInLabel: UILabel!
    
    // MARK - TextFields
    private var firstNameField: MDCTextField!
    private var lastNameField: MDCTextField!
    private var displayNameField: MDCTextField!
    private var emailField: MDCTextField!
    private var passwordField: MDCTextField!
    
    // MARK - Floating Placeholder Input
    private var firstNameFieldController: MDCTextInputController!
    private var lastNameFieldController: MDCTextInputController!
    private var displayNameFieldController: MDCTextInputControllerDefault!
    private var emailFieldController: MDCTextInputControllerDefault!
    private var passwordFieldController: MDCTextInputControllerDefault!
    
    // MARK - Buttons
    private var signUpButton: MDCButton!
	
    public convenience init(viewModel: RegisterViewModel, router: RegisterRouter) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.router = router
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // loads the view
    public override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    //
    fileprivate func prepareView() {
        prepareStackView()
        prepareLoginInLabel()
        prepareFirstName()
        prepareLastName()
        prepareDisplayName()
        prepareEmail()
        preparePassword()
        prepareSignUpButton()
        
    }
    
    fileprivate func prepareStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    fileprivate func prepareLoginInLabel() {
        loginInLabel = UILabel()
        let registerText = "Already have an account? Login In here!"
        let mutableString = NSMutableAttributedString(attributedString: NSAttributedString(string: registerText))
        
        mutableString.addAttribute(
            NSForegroundColorAttributeName,
            value: MDCPalette.lightBlue.accent700!,
            range: NSRange(location: 24, length: 15)
        )
        
        loginInLabel.attributedText = mutableString
        loginInLabel.font = MDCTypography.body1Font()
        loginInLabel.isUserInteractionEnabled = true
        
        view.addSubview(loginInLabel)
        
        loginInLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view).offset(-10)
            make.centerX.equalTo(view)
        }
    }
    
    fileprivate func prepareFirstName() {
        firstNameField = MDCTextField()
        firstNameField.placeholder = "First Name"
        firstNameField.returnKeyType = .next
        
        firstNameFieldController = MDCTextInputControllerDefault(textInput: firstNameField)
        
        stackView.addArrangedSubview(firstNameField)
        
        firstNameField.snp.makeConstraints { make in
            make.width.equalTo(view).inset(20)
        }
    }
    
    fileprivate func prepareLastName() {
        lastNameField = MDCTextField()
        lastNameField.placeholder = "Last Name"
        lastNameField.returnKeyType = .next
        
        lastNameFieldController = MDCTextInputControllerDefault(textInput: lastNameField)
        
        stackView.addArrangedSubview(lastNameField)
        
        lastNameField.snp.makeConstraints { make in
            make.width.equalTo(view).inset(20)
        }
    }
    
    fileprivate func prepareDisplayName() {
        displayNameField = MDCTextField()
        displayNameField.placeholder = "Display Name"
        displayNameField.returnKeyType = .next
        
        displayNameFieldController = MDCTextInputControllerDefault(textInput: displayNameField)
        
        stackView.addArrangedSubview(displayNameField)
        
        displayNameField.snp.makeConstraints { make in
            make.width.equalTo(view).inset(20)
        }
    }
    
    fileprivate func prepareEmail() {
        emailField = MDCTextField()
        emailField.placeholder = "Email"
        emailField.keyboardType = .emailAddress
        emailField.returnKeyType = .next
        
        emailFieldController = MDCTextInputControllerDefault(textInput: emailField)
        
        stackView.addArrangedSubview(emailField)
        
        emailField.snp.makeConstraints { make in
            make.width.equalTo(view).inset(20)
        }
    }
    
    fileprivate func preparePassword() {
        passwordField = MDCTextField()
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done
        
        passwordFieldController = MDCTextInputControllerDefault(textInput: passwordField)
        
        stackView.addArrangedSubview(passwordField)
        
        passwordField.snp.makeConstraints { make in
            make.width.equalTo(view).inset(20)
        }
        
    }
    
    fileprivate func prepareSignUpButton() {
        signUpButton = MDCButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = MDCPalette.lightBlue.tint800
        
        stackView.addArrangedSubview(signUpButton)
        
        signUpButton.snp.makeConstraints { make in
            make.width.equalTo(view).inset(20)
        }
    }
}
