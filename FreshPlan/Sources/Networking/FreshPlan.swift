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
	case register(String, String, String)
	case verify(String, Int)
	case user(Int)
  case friends(Int)
  case friendSearch(String)
  case acceptFriend(Int, Int)
  case resend(String)
  case sendFriendRequest(Int, Int)
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
		}
	}
	
	// type of method (POST/GET/PATCH/DELETE)
	public var method: Moya.Method {
		switch self {
		case .login, .register, .verify, .resend, .sendFriendRequest:
			return .post
		case .user, .friends, .friendSearch:
			return .get
    case .acceptFriend:
      return .patch
		}
	}

	// this is used primarily for a request, (file could be added)
	public var task: Task {
		switch self {
		case let .login(email, password):
			return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
		case let .register(displayName, email, password):
			return .requestParameters(
				parameters: ["displayName": displayName,
				             "email": email,
				             "password": password],
			encoding: JSONEncoding.default)
    case let .resend(email):
      return .requestParameters(
        parameters: ["email": email],
        encoding: JSONEncoding.default
      )
		case let .verify(email, code):
			return .requestParameters(parameters: ["email": email, "code": code], encoding: JSONEncoding.default)
    case let .friendSearch(query):
      return .requestParameters(parameters: ["search": query], encoding: URLEncoding.default)
    case .user, .friends:
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
		}
	}
	
	// This is used for testing, but we haven't been using it
	public var sampleData: Data {
		return "Used for testing".data(using: String.Encoding.utf8)!
	}
	
	public var headers: [String: String]? {
		switch self {
		case .login, .register, .verify, .resend:
			return ["Content-Type": "application/json"]
		case .user, .friends, .acceptFriend, .friendSearch, .sendFriendRequest:
			return ["Content-Type": "application/json", "Authorization": UserDefaults.standard.string(forKey: "token")!]
		}
	}
}
