//
//  SettingsRouter.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-28.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit

public class SettingsRouter {
  public enum Routes: String {
    case tos
  }
  
  public enum RouteError: Error {
    case invalidRoute(String)
  }
}

extension SettingsRouter: RouterProtocol {
  public func route(from context: UIViewController, to route: String, parameters: [String : Any]? = nil) throws {
    guard let route = Routes(rawValue: route) else {
      throw RouteError.invalidRoute("This is an invalid route!")
    }
  
    switch route {
    case .tos:
      break
    }
  }
}
