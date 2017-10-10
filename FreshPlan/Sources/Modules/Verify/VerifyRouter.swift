//
//  VerifyRouter.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit

public class VerifyRouter {
	public enum Routes: String {
		case register
	}
	
	fileprivate enum RouteError: Error {
		case invalidRoute(String)
	}
}

extension VerifyRouter: RouterProtocol {
	public func route(from context: UIViewController, to route: String, parameters: [String : Any]?) throws {
		guard let route = Routes(rawValue: route) else {
			throw RouteError.invalidRoute("This is an invalid route!")
		}
		
		guard let window = UIApplication.shared.keyWindow else { return }
		
		switch route {
		case .register:
			break
		}
	}
}
