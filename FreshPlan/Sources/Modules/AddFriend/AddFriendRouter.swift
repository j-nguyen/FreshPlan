//
//  ProfileRouter.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit

public class AddFriendRouter {
  public enum Routes: String {
    case friend
  }
  
  fileprivate enum RouteError: Error {
    case invalidRoute(String)
  }
}

extension AddFriendRouter: RouterProtocol {
  public func route(from context: UIViewController, to route: String, parameters: [String : Any]? = nil) throws {
    
    guard let route = Routes(rawValue: route) else {
      throw RouteError.invalidRoute("This is an invalid route!")
    }
    
    guard let window = UIApplication.shared.keyWindow else { return }
    
    switch route {
    case .friend:
      break
//      window.rootViewController?.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
    }
  }
}


