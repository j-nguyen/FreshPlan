//
//  AddMeetupViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import MaterialComponents
import RxSwift
import RxDataSources

public final class AddMeetupViewController: UIViewController {
  // MARK: Required
  private var viewModel: AddMeetupViewModelProtocol!
  private var router: AddMeetupRouter!
  
  // MARK: AppBar
  private let appBar: MDCAppBar = MDCAppBar()
  private var closeButton: UIBarButtonItem!
  private var addButton: UIBarButtonItem!
  
  // MARK: TableView
  private var tableView: UITableView!
  fileprivate var dataSource: RxTableViewSectionedReloadDataSource<AddMeetupViewModel.Section>!
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public convenience init(viewModel: AddMeetupViewModel, router: AddMeetupRouter) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    self.router = router
    
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
    setNeedsStatusBarAppearanceUpdate()
    
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    prepareView()
  }
  
  private func prepareView() {
    prepareTableView()
    prepareNavigationBar()
    prepareNavigationCloseButton()
    prepareNavigationAddButton()
    appBar.addSubviewsToParent()
  }
  
  private func prepareTableView() {
    tableView = UITableView()
    tableView.separatorInset = .zero
    tableView.layoutMargins = .zero
    tableView.estimatedRowHeight = 70
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.rx.setDelegate(self).disposed(by: disposeBag)
    
    if #available(iOS 11.0, *) {
      tableView.contentInsetAdjustmentBehavior = .never
    }
    
    tableView.registerCell(AddMeetupTextFieldCell.self)
    tableView.registerCell(AddMeetupTextViewCell.self)
    tableView.registerCell(AddMeetupGeocodeCell.self)
    tableView.registerCell(AddMeetupDateCell.self)
  
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    
    dataSource = RxTableViewSectionedReloadDataSource(
      configureCell: { [weak self] dataSource, tableView, index, model in
        guard let this = self else { fatalError() }
        
        switch dataSource[index] {
        case let .name(_, label):
          let cell = tableView.dequeueCell(ofType: AddMeetupTextFieldCell.self, for: index)
          cell.title.on(.next(label))
          return cell
        case let .description(_, label):
          let cell = tableView.dequeueCell(ofType: AddMeetupTextViewCell.self, for: index)
          cell.title.on(.next(label))
          return cell
        case let .location(_, label):
          let cell = tableView.dequeueCell(ofType: AddMeetupGeocodeCell.self, for: index)
          cell.title.on(.next(label))
    
          this.viewModel.address
            .asObservable()
            .bind(to: cell.textFieldText)
            .disposed(by: this.disposeBag)
          
          return cell
        case let .startDate(_, label):
          let cell = tableView.dequeueCell(ofType: AddMeetupDateCell.self, for: index)
          cell.title.on(.next(label))
          return cell
        case let .endDate(_, label):
          let cell = tableView.dequeueCell(ofType: AddMeetupDateCell.self, for: index)
          cell.title.on(.next(label))
          return cell
        default:
          return UITableViewCell()
        }
      }
    )
    
    dataSource.titleForHeaderInSection = { _, _ in return "" }
    
    viewModel.meetup
      .asObservable()
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    tableView.rx.modelSelected(AddMeetupViewModel.SectionItem.self)
      .subscribe(onNext: { [weak self] item in
        guard let this = self else { return }
        switch item {
        case .location:
          try? this.router.route(
            from: this,
            to: AddMeetupRouter.Routes.location.rawValue,
            parameters: ["viewModel": this.viewModel]
          )
        default:
          return
        }
      })
      .disposed(by: disposeBag)
    
  }
  
  private func prepareNavigationBar() {
    appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
    appBar.navigationBar.tintColor = UIColor.white
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    
    appBar.headerViewController.headerView.trackingScrollView = tableView
    
    Observable.just("Add Meetup")
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
    
    closeButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] in
        guard let this = self else { return }
        try? this.router.route(from: this, to: AddMeetupRouter.Routes.meetup.rawValue)
      })
      .disposed(by: disposeBag)
    
    navigationItem.leftBarButtonItem = closeButton
  }
  
  private func prepareNavigationAddButton() {
    addButton = UIBarButtonItem(
      image: UIImage(named: "ic_done")?.withRenderingMode(.alwaysTemplate),
      style: .plain,
      target: nil,
      action: nil
    )
    
    viewModel.addButtonEnabled
      .bind(to: addButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    addButton.rx.tap
      .asObservable()
      .subscribe(onNext: {
        
      })
      .disposed(by: disposeBag)
    
    navigationItem.rightBarButtonItem = addButton
  }
  
  /**
   Fixes the offset issue of the thing
  **/
  private func textViewDidChange() {
    let currentOffset = tableView.contentOffset
    UIView.setAnimationsEnabled(false)
    tableView.beginUpdates()
    tableView.endUpdates()
    UIView.setAnimationsEnabled(true)
    tableView.setContentOffset(currentOffset, animated: false)
  }
  
  deinit {
    appBar.navigationBar.unobserveNavigationItem()
  }
}

//MARK: UITableViewDelegate
extension AddMeetupViewController: UITableViewDelegate {
  public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch dataSource[indexPath] {
    case .name:
      return 50
    case .description:
      return 125
    default:
      return UITableViewAutomaticDimension
    }
  }
}
