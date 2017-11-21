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
	
	//: MARK - DisposeBag
	private let disposeBag: DisposeBag = DisposeBag()
	
	//: MARK - TableView
	private var profileTableView: UITableView!
	private var dataSource: RxTableViewSectionedReloadDataSource<ProfileViewModel.SectionModel>!
	
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
	
	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}
	
	public override var childViewControllerForStatusBarStyle: UIViewController? {
		return appBar.headerViewController
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
	}
	
	private func prepareView() {
		prepareProfileTableView()
		prepareNavigationBar()
		appBar.addSubviewsToParent()
	}
	
	private func prepareNavigationBar() {
		appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
		appBar.headerViewController.headerView.trackingScrollView = self.profileTableView
		appBar.navigationBar.tintColor = UIColor.white
		appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
		
		Observable.just("Profile")
			.bind(to: navigationItem.rx.title)
			.disposed(by: disposeBag)
		
		appBar.navigationBar.observe(navigationItem)
	}
	
	private func prepareProfileTableView() {
		profileTableView = UITableView()
		profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
		
		view.addSubview(profileTableView)
		
		profileTableView.snp.makeConstraints { $0.edges.equalTo(view) }
		
		// set up data sources
		dataSource = RxTableViewSectionedReloadDataSource<ProfileViewModel.SectionModel>(configureCell: { (dataSource, table, index, _) in
			switch dataSource[index] {
			case let .displayName(_, name):
				guard let cell = table.dequeueReusableCell(withIdentifier: "defaultCell") else { fatalError() }
				cell.textLabel?.text = name
				return cell
			case let .email(_, description):
				guard let cell = table.dequeueReusableCell(withIdentifier: "defaultCell") else { fatalError() }
				cell.textLabel?.text = description
				return cell
			default:
				return UITableViewCell()
			}
		})
		
		dataSource.titleForHeaderInSection = { _, _ in
			return ""
		}
		
		viewModel.profileItems
			.asObservable()
			.subscribe(onNext: { lol in
				print (lol)
			})
			.disposed(by: disposeBag)
		
		viewModel.profileItems
			.asObservable()
			.bind(to: profileTableView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
	}
}
