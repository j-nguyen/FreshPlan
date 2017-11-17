//
//  Token.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-24.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import JWTDecode

public struct Token: Decodable {
	public let token: String
}

//: MARK - Token Extension
/// tests if the jwt has been expired
extension Token {
	public func isValid() -> Bool {
		let jwt = try? decode(jwt: token)
		return jwt?.expired ?? false
	}
}
