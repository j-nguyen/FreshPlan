//
//  User.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation

public struct User: Decodable {
	public let id: Int
	public let email: String
	public let verified: Bool
	public let displayName: String
	public let updatedAt: Date
	public let firstName: String
	public let lastName: String
	public let profileURL: String
	public let createdAt: Date
}
