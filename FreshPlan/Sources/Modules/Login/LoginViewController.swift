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
import RxOptional

public class LoginViewController: UIViewController {
	private var viewModel: LoginViewModelProtocol!
	private var router: LoginRouter!
	
	// MARK: - Stack Views
	private var stackView: UIStackView!
	
	// MARK: - Buttons
	private var loginButton: MDCButton!
	
	// MARK: - TextField
	private var emailField: MDCTextField!
	private var passwordField: MDCTextField!
	
	// MARK: - UILabel
	private var registerLabel: UILabel!
	
	// MARK: - Floating Placeholder Input
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
		prepareErrorBinding()
	}
	
	fileprivate func prepareErrorBinding() {
		viewModel.error
			.asObservable()
			.filterEmpty()
			.subscribe(onNext: { reason in
				// create a snack bar displaying the reason
				let message = MDCSnackbarMessage()
				message.text = reason
				MDCSnackbarManager.show(message)
			})
			.disposed(by: disposeBag)
	}
	
	fileprivate func prepareView() {
		prepareStackView()
		prepareEmailField()
		preparePasswordField()
		prepareLoginButton()
		prepareRegisterLabel()
	}
	
	// MARK - Preparing Views

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
	
	fileprivate func prepareEmailField() {
		emailField = MDCTextField()
		emailField.placeholder = "Email Address"
		emailField.returnKeyType = .next
		emailField.keyboardType = .emailAddress
		emailField.autocapitalizationType = .none
		
		emailFieldController = MDCTextInputControllerDefault(textInput: emailField)
		
		stackView.addArrangedSubview(emailField)
		
		emailField.snp.makeConstraints { make in
			make.width.equalTo(view).inset(20)
		}
		
		emailField.rx.controlEvent(.editingDidEndOnExit)
			.subscribe(onNext: { [weak self] in
				guard let this = self else { return }
				this.passwordField.becomeFirstResponder()
			})
			.disposed(by: disposeBag)
		
		emailField.rx.text
			.orEmpty
			.bind(to: viewModel.email)
			.disposed(by: disposeBag)
	}
	
	fileprivate func preparePasswordField() {
		passwordField = MDCTextField()
		passwordField.placeholder = "Password"
		passwordField.isSecureTextEntry = true
		passwordField.returnKeyType = .done
		
		passwordFieldController = MDCTextInputControllerDefault(textInput: passwordField)
		
		stackView.addArrangedSubview(passwordField)
		
		passwordField.snp.makeConstraints { make in
			make.width.equalTo(view).inset(20)
		}
		
		passwordField.rx.text
			.orEmpty
			.bind(to: viewModel.password)
			.disposed(by: disposeBag)
	}
	
	fileprivate func prepareLoginButton() {
		loginButton = MDCButton()
		loginButton.setTitle("Login", for: .normal)
		loginButton.backgroundColor = MDCPalette.lightBlue.tint800
		
		stackView.addArrangedSubview(loginButton)
		
		loginButton.snp.makeConstraints { make in
			make.width.equalTo(view).inset(20)
			make.height.equalTo(50)
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
				
				try? this.router.route(from: this, to: LoginRouter.Routes.home.rawValue)
			})
			.disposed(by: disposeBag)
		
		viewModel.loginUnverified
			.asObservable()
			.filter { $0 }
			.subscribe(onNext: { [weak self] _ in 
				guard let this = self else { return }
				guard let text = this.emailField.text else { return }
				
				try? this.router.route(from: this, to: LoginRouter.Routes.verify.rawValue, parameters: ["email": text])
			})
			.disposed(by: disposeBag)
	}
	
	fileprivate func prepareRegisterLabel() {
		registerLabel = UILabel()
		// we want the last bit to be blue
		let registerText = "Don't have an account? Sign up here!"
		let mutableString = NSMutableAttributedString(attributedString: NSAttributedString(string: registerText))
		
		mutableString.addAttribute(
			NSAttributedStringKey.foregroundColor,
			value: MDCPalette.lightBlue.accent700!,
			range: NSRange(location: 22, length: 14)
		)
		
		registerLabel.attributedText = mutableString
		registerLabel.font = MDCTypography.titleFont()
		registerLabel.isUserInteractionEnabled = true
		
		view.addSubview(registerLabel)
		
		registerLabel.snp.makeConstraints { make in
			make.bottom.equalTo(view).inset(20)
			make.centerX.equalTo(view)
		}
		
		// register click label
		registerLabel.rx
			.tapGesture()
			.when(.recognized)
			.subscribe(onNext: { [weak self] _ in
				guard let this = self else { return }
				try? this.router.route(from: this, to: LoginRouter.Routes.register.rawValue)
			})
			.disposed(by: disposeBag)
	}
}
