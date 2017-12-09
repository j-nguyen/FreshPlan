//
//  FriendAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-09.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import Moya

public final class FriendAssembler {
  public static func make(friend: Friend) -> FriendViewController {
    let viewModel = FriendViewModel(provider, friend: friend)
    
    return FriendViewController(viewModel: viewModel)
  }
  
  private static var provider: MoyaProvider<FreshPlan> {
    return MoyaProvider<FreshPlan>(plugins: [NetworkLoggerPlugin(verbose: true)])
  }
}
