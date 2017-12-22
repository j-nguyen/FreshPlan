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

public final class AddMeetupViewController: UIViewController {
  // MARK: Required
  private var viewModel: AddMeetupViewModelProtocol!
  private var router: AddMeetupRouter!
  
  public convenience init(viewModel: AddMeetupViewModel, router: AddMeetupRouter) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    self.router = router
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
