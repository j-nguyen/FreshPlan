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
	var profileItems: Variable<[ProfileViewModel.SectionModel]> { get }
}

public class ProfileViewModel: ProfileViewModelProtocol {
	private let provider: MoyaProvider<FreshPlan>!
	
	private var items: Variable<[SectionItem]> = Variable([])
	public var profileItems: Variable<[ProfileViewModel.SectionModel]> = Variable([])
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	public init(provider: MoyaProvider<FreshPlan>) {
		self.provider = provider
		//: MARK - User Setup
		let user = Token.getJWT()
			.flatMap { self.requestUser(userId: $0) }
      .map(User.self, using: JSONDecoder.Decode)
			.share()
		
		let profile = user.map { SectionItem.profile(order: 0, profileURL: $0.profileURL, fullName: "\($0.firstName) \($0.lastName)") }
		let email = user.map { SectionItem.email(order: 1, description: "Email: \($0.email)") }
		let displayName = user.map { SectionItem.displayName(order: 2, name: "Display Name: \($0.displayName)") }
		
		Observable.from([profile, displayName, email])
			.flatMap { $0 }
			.toArray()
			.map { $0.sorted(by: { $0.order < $1.order }) }
			.map { SectionModel.profile(order: 0, title: "My Profile", items: $0) }
			.toArray()
			.bind(to: profileItems)
			.disposed(by: disposeBag)
	}
	
	private func requestUser(userId: Int) -> Observable<Response> {
		return provider.rx.request(.user(userId))
			.asObservable()
      .filterSuccessfulStatusAndRedirectCodes()
	}
}

//: MARK - Section Models
extension ProfileViewModel {
	public enum SectionModel {
		case profile(order: Int, title: String, items: [SectionItem])
		case friends(order: Int, title: String, items: [SectionItem])
		case friendRequests(order: Int, title: String, items: [SectionItem])
	}
	
	public enum SectionItem {
		case profile(order: Int, profileURL: String, fullName: String)
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
		case let .profile(_, _, items):
			return items.map { $0 }
		case let .friendRequests(_, _, items):
			return items.map { $0 }
		case let .friends(_, _, items):
			return items.map { $0 }
		}
	}
	
	public init(original: ProfileViewModel.SectionModel, items: [Item]) {
		switch original {
		case let .profile(order: order, title: title, items: _):
			self = .profile(order: order, title: title, items: items)
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
		case let .profile(order, _, _):
			return order
		}
	}
	
	public var title: String {
		switch self {
		case let .profile(_, title, _):
			return title
		case let .friendRequests(_, title, _):
			return title
		case let .friends(_, title, _):
			return title
		}
	}
}

//: MARK - Equatable
extension ProfileViewModel.SectionModel: Equatable {
	public static func ==(lhs: ProfileViewModel.SectionModel, rhs: ProfileViewModel.SectionModel) -> Bool {
		return lhs.order == rhs.order
	}
}

//: MARK - SectionItem
extension ProfileViewModel.SectionItem {
	public var order: Int {
		switch self {
		case let .profile(order, _, _):
			return order
		case let .displayName(order, _):
			return order
		case let .email(order, _):
			return order
		case let .friend(order, _):
			return order
		}
	}
}

//: MARK - Equatable
extension ProfileViewModel.SectionItem: Equatable {
	public static func ==(lhs: ProfileViewModel.SectionItem, rhs: ProfileViewModel.SectionItem) -> Bool {
		return lhs.order == rhs.order
	}
}
