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
  private var refreshControl: UIRefreshControl!
  
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
    prepareRefreshControl()
    prepareTableView()
    prepareEmptyMeetupView()
    prepareNavigationBar()
    appBar.addSubviewsToParent()
  }
  
  private func prepareTableView() {
    tableView = UITableView()
    tableView.refreshControl = refreshControl
    tableView.separatorStyle = .singleLine
    tableView.separatorInset = .zero
    tableView.layoutMargins = .zero
    tableView.rowHeight = 80
    tableView.registerCell(MeetupCell.self)
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    
    viewModel.meetups
      .asObservable()
      .bind(to: tableView.rx.items(cellIdentifier: String(describing: MeetupCell.self), cellType: MeetupCell.self)) { index, meetup, cell in
        cell.name.on(.next(meetup.title))
        cell.startDate.on(.next(meetup.startDate))
        cell.endDate.on(.next(meetup.endDate))
      }
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(Meetup.self)
      .asObservable()
      .subscribe(onNext: { [weak self] meetup in
        if let this = self {
          try? this.router.route(
            from: this,
            to: MeetupRouter.Routes.meetup.rawValue,
            parameters: ["meetupId": meetup.id]
          )
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func prepareRefreshControl() {
    refreshControl = UIRefreshControl()
    
    refreshControl.rx.controlEvent(.valueChanged)
      .asObservable()
      .subscribe(onNext: { [weak self] in
        guard let this = self else { return }
        this.viewModel.refreshContent.on(.next(()))
      })
      .disposed(by: disposeBag)
    
    viewModel.refreshSuccess
      .asObservable()
      .subscribe(onNext: { [weak self] in
        guard let this = self else { return }
        this.refreshControl.endRefreshing()
      })
      .disposed(by: disposeBag)
  }
  
  private func prepareEmptyMeetupView() {
    emptyMeetupView = EmptyMeetupView()
    
    view.addSubview(emptyMeetupView)
    
    emptyMeetupView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    
    viewModel.meetups
      .asObservable()
      .map { $0.count == 0 }
      .bind(to: tableView.rx.isHidden)
      .disposed(by: disposeBag)
    
    viewModel.meetups
      .asObservable()
      .map { $0.count > 0 }
      .bind(to: emptyMeetupView.rx.isHidden)
      .disposed(by: disposeBag)
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
