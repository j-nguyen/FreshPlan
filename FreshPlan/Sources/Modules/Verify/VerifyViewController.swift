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
	
	// hide status bar
	public override var prefersStatusBarHidden: Bool {
		return true
	}
	
	//: MARK - Text Fields
	private var verifyTextField: UITextField!
	
	//: MARK - Button
	private var submitButton: MDCButton!
	
	public convenience init(router: VerifyRouter, viewModel: VerifyViewModel) {
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
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		// prepare views here
		prepareView()
	}
	
	fileprivate func prepareView() {
		view.backgroundColor = .blueBackgroundColor
		prepareVerifyTextField()
		prepareSubmitButton()
		prepareDismissKeyboard()
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
	}
}
