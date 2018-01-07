//
//  SendInviteViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2018-01-07.
//  Copyright © 2018 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import MaterialComponents

public final class SendInviteViewController: UIViewController {
  // MARK: Properties
  private var viewModel: SendInviteViewModelProtocol!
  
  // MARK: App Bar
  fileprivate let appBar = MDCAppBar()
  
  // MARK: Views
  private var tableView: UITableView!
  
  private let disposeBag = DisposeBag()
  
  public convenience init(viewModel: SendInviteViewModel) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    
    addChildViewController(appBar.headerViewController)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
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
    tableView = UITableView()
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
  }
  
  private func prepareNavigationBar() {
    appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
    appBar.navigationBar.tintColor = UIColor.white
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    
    appBar.headerViewController.headerView.trackingScrollView = tableView
    
    // set the nav bar title
    Observable.just("My Invitations")
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    tableView.layoutMargins = .zero
    tableView.separatorInset = .zero
    
    appBar.navigationBar.observe(navigationItem)
  }
  
  deinit {
    appBar.navigationBar.unobserveNavigationItem()
  }
}
