//
//  AddFriendViewAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-03.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import Moya
import UIKit

public final class AddFriendViewAssembler {
  public static func make() -> AddFriendViewController {
    let viewModel = AddFriendViewModel(provider: provider)
    
    return AddFriendViewController(viewModel: viewModel)
  }
  
  private static var provider: MoyaProvider<FreshPlan> {
    return MoyaProvider<FreshPlan>(plugins: [NetworkLoggerPlugin(verbose: true)])
  }
}
