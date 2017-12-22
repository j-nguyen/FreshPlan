//
//  AddMeetupAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import Moya
import UIKit

public final class AddMeetupAssembler {
  public static func make(type: String) -> UIViewController {
    let viewModel = AddMeetupViewModel(type: type, provider: provider)
    let router = AddMeetupRouter()
    
    return AddMeetupViewController(viewModel: viewModel, router: router)
  }
  
  private static var provider: MoyaProvider<FreshPlan> {
    return MoyaProvider<FreshPlan>(plugins: [NetworkLoggerPlugin(verbose: true)])
  }
}
