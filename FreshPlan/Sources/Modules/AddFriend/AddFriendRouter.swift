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
  
    switch route {
    case .friend:
      if let parameters = parameters, let friend = parameters["friend"] as? User {
        context.navigationController?.pushViewController(FriendAssembler.make(friend: friend), animated: true)
      }
    }
  }
}


