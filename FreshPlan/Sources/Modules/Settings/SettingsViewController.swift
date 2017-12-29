//
//  SettingsViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-28.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit
import MaterialComponents

public final class SettingsViewController: UIViewController {
  // MARK: Properties
  private var viewModel: SettingsViewModelProtocol!
  private var router: SettingsRouter!
  
  public convenience init(viewModel: SettingsViewModel, router: SettingsRouter) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    self.router = router
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
}
