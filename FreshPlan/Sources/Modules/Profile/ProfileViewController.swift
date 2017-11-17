//
//  ProfileViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift

public final class ProfileViewController: UIViewController {
	//: MARK - Profile View Model and Router
	private var viewModel: ProfileViewModelProtocol!
	private var router: ProfileRouter!
	
	public convenience init(viewModel: ProfileViewModel, router: ProfileRouter) {
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
	}
}
