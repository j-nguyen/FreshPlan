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
  fileprivate var dataSource: RxTableViewSectionedReloadDataSource<ProfileViewModel.SectionModel>!
  
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
    appBar.navigationBar.tintColor = UIColor.white
    appBar.headerViewController.headerView.maximumHeight = 76.0
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    
    Observable.just("Profile")
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    appBar.navigationBar.observe(navigationItem)
  }
  
  private func prepareProfileTableView() {
    profileTableView = UITableView()
    profileTableView.estimatedRowHeight = 44
    profileTableView.rowHeight = UITableViewAutomaticDimension
    profileTableView.separatorStyle = .none
    profileTableView.rx.setDelegate(self).disposed(by: disposeBag)
    profileTableView.registerCell(ProfileUserHeaderCell.self)
    profileTableView.registerCell(ProfileUserInfoCell.self)
    
    view.addSubview(profileTableView)
    
    profileTableView.snp.makeConstraints { $0.edges.equalTo(view) }
    
    appBar.headerViewController.headerView.trackingScrollView = profileTableView
    
    // set up data sources
    dataSource = RxTableViewSectionedReloadDataSource<ProfileViewModel.SectionModel>(configureCell: { (dataSource, table, index, _) in
      switch dataSource[index] {
      case let .profile(_, profileURL, fullName):
        let cell = table.dequeueCell(ofType: ProfileUserHeaderCell.self, for: index)
        cell.fullName.on(.next(fullName))
        cell.profileURL.on(.next(profileURL))
        return cell
      case let .displayName(_, name):
        let cell = table.dequeueCell(ofType: ProfileUserInfoCell.self, for: index)
        cell.textLabel?.text = name
        return cell
      case let .email(_, description):
        let cell = table.dequeueCell(ofType: ProfileUserInfoCell.self, for: index)
        cell.textLabel?.text = description
        return cell
      case let .friend(displayName):
        let cell = table.dequeueCell(ofType: ProfileUserInfoCell.self, for: index)
        cell.textLabel?.text = displayName
        return cell
      }
    })
    
    viewModel.profileItems
      .asObservable()
      .bind(to: profileTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}

//: MARK - UIScrollViewDelegate
extension ProfileViewController: UITableViewDelegate {
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    switch dataSource.sectionModels[section] {
    case let .friends(_, title, _):
      let friendView = ProfileUserHeaderView()
      friendView.title.on(.next(title))
      return friendView
    case let .friendRequests(_, title, _):
      let friendView = ProfileUserHeaderView()
      friendView.title.on(.next(title))
      return friendView
    default:
      return nil
    }
  }
  
  public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    switch dataSource.sectionModels[section] {
    case .friends, .friendRequests:
      return 40
    default:
      return 0
    }
  }
  
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == appBar.headerViewController.headerView.trackingScrollView {
      appBar.headerViewController.headerView.trackingScrollDidScroll()
    }
  }
  
  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView == appBar.headerViewController.headerView.trackingScrollView {
      appBar.headerViewController.headerView.trackingScrollDidEndDecelerating()
    }
  }
}
