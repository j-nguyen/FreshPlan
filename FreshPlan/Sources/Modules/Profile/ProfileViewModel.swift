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

public protocol ProfileViewModelProtocol {
	var friends: Variable<[Friend]> { get }
}

public class ProfileViewModel: ProfileViewModelProtocol {
	private let provider: MoyaProvider<FreshPlan>!
	
	public var friends: Variable<[Friend]> = Variable([])
	
	public init(provider: MoyaProvider<FreshPlan>) {
		self.provider = provider
		
		// set up the friends list in here
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
