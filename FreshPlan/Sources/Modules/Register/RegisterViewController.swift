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
	
    // loads the view
    public override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    //
    fileprivate func prepareView() {
        prepareFirstName()
        prepareLastName()
        prepareDisplayName()
        prepareEmail()
        preparePassword()
    }
    
    //
    fileprivate func prepareFirstName() {
        firstNameField = MDCTextField()
        firstNameField.placeholder = "First Name"
        firstNameField.returnKeyType = .next
        
        firstNameFieldController = MDCTextInputControllerDefault(textInput: firstNameField)
        
        view.addSubview(firstNameField)
        
        firstNameField.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(300)
        }
    }
    
    fileprivate func prepareLastName() {
        lastNameField = MDCTextField()
        lastNameField.placeholder = "Last Name"
        lastNameField.returnKeyType = .next
        
        lastNameFieldController = MDCTextInputControllerDefault(textInput: lastNameField)
        
        view.addSubview(lastNameField)
        
        lastNameField.snp.makeConstraints { make in
            make.top.equalTo(firstNameField.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(300)
        }
    }
    
    fileprivate func prepareDisplayName() {
        displayNameField = MDCTextField()
        displayNameField.placeholder = "Display Name"
        displayNameField.returnKeyType = .next
        
        displayNameFieldController = MDCTextInputControllerDefault(textInput: displayNameField)
        
        view.addSubview(displayNameField)
        
        displayNameField.snp.makeConstraints { make in
            make.top.equalTo(lastNameField.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(300)
            
        }
    }
    
    fileprivate func prepareEmail() {
        emailField = MDCTextField()
        emailField.placeholder = "Email"
        emailField.returnKeyType = .next
        
        emailFieldController = MDCTextInputControllerDefault(textInput: emailField)
        
        view.addSubview(emailField)
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(displayNameField.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(300)
            
        }
    }
    
    fileprivate func preparePassword() {
        passwordField = MDCTextField()
        passwordField.placeholder = "Password"
        passwordField.returnKeyType = .next
        
        passwordFieldController = MDCTextInputControllerDefault(textInput: passwordField)
        
        view.addSubview(passwordField)
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.width.equalTo(300)
            
        }
        
    }
    
    
	public convenience init(router: RegisterRouter, viewModel: RegisterViewModel) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.router = router
	}
	
    //
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
