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
	public let firstName: String
	public let lastName: String
	public let displayName: String
	public let email: String
	public let profileUrl: String
	public let verified: Bool
	public let createdAt: Date
	public let updatedAt: Date
}
