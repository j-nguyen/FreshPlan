//
//  AddFriendViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-03.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import MaterialComponents

public final class AddFriendViewController: UIViewController {
  //: MARK - ViewModel
  private var viewModel: AddFriendViewModelProtocol!
  
  public convenience init(viewModel: AddFriendViewModel) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
}
