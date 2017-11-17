//
//  Friend.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation

public struct Friend: Decodable {
	public let id: Int
	public let user: User
	public let friend: User
	public let accepted: Bool
}
