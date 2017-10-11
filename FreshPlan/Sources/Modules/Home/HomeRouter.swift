//
//  HomeRouter.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit

public class HomeRouter {
	public enum Routes: String {
		case login
	}
	
	fileprivate enum RouteError: Error {
		case invalidRoute(String)
	}
}

extension HomeRouter: RouterProtocol {
	public func route(from context: UIViewController, to route: String, parameters: [String : Any]?) throws {
		
		guard let route = Routes(rawValue: route) else { throw RouteError.invalidRoute("Invalid route!") }
		
		switch route {
		case .login:
			break
		}
	}
}
