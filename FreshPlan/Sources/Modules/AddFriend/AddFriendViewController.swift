//
//  AddFriendViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-03.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import MaterialComponents

public final class AddFriendViewController: UIViewController {
  //: MARK - ViewModel
  private var viewModel: AddFriendViewModelProtocol!
  
  //: MARK - AppBar
  fileprivate var appBar: MDCAppBar = MDCAppBar()
  private var closeButton: UIBarButtonItem!
  
  //: MARK - TableView
  private var searchBar: SearchBar!
  private var tableView: UITableView!
  private var emptyView: EmptyView!
  
  //: MARK - Default TableViewCell
  private var defaultCell: UITableViewCell = UITableViewCell()
  
  //: MARK - DisposeBag
  private var disposeBag: DisposeBag = DisposeBag()
  
  public convenience init(viewModel: AddFriendViewModel) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    
    addChildViewController(appBar.headerViewController)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    prepareView()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // disables the default nav bar for that user
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  public override var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar.headerViewController
  }
 
  private func prepareView() {
    prepareEmptyView()
    prepareTableView()
    prepareNavigationBar()
    prepareNavigationAdd()
    prepareSearchBar()
    appBar.addSubviewsToParent()
  }
  
  private func prepareEmptyView() {
    emptyView = EmptyView()
    
    view.addSubview(emptyView)
    
    emptyView.snp.makeConstraints { $0.edges.equalTo(view) }
  }
  
  private func prepareSearchBar() {
    //: TODO - Fix searchbar sizing on navigation bar
    searchBar = SearchBar()
    searchBar.sizeToFit()
    
    // we'll make a check for ios 11    
    searchBar.rx.text
      .orEmpty
      .bind(to: viewModel.searchText)
      .disposed(by: disposeBag)
    
    appBar.navigationBar.titleView = searchBar
  }
  
  private func prepareTableView() {
    tableView = UITableView()
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { $0.edges.equalTo(view) }
    
    // we want to check for the tableviews.
    viewModel.friends
      .asObservable()
      .bind(to: tableView.rx.items(cellIdentifier: "defaultCell")) { (index, friend, cell) in
        cell.textLabel?.text = friend.displayName
        cell.detailTextLabel?.text = friend.email
      }
      .disposed(by: disposeBag)
    
    viewModel.friends
      .asObservable()
      .filter { $0.isEmpty }
      .map { !$0.isEmpty }
      .bind(to: emptyView.rx.isHidden)
      .disposed(by: disposeBag)
    
    viewModel.friends
      .asObservable()
      .filter { $0.isNotEmpty }
      .map { !$0.isNotEmpty }
      .bind(to: tableView.rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  private func prepareNavigationAdd() {
    closeButton = UIBarButtonItem(
      image: UIImage(named: "ic_close")?.withRenderingMode(.alwaysTemplate),
      style: .plain,
      target: nil,
      action: nil
    )
    
    // setup the rx event
    closeButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] _ in
        guard let this = self else { return }
        this.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    
    navigationItem.leftBarButtonItem = closeButton
  }
  
  private func prepareNavigationBar() {
    appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
    appBar.navigationBar.tintColor = UIColor.white
    appBar.headerViewController.headerView.maximumHeight = 76.0
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    
    appBar.headerViewController.headerView.trackingScrollView = tableView
    
    appBar.navigationBar.observe(navigationItem)
  }
  
  deinit {
    appBar.navigationBar.unobserveNavigationItem()
  }
}
