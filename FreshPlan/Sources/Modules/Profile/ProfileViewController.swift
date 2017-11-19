//
//  ProfileViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional
import RxDataSources
import MaterialComponents

public final class ProfileViewController: UIViewController {
	//: MARK - Profile View Model and Router
	private var viewModel: ProfileViewModelProtocol!
	private var router: ProfileRouter!
	
	//: MARK - AppBar
	fileprivate let appBar: MDCAppBar = MDCAppBar()
	
	//: MARK - TableView
	private var profileTableView: UITableView!
	
	public convenience init(viewModel: ProfileViewModel, router: ProfileRouter) {
		self.init(nibName: nil, bundle: nil)
		self.viewModel = viewModel
		self.router = router
		
		addChildViewController(appBar.headerViewController)
	}
	
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// sets up the nav to be hidden
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
	}
	
	private func prepareView() {
		
		appBar.addSubviewsToParent()
	}
	
	private func prepareNavigationBar() {
		appBar.headerViewController.headerView.backgroundColor =
		appBar.headerViewController.headerView.trackingScrollView = profileTableView
		appBar.navigationBar.tintColor = UIColor.white
		
		Observable.just("")
	}
	
	private func prepareProfileTableView() {
		profileTableView = UITableView()
		
		profileTableView
	}
}
