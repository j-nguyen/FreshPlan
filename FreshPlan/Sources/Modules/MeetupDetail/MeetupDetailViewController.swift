//
//  MeetupDetailViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-17.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import MaterialComponents

public class MeetupDetailViewController: UIViewController {
  //MARK: UIView
  private var viewModel: MeetupDetailViewModelProtocol!
  private var router: MeetupDetailRouter!
  
  public convenience init(viewModel: MeetupDetailViewModel, router: MeetupDetailRouter) {
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
  
  
}
