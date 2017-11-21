//
//  Token+.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-21.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import JWTDecode
import MaterialComponents

//: MARK - Token Extension
/// tests if the jwt has been expired
extension Token {
	public static func getJWT() -> Observable<Int> {
		return Observable.just(UserDefaults.standard.string(forKey: "token"))
			.filterNil()
			.map { token in
				guard let jwt = try? decode(jwt: token) else { fatalError() }
				
				if jwt.expired, let window = UIApplication.shared.keyWindow {
					// set up so that the user doesn't get anything returned
					UserDefaults.standard.removeObject(forKey: "token")
					window.rootViewController = LoginAssembler.make()
					let alertController = MDCAlertController(title: "Login Expired", message: "Your login credentials have expired. Please log back in.")
					let action = MDCAlertAction(title:"OK") { (action) in print("OK") }
					alertController.addAction(action)
					return -1
				}
				
				return jwt.body["userId"] as! Int
		}
	}
}
