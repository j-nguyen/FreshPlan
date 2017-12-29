//
//  HomeViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit

public final class HomeViewController: UITabBarController {
	public convenience init() {
		self.init(nibName: nil, bundle: nil)
	}
	
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
    
    // MARK:  View Controllers
    let meetupController = MeetupAssembler.make()
    let profileController = ProfileAssembler.make()
    let settingsController = SettingsAssembler.make()
    
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
    
    settingsController.tabBarItem = UITabBarItem(
      title: "Settings",
      image: UIImage(named: "ic_settings")?.withRenderingMode(.alwaysTemplate),
      tag: 2
    )
    
    let viewControllers = [meetupController, profileController, settingsController].flatMap { UINavigationController(rootViewController: $0) }
    
    setViewControllers(viewControllers, animated: false)
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
}
