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
	private var registerClickLabel: UILabel!
	
	// MARK - Floating Placeholder Input
	private var emailFieldController: MDCTextInputController!
	private var passwordFieldController: MDCTextInputController!
	
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
	}
	
	fileprivate func preparePasswordField() {
		passwordField = MDCTextField()
		passwordField.placeholder = "Password"
		
		passwordFieldController = MDCTextInputControllerDefault(textInput: passwordField)
		
		view.addSubview(passwordField)
		
		passwordField.snp.makeConstraints { make in
			make.top.equalTo(emailField.snp.bottom).offset(10)
			make.left.equalTo(10)
			make.right.equalTo(-10)
			make.width.equalTo(300)
		}
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
	}
}
