//
//  Invite.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation

public struct Invite: Decodable {
  public let id: Int
  public let meetup: Meetup
  public let inviter: User
  public let invitee: User
  public let accepted: Bool
  public let createdAt: Date
  public let updatedAt: Date
}
