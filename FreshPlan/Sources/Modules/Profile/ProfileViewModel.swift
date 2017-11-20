//
//  ProfileViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Moya
import JWTDecode

public protocol ProfileViewModelProtocol {
	
}

public class ProfileViewModel: ProfileViewModelProtocol {
	private let provider: MoyaProvider<FreshPlan>!
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	public init(provider: MoyaProvider<FreshPlan>) {
		self.provider = provider
		
		//: MARK - User Setup
		let user = Observable.just(UserDefaults.standard.string(forKey: "token"))
			.filterNil()
			.map { token -> Int in
				let jwt = try? decode(jwt: token)
				guard let userId = jwt?.body["userId"] as? Int else { fatalError() }
				return userId
			}
			.flatMap { self.requestUser(userId: $0) }
			.map { try? JSONDecoder().decode(User.self, from: $0) }
			.filterNil()
		
		let email = user.map { SectionItem.email(order: 0, description: $0.email) }
		let displayName = user.map { SectionItem.displayName(order: 1, name: $0.displayName) }
		
		let userInfo = Observable.from([email, displayName])
			.flatMap { $0 }
			.toArray()
		
		user
			.map { SectionModel.profile(order: 0, title: "\($0.firstName) \($0.lastName)", imageUrl: $0.profileUrl, items: userInfo)}
		
	}
	
	private func requestUser(userId: Int) -> Observable<Data> {
		return provider.rx.request(.user(userId))
			.asObservable()
			.map { $0.data }
	}
}

//: MARK - Section Models
extension ProfileViewModel {
	public enum SectionModel {
		case profile(order: Int, title: String, imageUrl: String, items: [SectionItem])
		case friends(order: Int, title: String, items: [SectionItem])
		case friendRequests(order: Int, title: String, items: [SectionItem])
	}
	
	public enum SectionItem {
		case email(order: Int, description: String)
		case displayName(order: Int, name: String)
		case friend(order: Int, displayName: String)
	}
}

//: MARK - SectionModelType
extension ProfileViewModel.SectionModel: SectionModelType {
	public typealias Item = ProfileViewModel.SectionItem
	
	public var items: [ProfileViewModel.SectionItem] {
		switch self {
		case let .profile(_, _, _, items):
			return items.map { $0 }
		case let .friendRequests(_, _, items):
			return items.map { $0 }
		case let .friends(_, _, items):
			return items.map { $0 }
		}
	}
	
	public init(original: ProfileViewModel.SectionModel, items: [Item]) {
		switch original {
		case let .profile(order: order, title: title, imageUrl: imageUrl, items: _):
			self = .profile(order: order, title: title, imageUrl: imageUrl, items: items)
		case let .friends(order: order, title: title, items: _):
			self = .friends(order: order, title: title, items: items)
		case let .friendRequests(order: order, title: title, items: _):
			self = .friendRequests(order: order, title: title, items: items)
		}
	}
	
	public var order: Int {
		switch self {
		case let .friendRequests(order, _, _):
			return order
		case let .friends(order, _, _):
			return order
		case let .profile(order, _, _, _):
			return order
		}
	}
	
	public var title: String {
		switch self {
		case let .profile(_, title, _, _):
			return title
		case let .friendRequests(_, title, _):
			return title
		case let .friends(_, title, _):
			return title
		}
	}
	
	public var imageUrl: String {
		switch self {
		case let .profile(_, _, imageUrl, _):
			return imageUrl
		default:
			return ""
		}
	}
}

//: MARK - Equatable
extension ProfileViewModel.SectionModel: Equatable {
	public static func ==(lhs: ProfileViewModel.SectionModel, rhs: ProfileViewModel.SectionModel) -> Bool {
		return lhs.order == rhs.order
	}
}
