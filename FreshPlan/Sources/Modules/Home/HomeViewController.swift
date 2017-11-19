//
//  HomeViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit

public final class HomeViewController: UITabBarController {
	public var viewModel: HomeViewModelProtocol!
	public var router: HomeRouter!
	
	public convenience init(viewModel: HomeViewModel, router: HomeRouter) {
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
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		//: MARK - View Controllers
		let meetupController = MeetupAssembler.make()
		let profileController = ProfileAssembler.make()
		
		meetupController.tabBarItem = UITabBarItem(
			title: "Home",
			image: UIImage(named: "ic_home")?.withRenderingMode(.alwaysTemplate),
			tag: 0
		)
		
		profileController.tabBarItem = UITabBarItem(
			title: "Profile",
			image: UIImage(named: "ic_account_circle")?.withRenderingMode(.alwaysTemplate),
			tag: 1
		)
		
		let viewControllers = [meetupController, profileController].flatMap { UINavigationController(rootViewController: $0) }
		
		setViewControllers(viewControllers, animated: animated)
	}
}
