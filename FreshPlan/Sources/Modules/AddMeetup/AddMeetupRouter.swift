//
//  AddMeetupRouter.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit

public class AddMeetupRouter {
  public enum Routes: String {
    case meetup
  }
  
  fileprivate enum RouteError: Error {
    case invalidRoute(String)
  }
}

extension AddMeetupRouter: RouterProtocol {
  public func route(from context: UIViewController, to route: String, parameters: [String : Any]? = nil) throws {
    
    guard let route = Routes(rawValue: route) else {
      throw RouteError.invalidRoute("This is an invalid route!")
    }
    
    switch route {
    case .meetup:
      break
    }
  }
}

