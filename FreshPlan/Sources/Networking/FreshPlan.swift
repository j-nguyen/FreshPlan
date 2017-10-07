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
		}
	}
	
	// type of method (POST/GET/PATCH/DELETE)
	public var method: Moya.Method {
		switch self {
		case .login, .register:
			return .post
		}
	}
	
	// our parameters set
	public var parameters: [String : Any]? {
		switch self {
		case let .login(email, password):
			return ["email": email, "password": password]
		case let .register(firstName, lastName, email, password):
			return [
				"firstName": firstName,
				"lastName": lastName,
				"email": email,
				"password": password
			]
		}
	}
	
	// what type of parameter is this? JSON, or URL encoded
	public var parameterEncoding: ParameterEncoding {
		switch self {
		case .login, .register:
			return JSONEncoding.default
		}
	}
	
	// this is used primarily for a request, (file could be added)
	public var task: Task {
		switch self {
		case .login, .register:
			return .request
		}
	}
	
	// used for data
	public var sampleData: Data {
		return "Used for testing".data(using: String.Encoding.utf8)!
	}
	
	public var headers: [String: String]? {
		switch self {
		case .login, .register:
			return ["Content-Type": "application/json"]
		}
	}
}
