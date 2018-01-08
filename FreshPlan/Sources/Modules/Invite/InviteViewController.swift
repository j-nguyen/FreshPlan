//
//  InviteViewController.swift
//  FreshPlan
//
//  Created by Allan Lin on 2017-12-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import MaterialComponents
import RxSwift
import RxDataSources
import SnapKit

public final class InviteViewController: UIViewController {
    // MARK: ViewModel
    private var viewModel: InviteViewModelProtocol!
    private var router: InviteRouter!
  
  // MARKa: dataSource
  fileprivate var dataSource: RxTableViewSectionedAnimatedDataSource<InviteViewModel.Section>!
    
    // MARK: AppBar
    fileprivate var appBar: MDCAppBar = MDCAppBar()
  
  // MARK: EmptyView
  private var emptyInviteView: EmptyInvitationView!
    
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
      prepareEmptyInviteView()
      prepareNavigationBar()
      appBar.addSubviewsToParent()
      
      dataSource = RxTableViewSectionedAnimatedDataSource(
        configureCell: { dataSource, tableView, index, model in
          let cell = tableView.dequeueCell(ofType: InviteCell.self, for: index)
          cell.meetupName.on(.next(dataSource[index].meetupName))
          cell.inviter.on(.next(dataSource[index].inviter.displayName))
          cell.startDate.on(.next(dataSource[index].meetupStartDate))
          cell.endDate.on(.next(dataSource[index].meetupEndDate))
          return cell
        }
      )
      
      dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .automatic, reloadAnimation: .automatic, deleteAnimation: .automatic)
      
      dataSource.canEditRowAtIndexPath = { _, _ in
        return true
      }
      
      viewModel.invitations
        .asObservable()
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
      
    }
  
  // TableView
    private func prepareTableView() {
      tableView = UITableView()
      tableView.estimatedRowHeight = 44
      tableView.rowHeight = 80
      tableView.rx.setDelegate(self).disposed(by: disposeBag)
      tableView.registerCell(InviteCell.self)
        
      view.addSubview(tableView)
      tableView.snp.makeConstraints{ $0.edges.equalTo(view) }
      
      viewModel.acceptInvitaionSuccess
        .asObservable()
        .filterNil()
        .subscribe(onNext: { displayName in
          let message = MDCSnackbarMessage(text: "Successfully accepted Invitation for \(displayName).")
          MDCSnackbarManager.show(message)
        })
        .disposed(by: disposeBag)
      
      viewModel.declineInvitationSuccess
        .asObservable()
        .filterNil()
        .subscribe(onNext: { displayName in
          let message = MDCSnackbarMessage(text: "Successfully declined Invitation for \(displayName).")
          MDCSnackbarManager.show(message)
        })
        .disposed(by: disposeBag)

    }
  
  // EmptyInviteView
  private func prepareEmptyInviteView() {
    emptyInviteView = EmptyInvitationView()
    
    view.addSubview(emptyInviteView)
    
    emptyInviteView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    
    viewModel.invitations
      .asObservable()
      .map { $0.count == 0 }
      .bind(to: tableView.rx.isHidden)
      .disposed(by: disposeBag)
    
    viewModel.invitations
      .asObservable()
      .map { $0.count > 0 }
      .bind(to: emptyInviteView.rx.isHidden)
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
  
  public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let acceptInvite = UITableViewRowAction(
      style: .normal,
      title: "Accept",
      handler: { [weak self] _, index in
        guard let this = self else { return }
        this.viewModel.acceptInvitation.on(.next(index))
      }
    )
    let declineInvite = UITableViewRowAction(
      style: .normal,
      title: "Decline",
      handler: { [weak self] _, index in
        guard let this = self else { return }
        this.viewModel.declineInvitation.on(.next(indexPath))
      }
    )
    acceptInvite.backgroundColor = MDCPalette.green.tint400
    declineInvite.backgroundColor = MDCPalette.red.tint400
    return [declineInvite, acceptInvite]
  }

}

