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
    
    let token = Token.getJWT().filter { $0 != -1 }.share()
    
		//: MARK - User Setup
		let user = token
			.flatMap { self.requestUser(userId: $0) }
      .map(User.self, using: JSONDecoder.Decode)
			.share()
		
		let profile = user.map { SectionItem.profile(order: 0, profileURL: $0.profileURL, fullName: "\($0.firstName) \($0.lastName)") }
		let email = user.map { SectionItem.email(order: 1, description: "Email: \($0.email)") }
		let displayName = user.map { SectionItem.displayName(order: 2, name: "Display Name: \($0.displayName)") }
    
    let profileSection = Observable.from([profile, email, displayName])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .map { SectionModel.profile(order: 0, title: "My Profile", items: $0) }
    
    //: MARK - Friends Setup
    let friends = token
      .flatMap { self.requestFriends(userId: $0) }
      .share()
    
    let friendsList = friends.map([Friend].self, using: JSONDecoder.Decode).filter { $0.contains(where: { $0.accepted }) }.ifEmpty(default: [])
    let friendRequests = friends.map([Friend].self, using: JSONDecoder.Decode).filter { $0.contains(where: { !$0.accepted }) }.ifEmpty(default: [])
    
    let friendsSection = friendsList
      .map { friends -> [SectionItem] in
        return friends.map { SectionItem.friend(displayName: $0.friend.displayName) }
      }
      .map { SectionModel.friends(order: 1, title: "My Friends", items: $0) }
    
    let friendRequestsSection = friendRequests
      .map { friends -> [SectionItem] in
        return friends.map { SectionItem.friend(displayName: $0.friend.displayName) }
      }
      .map { SectionModel.friendRequests(order: 2, title: "My Friend Requests", items: $0) }
		
		Observable.from([profileSection, friendsSection, friendRequestsSection])
			.flatMap { $0 }
			.toArray()
			.map { $0.sorted(by: { $0.order < $1.order }) }
			.bind(to: profileItems)
			.disposed(by: disposeBag)
	}
	
  private func requestUser(userId: Int) -> Observable<Response> {
    return provider.rx.request(.user(userId))
			.asObservable()
	}
  
  private func requestFriends(userId: Int) -> Observable<Response> {
    return provider.rx.request(.friends(userId))
      .asObservable()
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
		case friend(displayName: String)
	}
}

//: MARK - AnimatableSectionModelType
extension ProfileViewModel.SectionModel: AnimatableSectionModelType {
  public typealias Identity = String
  
  public var identity: String {
    return title
  }
  
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
    default:
      return 0
		}
	}
}

//: MARK - Equatable
extension ProfileViewModel.SectionItem: Equatable {
	public static func ==(lhs: ProfileViewModel.SectionItem, rhs: ProfileViewModel.SectionItem) -> Bool {
		return lhs.order == rhs.order
	}
}

extension ProfileViewModel.SectionItem: IdentifiableType {
  public typealias Identity = Int
  
  public var identity: Int {
    return order
  }
}
