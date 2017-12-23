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
  
  public convenience init(viewModel: LocationViewModel) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func prepareView() {
    
  }
}
