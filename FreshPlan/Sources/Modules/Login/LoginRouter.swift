//
//  LoginRouter.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-05.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit

public class LoginRouter {
	public enum Routes: String {
		case login
		case register
	}
	
	fileprivate enum RouteError: Error {
		case invalidRoute(String)
	}
}

extension LoginRouter: RouterProtocol {
	public func route(from context: UIViewController, to route: String, parameters: [String : Any]? = nil) throws {
		
		guard let route = Routes(rawValue: route) else {
			throw RouteError.invalidRoute("This is an invalid route!")
		}
		
		guard let window = UIApplication.shared.keyWindow else { return }
		
		switch route {
		case .login:
			window.rootViewController = LoginAssembler.make()
			break
		case .register:
			break
		}
	}
}

