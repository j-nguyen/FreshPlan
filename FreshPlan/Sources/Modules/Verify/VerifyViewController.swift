//
//  VerifyViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import RxSwift

public final class VerifyViewController: UIViewController {
	private var router: VerifyRouter!
	private var viewModel: VerifyViewModelProtocol!
	
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
}
