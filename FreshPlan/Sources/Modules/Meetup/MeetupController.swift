//
//  MeetupController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-13.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import MaterialComponents
import RxSwift
import SnapKit

public final class MeetupController: UIViewController {
	private var viewModel: MeetupViewModelProtocol!
	private var router: MeetupRouter!
  
  //MARK: views
  private var emptyMeetupView: EmptyMeetupView!
  private var tableView: UITableView!
  
  //MARK: App Bar
  fileprivate let appBar: MDCAppBar = MDCAppBar()
  
  //MARK: DisposeBag
  private let disposeBag: DisposeBag = DisposeBag()
	
	public convenience init(viewModel: MeetupViewModel, router: MeetupRouter) {
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
  
  public override var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar.headerViewController
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
	
	public override func viewDidLoad() {
		super.viewDidLoad()
    prepareView()
	}
  
  private func prepareView() {
    prepareTableView()
    prepareEmptyMeetupView()
    prepareNavigationBar()
    appBar.addSubviewsToParent()
  }
  
  private func prepareTableView() {
    tableView = UITableView()
    tableView.layoutMargins = .zero
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(tableView)
    }
  }
  
  private func prepareEmptyMeetupView() {
    emptyMeetupView = EmptyMeetupView()
    
    view.addSubview(emptyMeetupView)
    
    
  }
  
  private func prepareNavigationBar() {
    appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
    appBar.navigationBar.tintColor = UIColor.white
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    
    appBar.headerViewController.headerView.trackingScrollView = tableView
    
    Observable.just("Meetup")
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    appBar.navigationBar.observe(navigationItem)
  }
  
  deinit {
    appBar.navigationBar.unobserveNavigationItem()
  }
}
