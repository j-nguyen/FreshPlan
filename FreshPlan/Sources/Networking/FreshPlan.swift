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
	case register(String, String, String, String)
	case verify(String, Int)
	case user(Int)
}

extension FreshPlan: TargetType {
	public var baseURL: URL { return URL(string: "https://fractalpoint.net/api/v1")! }
	
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
			return "/user/\(userId)"
		}
	}
	
	// type of method (POST/GET/PATCH/DELETE)
	public var method: Moya.Method {
		switch self {
		case .login, .register, .verify:
			return .post
		case .user:
			return .get
		}
	}

	// this is used primarily for a request, (file could be added)
	public var task: Task {
		switch self {
		case let .login(email, password):
			return .requestParameters(parameters: ["email": email, "password": password], encoding: JSONEncoding.default)
		case let .register(firstName, lastName, email, password):
			return .requestParameters(
				parameters: ["firstName": firstName,
				             "lastName": lastName,
				             "email": email,
				             "password": password],
			encoding: JSONEncoding.default)
		case let .verify(email, code):
			return .requestParameters(parameters: ["email": email, "code": code], encoding: JSONEncoding.default)
		case let .user(userId):
			return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
		}
	}
	
	// used for data
	public var sampleData: Data {
		return "Used for testing".data(using: String.Encoding.utf8)!
	}
	
	public var headers: [String: String]? {
		switch self {
		case .login, .register, .verify, .user:
			return ["Content-Type": "application/json"]
		}
	}
}
