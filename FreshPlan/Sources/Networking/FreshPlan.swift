//
//  FreshPlan.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-07.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import Moya

// our endpoints
public enum FreshPlan {
	case login(String, String)
	case register(String, String, String, String?)
	case verify(String, Int)
	case user(Int)
  case friends(Int)
  case friendSearch(String)
  case acceptFriend(Int, Int)
  case resend(String)
  case sendFriendRequest(Int, Int)
  case friendRequests(Int)
  case friendRequest(Int, Int)
  case meetup
  case invitations
  case getMeetup(Int)
  case deleteMeetup(Int)
  case deleteInvitation(Int)
  case addMeetup(String, String, String, String, String, String)
  case editMeetup(Int, String, String, String, String, String, String)
}

extension FreshPlan: TargetType {
	public var baseURL: URL { return URL(string: "https://johnnynguyen.ca/api/v1")! }
	
	// the specified path for each endpoint
	public var path: String {
		switch self {
		case .login:
			return "/auth/login"
		case .register:
			return "/auth/register"
		case .verify:
			return "/auth/verify"
    case .meetup, .addMeetup:
      return "/meetups"
    case .deleteMeetup(let meetupId):
      return "/meetups/\(meetupId)"
		case let .user(userId):
			return "/users/\(userId)"
    case .friends(let userId):
      return "/users/\(userId)/friends"
    case let .sendFriendRequest(userId, _):
      return "/users/\(userId)/friends"
    case .friendSearch:
      return "/users/"
    case let .acceptFriend(userId, friendId):
      return "/users/\(userId)/friends/\(friendId)"
    case .resend:
      return "/auth/resend"
    case .getMeetup(let meetupId), .editMeetup(let meetupId, _, _, _, _, _, _):
      return "/meetups/\(meetupId)"
    case .friendRequests(let userId):
      return "/users/\(userId)/friends/requests"
    case .friendRequest(let userId, let friendId):
      return "/users/\(userId)/friends/\(friendId)/requests"
    case .invitations:
      return "/invites"
    case .deleteInvitation(let inviteId):
      return "/invites/\(inviteId)"
    }
	}
	
	// type of method (POST/GET/PATCH/DELETE)
	public var method: Moya.Method {
		switch self {
		case .login, .register, .verify, .resend, .sendFriendRequest, .addMeetup:
			return .post
		case .user, .friends, .friendSearch, .friendRequests, .friendRequest, .meetup, .getMeetup, .invitations:
			return .get
    case .acceptFriend, .editMeetup:
      return .patch
    case .deleteMeetup, .deleteInvitation:
      return .delete
		}
	}

	// this is used primarily for a request, (file could be added)
	public var task: Task {
		switch self {
		case let .login(email, password):
			return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
		case let .register(displayName, email, password, deviceToken):
      var params: [String: Any] = [
        "displayName": displayName,
        "email": email,
        "password": password
      ]
      if let deviceToken = deviceToken { params["deviceToken"] = deviceToken }
			return .requestParameters(
				parameters: params,
        encoding: JSONEncoding.default
      )
    case let .resend(email):
      return .requestParameters(
        parameters: ["email": email],
        encoding: JSONEncoding.default
      )
		case let .verify(email, code):
			return .requestParameters(parameters: ["email": email, "code": code], encoding: JSONEncoding.default)
    case let .friendSearch(query):
      return .requestParameters(parameters: ["search": query], encoding: URLEncoding.default)
    case .user, .friends, .friendRequests, .friendRequest, .meetup, .getMeetup, .deleteMeetup, .invitations, .deleteInvitation:
			return .requestPlain
    case .acceptFriend:
      return .requestParameters(
        parameters: ["accepted": true],
        encoding: JSONEncoding.default
      )
    case let .sendFriendRequest(_, friendId):
      return .requestParameters(
        parameters: ["friendId": friendId],
        encoding: JSONEncoding.default
      )
    case let .addMeetup(title, desc, type, metadata, startDate, endDate):
      return .requestParameters(
        parameters: [
          "title": title,
          "description": desc,
          "meetup": type,
          "metadata": metadata,
          "startDate": startDate,
          "endDate": endDate
        ],
        encoding: JSONEncoding.default
      )
    case let .editMeetup(_, title, desc, type, metadata, startDate, endDate):
      return .requestParameters(
        parameters: [
          "title": title,
          "description": desc,
          "meetup": type,
          "metadata": metadata,
          "startDate": startDate,
          "endDate": endDate
        ],
        encoding: JSONEncoding.default
      )
		}
	}
	
	// This is used for testing, but we haven't been using it
	public var sampleData: Data {
		return "Used for testing".data(using: String.Encoding.utf8)!
	}
	
	public var headers: [String: String]? {
		switch self {
		case .login, .register, .verify, .resend:
			return ["Content-Type": "application/json"]		case .user, .friends, .acceptFriend, .friendSearch, .sendFriendRequest, .friendRequest, .friendRequests, .meetup, .getMeetup, .deleteMeetup, .addMeetup, .editMeetup, .invitations, .deleteInvitation:
			return ["Content-Type": "application/json", "Authorization": UserDefaults.standard.string(forKey: "token")!]
		}
	}
}
