//
//  LoginViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-05.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents
import RxSwift
import RxGesture

public class LoginViewController: UIViewController {
	private var viewModel: LoginViewModelProtocol!
	private var router: LoginRouter!
	
	// MARK - Buttons
	private var loginButton: MDCFlatButton!
	
	// MARK - TextField
	private var emailField: MDCTextField!
	private var passwordField: MDCTextField!
	
	// MARK - UILabel
	private var registerLabel: UILabel!
	private var errorLabel: UILabel!
	
	// MARK - Floating Placeholder Input
	private var emailFieldController: MDCTextInputController!
	private var passwordFieldController: MDCTextInputController!
	
	// MARK - Disposable Bag
	private let disposeBag = DisposeBag()
	
	public convenience init(viewModel: LoginViewModelProtocol, router: LoginRouter) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.router = router
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		// load views
		prepareView()
	}
	
	fileprivate func prepareView() {
		view.backgroundColor = UIColor.grayBackgroundColor
		prepareEmailField()
		preparePasswordField()
		prepareLoginButton()
		prepareRegisterLabel()
	}
	
	// MARK - Preparing Views
	
	fileprivate func prepareEmailField() {
		emailField = MDCTextField()
		emailField.placeholder = "Email Address"
		emailField.returnKeyType = .next
		emailField.keyboardType = .emailAddress
		
		emailFieldController = MDCTextInputControllerDefault(textInput: emailField)
		
		view.addSubview(emailField)
		
		emailField.snp.makeConstraints { make in
			make.top.equalTo(150)
			make.left.equalTo(10)
			make.right.equalTo(-10)
			make.width.equalTo(300)
		}
		
		emailField.rx.text
			.orEmpty
			.bind(to: viewModel.email)
			.disposed(by: disposeBag)
	}
	
	fileprivate func preparePasswordField() {
		passwordField = MDCTextField()
		passwordField.placeholder = "Password"
		passwordField.isSecureTextEntry = true
		
		passwordFieldController = MDCTextInputControllerDefault(textInput: passwordField)
		
		view.addSubview(passwordField)
		
		passwordField.snp.makeConstraints { make in
			make.top.equalTo(emailField.snp.bottom).offset(10)
			make.left.equalTo(10)
			make.right.equalTo(-10)
			make.width.equalTo(300)
		}
		
		passwordField.rx.text
			.orEmpty
			.bind(to: viewModel.password)
			.disposed(by: disposeBag)
	}
	
	fileprivate func prepareLoginButton() {
		loginButton = MDCFlatButton()
		loginButton.setTitle("Login", for: .normal)
		loginButton.backgroundColor = MDCPalette.lightBlue.tint800
		
		view.addSubview(loginButton)
		
		loginButton.snp.makeConstraints { make in
			make.top.equalTo(passwordField.snp.bottom).offset(15)
			make.left.equalTo(10)
			make.right.equalTo(-10)
			make.width.equalTo(300)
		}
		
		viewModel.loginEnabled
			.bind(to: loginButton.rx.isEnabled)
			.disposed(by: disposeBag)
		
		viewModel.loginTap = loginButton.rx.tap.asObservable()
		viewModel.bindButtons()
		
		viewModel.loginSuccess
			.asObservable()
			.filter { $0 }
			.subscribe(onNext: { [weak self] _ in
				guard let this = self else { return }
				return
			})
			.disposed(by: disposeBag)
		
		viewModel.loginUnverified
			.asObservable()
			.filter { $0 }
			.subscribe(onNext: { [weak self] _ in 
				
			})
			.disposed(by: disposeBag)
	}
	
	fileprivate func prepareRegisterLabel() {
		registerLabel = UILabel()
		// we want the last bit to be blue
		let registerText =  "Don't have an account? Sign up here!"
		let mutableString = NSMutableAttributedString(attributedString: NSAttributedString(string: registerText))
		
		mutableString.addAttribute(
			NSForegroundColorAttributeName,
			value: MDCPalette.lightBlue.accent700!,
			range: NSRange(location: 22, length: 14)
		)
		
		registerLabel.attributedText = mutableString
		registerLabel.font = UIFont(name: "Helvetica Neue", size: 11)
		registerLabel.isUserInteractionEnabled = true
		
		view.addSubview(registerLabel)
		
		registerLabel.snp.makeConstraints { make in
			make.bottom.equalTo(view).offset(-10)
			make.centerX.equalTo(view)
		}
		
		// register click label
		registerLabel.rx
			.tapGesture()
			.when(.recognized)
			.subscribe(onNext: { [weak self] _ in
				guard let this = self else { return }
				try? this.router.route(from: this, to: LoginRouter.Routes.login.rawValue)
			})
			.disposed(by: disposeBag)
	}
}
