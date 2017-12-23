//
//  LocationViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import MaterialComponents

public final class LocationViewController: UIViewController {
  // MARK: Required
  private var viewModel: LocationViewModelProtocol!
  
  // MARK: AppBar
  fileprivate let appBar: MDCAppBar = MDCAppBar()
  private var searchBar: SearchBar!
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public convenience init(viewModel: LocationViewModel) {
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
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    prepareView()
  }
  
  private func prepareView() {
    prepareSearchBar()
    prepareNavigationBar()
    appBar.addSubviewsToParent()
  }
  
  private func prepareSearchBar() {
    //: TODO - Fix searchbar sizing on navigation bar
    searchBar = SearchBar()
    
    // we'll make a check for ios 11
//    searchBar.rx.text
//      .orEmpty
//      .bind(to: viewModel.searchText)
//      .disposed(by: disposeBag)
    
    Observable.just("Search for friends")
      .bind(to: searchBar.rx.placeholder)
      .disposed(by: disposeBag)
    
    searchBar.rx.searchButtonClicked
      .asObservable()
      .subscribe(onNext: { [weak self] in
        guard let this = self else { return }
        this.searchBar.resignFirstResponder()
      })
      .disposed(by: disposeBag)
    
    appBar.headerStackView.bottomBar = searchBar
  }
  
  private func prepareNavigationBar() {
    appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
    appBar.navigationBar.tintColor = UIColor.white
    appBar.headerViewController.headerView.maximumHeight = 120
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]

//    appBar.headerViewController.headerView.trackingScrollView = tableView
    
    appBar.navigationBar.observe(navigationItem)
  }
  
  deinit {
    appBar.navigationBar.unobserveNavigationItem()
  }
}
