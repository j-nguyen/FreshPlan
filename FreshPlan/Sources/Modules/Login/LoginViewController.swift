//
//  LoginViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-05.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import SnapKit

public class LoginViewController: UIViewController {
	private var viewModel: LoginViewModelProtocol!
	private var router: LoginRouter!
	
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
	}
}
