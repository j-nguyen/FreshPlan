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
import RxDataSources
import MaterialComponents

public final class SendInviteViewController: UIViewController {
  // MARK: Properties
  private var viewModel: SendInviteViewModelProtocol!
  
  // MARK: App Bar
  fileprivate let appBar = MDCAppBar()
  private var closeButton: UIBarButtonItem!
  
  // MARK: Views
  private var tableView: UITableView!
  fileprivate var dataSource: RxTableViewSectionedAnimatedDataSource<SendInviteViewModel.Section>!
  
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
  
  public override var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar.headerViewController
  }
  
  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    prepareView()
  }
  
  private func prepareView() {
    prepareTableView()
    prepareNavigationBar()
    prepareNavigationCloseButton()
    appBar.addSubviewsToParent()
  }
  
  private func prepareTableView() {
    tableView = UITableView()
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = 44
    tableView.layoutMargins = .zero
    tableView.separatorInset = .zero
    tableView.separatorStyle = .singleLine
    tableView.registerCell(SendInviteMeetupCell.self)
    tableView.registerCell(SendInviteFriendCell.self)
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    
    dataSource = RxTableViewSectionedAnimatedDataSource<SendInviteViewModel.Section>(
      configureCell: { dataSource, tableView, index, model in
        switch dataSource[index] {
        case let .friend(_, displayName, email, checked):
          let cell = tableView.dequeueCell(ofType: SendInviteFriendCell.self, for: index)
          cell.displayName.onNext(displayName)
          cell.email.onNext(email)
          cell.checked.onNext(checked)
          return cell
        case let .meetup(_, title):
          let cell = tableView.dequeueCell(ofType: SendInviteMeetupCell.self, for: index)
          cell.placeholder.onNext(title)
          return cell
        }
      }
    )
    
    dataSource.titleForHeaderInSection = { _, _ in  return "" }
    
    dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic)
    
    dataSource.canEditRowAtIndexPath = { dataSource, index in
      switch dataSource[index] {
      case .friend:
        return true
      default: return false
      }
    }
    
    viewModel.invites
      .asObservable()
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  private func prepareNavigationBar() {
    appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
    appBar.navigationBar.tintColor = UIColor.white
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    
    appBar.headerViewController.headerView.trackingScrollView = tableView
    
    // set the nav bar title
    Observable.just("Send Invites")
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    appBar.navigationBar.observe(navigationItem)
  }
  
  private func prepareNavigationCloseButton() {
    closeButton = UIBarButtonItem(
      image: UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate),
      style: .plain,
      target: nil,
      action: nil
    )
    closeButton.tintColor = .white
    
    closeButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    navigationItem.leftBarButtonItem = closeButton
  }
  
  deinit {
    appBar.navigationBar.unobserveNavigationItem()
  }
}
