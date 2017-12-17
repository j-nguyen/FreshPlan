//
//  MeetupRouter.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-13.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit

public class MeetupRouter {
	public enum Routes: String {
		case meetup
	}
	
	fileprivate enum RouteError: Error {
		case invalidRoute(String)
	}
}

extension MeetupRouter: RouterProtocol {
	public func route(from context: UIViewController, to route: String, parameters: [String : Any]?) throws {
		
		guard let route = Routes(rawValue: route) else { throw RouteError.invalidRoute("Invalid route!") }
		
		switch route {
		case .meetup:
      guard let params = parameters, let meetupId = params["meetupId"] as? Int else { return }
			
      context.navigationController?.pushViewController(MeetupDetailAssembler.make(meetupId: meetupId), animated: true)
		}
	}
}
