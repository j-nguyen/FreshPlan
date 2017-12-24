//
//  EditMeetupAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-24.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import Moya
import UIKit

public final class EditMeetupAssembler {
  public static func make() -> UIViewController {
    
  }
  
  private static var provider: MoyaProvider<FreshPlan> {
    return MoyaProvider<FreshPlan>(plugins: [NetworkLoggerPlugin(verbose: true)])
  }
}
