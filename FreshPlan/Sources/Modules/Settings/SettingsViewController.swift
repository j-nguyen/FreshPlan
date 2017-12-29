//
//  SettingsViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-28.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit
import MaterialComponents

public final class SettingsViewController: UIViewController {
  // MARK: Properties
  private var viewModel: SettingsViewModelProtocol!
  private var router: SettingsRouter!
  
  // MARK: Views
  private var tableView: UITableView!
  
  //MARK: AppBar
  private let appBar: MDCAppBar = MDCAppBar()
  
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public convenience init(viewModel: SettingsViewModel, router: SettingsRouter) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    self.router = router
    
    addChildViewController(appBar.headerViewController)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  public override var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar.headerViewController
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    prepareView()
  }
  
  private func prepareView() {
    prepareTableView()
    prepareNavigationBar()
    appBar.addSubviewsToParent()
  }
  
  private func prepareTableView() {
    // set layout margins to fix
    tableView = UITableView(frame: .zero, style: .grouped)
    tableView.layoutMargins = UIEdgeInsets.zero
    tableView.separatorInset = UIEdgeInsets.zero
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
  }
  
  private func prepareNavigationBar() {
    appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
    appBar.navigationBar.tintColor = UIColor.white
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    
    Observable.just("Settings")
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    // table stuff
    appBar.headerViewController.headerView.trackingScrollView = tableView
    
    appBar.navigationBar.observe(navigationItem)
  }
  
  deinit {
    appBar.navigationBar.unobserveNavigationItem()
  }
}
