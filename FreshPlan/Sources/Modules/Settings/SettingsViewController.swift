//
//  SettingsViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-28.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import RxSwift
import SnapKit
import RxDataSources
import MaterialComponents

public final class SettingsViewController: UIViewController {
  // MARK: Properties
  private var viewModel: SettingsViewModelProtocol!
  
  // MARK: Views
  private var tableView: UITableView!
  private var dataSource: RxTableViewSectionedReloadDataSource<SettingsViewModel.Section>!
  
  //MARK: AppBar
  private let appBar: MDCAppBar = MDCAppBar()
  
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public convenience init(viewModel: SettingsViewModel) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    
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
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: animated)
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
    tableView.registerCell(SettingsCell.self)
    
    view.addSubview(tableView)
    
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
    
    // set up the data Soruce
    dataSource = RxTableViewSectionedReloadDataSource<SettingsViewModel.Section>(
      configureCell: { (dataSource, tableView, index, _) in
        let cell = tableView.dequeueCell(ofType: SettingsCell.self, for: index)
        switch dataSource[index] {
        case let .build(_, title, build):
          cell.title.on(.next(title))
          cell.subtitle.on(.next(build))
        case let .version(_, title, version):
          cell.title.on(.next(title))
          cell.subtitle.on(.next(version))
        case let .license(_, title):
          cell.title.on(.next(title))
          cell.accessoryType = .disclosureIndicator
        case let .report(_, title):
          cell.title.on(.next(title))
        case let .featureRequest(_, title):
          cell.title.on(.next(title))
        }
        return cell
      }
    )
    
    dataSource.titleForHeaderInSection = { dataSource, index in
      return dataSource[index].title
    }
    
    // only use this for mail calls
    tableView.rx.modelSelected(SettingsViewModel.SectionItem.self)
      .asObservable()
      .subscribe(onNext: { [weak self] item in
        guard let this = self else { return }
        // check
        switch item {
        case .report:
          if !MFMailComposeViewController.canSendMail() {
            this.viewModel.canSendMail.on(.next(()))
          } else {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = this
            composeVC.setToRecipients(["johnny.nguyen39@stclairconnect.ca"])
            composeVC.setCcRecipients(["allan.lin15@stclairconnect.ca"])
            composeVC.setSubject("FreshPlan - Bug Report")
            
            this.present(composeVC, animated: true, completion: nil)
          }
        case .featureRequest:
          if !MFMailComposeViewController.canSendMail() {
            this.viewModel.canSendMail.on(.next(()))
          } else {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = this
            composeVC.setToRecipients(["johnny.nguyen39@stclairconnect.ca"])
            composeVC.setCcRecipients(["allan.lin15@stclairconnect.ca"])
            composeVC.setSubject("FreshPlan - Bug Report")
            
            this.present(composeVC, animated: true, completion: nil)
          }
        case .license:
          let url = URL(string: UIApplicationOpenSettingsURLString)
          if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
          }
        default:
          return
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.canSendMail
      .subscribe(onNext: {
        let message = MDCSnackbarMessage(text: "Can't open mail!")
        MDCSnackbarManager.show(message)
      })
      .disposed(by: disposeBag)
    
    viewModel.settings
      .asObservable()
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
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

extension SettingsViewController: MFMailComposeViewControllerDelegate {
  public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    // let's check our result
    if result == .sent {
      let message = MDCSnackbarMessage(text: "Successfully sent email message to the developers!")
      MDCSnackbarManager.show(message)
    } else if result == .failed || result == .cancelled {
      let message = MDCSnackbarMessage(text: "Could not send mail! Are you connected to the internet?")
      MDCSnackbarManager.show(message)
    }
    
    controller.dismiss(animated: true, completion: nil)
  }
}
