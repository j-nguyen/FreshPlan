//
//  VerifyViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import RxSwift
import MaterialComponents

public final class VerifyViewController: UIViewController {
	private var router: VerifyRouter!
	private var viewModel: VerifyViewModelProtocol!
	
	private let disposeBag = DisposeBag()
	
	fileprivate let appBar = MDCAppBar()
	
	//: MARK - Text Fields
	private var verifyTextField: UITextField!
	
	//: MARK - Button
	private var submitButton: MDCButton!
	
	//: MARK - Left Button Item
	private var closeButton: UIBarButtonItem!
	
	public convenience init(router: VerifyRouter, viewModel: VerifyViewModel) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.router = router
		
		self.addChildViewController(appBar.headerViewController)
	}
	
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		// prepare views here
		prepareView()
	}
	
	public override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	fileprivate func prepareView() {
		view.backgroundColor = .blueBackgroundColor
		prepareVerifyTextField()
		prepareSubmitButton()
		prepareDismissKeyboard()
		prepareErrorSnackBar()
		prepareAppBar()
	}
	
	// MARK : Preparing Views and Bindings
	
	fileprivate func prepareAppBar() {
		appBar.addSubviewsToParent()
		appBar.navigationBar.backgroundColor = .blueBackgroundColor
		appBar.headerViewController.headerView.backgroundColor = .blueBackgroundColor
		
		closeButton = UIBarButtonItem(
			image: UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate),
			style: .plain,
			target: nil,
			action: nil
		)
		
		closeButton.tintColor = .white
		
		closeButton.rx.tap
			.asObservable()
			.subscribe(onNext: { [weak self] in
				guard let this = self else { return }
				this.dismiss(animated: true, completion: nil)
			})
			.disposed(by: disposeBag)
		
		appBar.navigationBar.leftBarButtonItem = closeButton
		
		let mutator = MDCNavigationBarTextColorAccessibilityMutator()
		mutator.mutate(appBar.navigationBar)
	}
	
	fileprivate func prepareErrorSnackBar() {
		viewModel.error
			.asObservable()
			.filterEmpty()
			.subscribe(onNext: { [weak self] reason in
				guard let this = self else { return }
				if this.verifyTextField.becomeFirstResponder() { this.verifyTextField.resignFirstResponder() }
				// create snackbar
				let message = MDCSnackbarMessage()
				message.text = reason
				MDCSnackbarManager.show(message)
			})
			.disposed(by: disposeBag)
	}
	
	fileprivate func prepareDismissKeyboard() {
		view.rx.tapGesture()
			.when(.recognized)
			.asObservable()
			.subscribe(onNext: { [weak self] _ in
				guard let this = self else { return }
				this.verifyTextField.resignFirstResponder()
			})
			.disposed(by: disposeBag)
	}
	
	fileprivate func prepareVerifyTextField() {
		verifyTextField = UITextField()
		verifyTextField.borderStyle = .roundedRect
		verifyTextField.keyboardType = .numberPad
		verifyTextField.returnKeyType = .done
		verifyTextField.font = UIFont(name: "Helvetica Neue", size: 28)
		verifyTextField.placeholder = "Verification Code"
		verifyTextField.textAlignment = .center
		
		view.addSubview(verifyTextField)
		
		verifyTextField.snp.makeConstraints { make in
			make.centerY.equalTo(view).offset(-75)
			make.centerX.equalTo(view)
			make.width.equalTo(350)
			make.height.equalTo(60)
		}
		
		verifyTextField.rx.text
			.orEmpty
			.map { Int($0) }
			.filterNil()
			.bind(to: viewModel.verificationCode)
			.disposed(by: disposeBag)
	}
	
	fileprivate func prepareSubmitButton() {
		submitButton = MDCButton()
		submitButton.setTitle("Submit", for: .normal)
		submitButton.backgroundColor = .greenBackgroundColor
	
		view.addSubview(submitButton)
		
		submitButton.snp.makeConstraints { make in
			make.top.equalTo(verifyTextField.snp.bottom).offset(15)
			make.centerX.equalTo(view)
			make.width.equalTo(350)
			make.height.equalTo(60)
		}
		
		viewModel.submitTap = submitButton.rx.tap.asObservable()
		viewModel.bindButton()
		
		viewModel.submitSuccess
			.asObservable()
			.filter { $0 }
			.subscribe(onNext: { [weak self] _ in
				guard let this = self else { return }
				this.dismiss(animated: true, completion: nil)
			})
			.disposed(by: disposeBag)
	}
}
