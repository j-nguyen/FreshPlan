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
	case register(String, String, String, String, String)
	case verify(String, Int)
  case resend(String)
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
    case .resend:
      return "/auth/resend"
		}
	}
	
	// type of method (POST/GET/PATCH/DELETE)
	public var method: Moya.Method {
		switch self {
		case .login, .register, .verify, .resend:
			return .post
		}
	}

	// this is used primarily for a request, (file could be added)
	public var task: Task {
		switch self {
		case let .login(email, password):
			return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
		case let .register(firstName, lastName, displayName, email, password):
			return .requestParameters(
				parameters: ["firstName": firstName,
				             "lastName": lastName,
                             "displayName": displayName,
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
		}
	}
}
