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
    
    public func prepareView() {
        prepareTableView()
        prepareNavigationBar()
    }
    
    private func prepareTableView() {
        tableView = UITableView()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(view) }
    }
    
    private func prepareNavigationBar() {
        appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
        appBar.navigationBar.tintColor = UIColor.white
        appBar.headerViewController.headerView.maximumHeight = 120
        appBar.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        appBar.headerViewController.headerView.trackingScrollView = tableView
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    
        
        
        
        
    }
    
    
    
    
}
