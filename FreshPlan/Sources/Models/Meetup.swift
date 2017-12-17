//
//  Meetup.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation

public struct Meetup: Decodable {
  public let id: Int
  public let meetupType: MeetupType
  public let user: User
  public let title: String
  public let startDate: Date
  public let endDate: Date
  public let invitations: [Invite]
  public let metadata: String
}
