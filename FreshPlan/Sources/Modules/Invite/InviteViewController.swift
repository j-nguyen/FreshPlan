//
//  InviteViewController.swift
//  FreshPlan
//
//  Created by Allan Lin on 2017-12-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import RxSwift
import SnapKit

public final class InviteViewController: UIViewController {
    // MARK: ViewModel
    private var viewModel: InviteViewModelProtocol!
    private var router: InviteRouter!
    
    //MARK: AppBar
    fileprivate var appBar: MDCAppBar = MDCAppBar()
    
    //MARK: TableView
    private var containerView: UIView!
    private var tableView: UITableView!
    
    // MARK:  DisposeBag
    private var disposeBag: DisposeBag = DisposeBag()
    
    public convenience init(viewModel: InviteViewModel, router: InviteRouter) {
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override var childViewControllerForStatusBarStyle: UIViewController? {
        return appBar.headerViewController
    }
    
    public func prepareView() {
        prepareTableView()
        prepareNavigationBar()
        appBar.addSubviewsToParent()
    }
    
    private func prepareTableView() {
        tableView = UITableView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
      tableView.rx.setDelegate(self).disposed(by: disposeBag)
      tableView.registerCell(InviteCell.self)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(view) }
      
      viewModel.invitations
        .asObservable()
        .bind(to: tableView.rx.items(cellIdentifier: String(describing: InviteCell.self))) { (index, invite, cell) in
        cell.textLabel?.text = invite.inviter.displayName
          cell.detailTextLabel?.text = invite.inviter.email
          
      }
      .disposed(by: disposeBag)
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
            
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        
        appBar.navigationBar.observe(navigationItem)
        
    }
    
    deinit {
        appBar.navigationBar.unobserveNavigationItem()
    }
}

// MARK:  TableViewDelegate
extension InviteViewController: UITableViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == appBar.headerViewController.headerView.trackingScrollView {
            appBar.headerViewController.headerView.trackingScrollDidEndDecelerating()
        }
    }
}

