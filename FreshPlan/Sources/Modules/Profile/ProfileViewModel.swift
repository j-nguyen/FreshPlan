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
import UIKit

public protocol ProfileViewModelProtocol {
    
    var profileItems: Variable<[ProfileViewModel.SectionModel]> { get }
    var acceptFriend: PublishSubject<IndexPath> { get }
    var refreshContent: PublishSubject<Void> { get }
    var refreshSuccess: PublishSubject<Bool> { get }
    var acceptedFriendSuccess: Variable<String?> { get }
}

public class ProfileViewModel: ProfileViewModelProtocol {
	private let provider: MoyaProvider<FreshPlan>!

	public var profileItems: Variable<[ProfileViewModel.SectionModel]> = Variable([])
    public var acceptFriend: PublishSubject<IndexPath> = PublishSubject()
    public var acceptedFriendSuccess: Variable<String?> = Variable(nil)
  
    public var refreshContent: PublishSubject<Void> = PublishSubject()
    public var refreshSuccess: PublishSubject<Bool> = PublishSubject()
	
	private let disposeBag: DisposeBag = DisposeBag()
	
	public init(provider: MoyaProvider<FreshPlan>) {
		self.provider = provider
    
    refreshContent
      .asObservable()
      .subscribe(onNext: { [weak self] in
        guard let this = self else { return }
        this.setupFriends()
        this.refreshSuccess.on(.next(true))
      })
      .disposed(by: disposeBag)
    
    setupFriends()
    setupFriendRequest()
	}
  
  private func setupFriends() {
    let token = Token.getJWT().filter { $0 != -1 }.share()
    
    let user = token
      .flatMap { self.requestUser(userId: $0) }
      .map(User.self, using: JSONDecoder.Decode)
      .share()
    
    let profile = user.map { SectionItem.profile(order: 0, profileURL: $0.profileURL, fullName: $0.displayName) }
    let email = user.map { SectionItem.email(order: 1, title: "Email:", description: $0.email) }
    let createdAt = user
      .map { user -> SectionItem in
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = df.string(from: user.createdAt)
        return SectionItem.joined(order: 2, title: "Last Joined:", description: date)
    }
    
    let profileSection = Observable.from([profile, email, createdAt])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .map { SectionModel.profile(order: 0, title: "My Profile", items: $0) }
    
    // MARK: Friends Setup
    let friendsList = token
      .flatMap { self.requestFriends(userId: $0) }
      .map([User].self, using: JSONDecoder.Decode)
      .catchErrorJustReturn([])
    
    let friendRequests = token
      .flatMap { self.requestFriendRequests(userId: $0) }
      .map([Friend].self, using: JSONDecoder.Decode)
      .catchErrorJustReturn([])
      .map { $0.filter { !$0.accepted } }
    
    let friendsSection = friendsList
      .map { friends -> [SectionItem] in
        return friends.map { SectionItem.friend(id: $0.id, displayName: $0.displayName) }
      }
      .map { SectionModel.friends(order: 1, title: "My Friends", items: $0) }
    
    let friendRequestsSection = friendRequests
      .map { friends -> [SectionItem] in
        return friends.map { SectionItem.friend(id: $0.id, displayName: $0.displayName) }
      }
      .map { SectionModel.friendRequests(order: 2, title: "My Friend Requests", items: $0) }
    
    Observable.from([profileSection, friendsSection, friendRequestsSection])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .bind(to: profileItems)
      .disposed(by: disposeBag)
  }
  
  private func setupFriendRequest() {
    acceptFriend
      .asObservable()
      .map { index -> Observable<(IndexPath, Response)> in
        let id = self.profileItems.value[index.section].items[index.row].identity
        if let jwt = Token.decodeJWT, let userId = jwt.body["userId"] as? Int {
          let request = self.requestAcceptFriend(userId: userId, friendId: id)
          return request.map { (index, $0) }
        }
        return Observable.empty()
      }
      .flatMap { $0 }
      .filter { $1.statusCode >= 200 && $1.statusCode <= 299 }
      .map { (index, response) -> String? in
        // because of the way this is handled, we'll have to use a constant, of 1 to get the friends
        //: TODO - This needs to be fixed, but it works fine.
        let item = self.profileItems.value[index.section].items[index.row]
        let friendRequest = self.profileItems.value[index.section].delete(at: index.row)
        let friends = self.profileItems.value[1].add(item: item)
        self.profileItems.value[1] = friends
        self.profileItems.value[index.section] = friendRequest
        
        switch item {
        case .friend(_, let displayName):
          return displayName
        default:
          return nil
        }
      }
      .bind(to: acceptedFriendSuccess)
      .disposed(by: disposeBag)
  }
	
  private func requestUser(userId: Int) -> Observable<Response> {
    return provider.rx.request(.user(userId))
			.asObservable()
	}
  
  private func requestAcceptFriend(userId: Int, friendId: Int) -> Observable<Response> {
    return provider.rx.request(.acceptFriend(userId, friendId))
      .asObservable()
  }
  
  private func requestFriends(userId: Int) -> Observable<Response> {
    return provider.rx.request(.friends(userId))
      .asObservable()
  }
  
  private func requestFriendRequests(userId: Int) -> Observable<Response> {
    return provider.rx.request(.friendRequests(userId))
      .asObservable()
  }
}

// MARK:  Section Models
extension ProfileViewModel {
	public enum SectionModel {
		case profile(order: Int, title: String, items: [SectionItem])
		case friends(order: Int, title: String, items: [SectionItem])
		case friendRequests(order: Int, title: String, items: [SectionItem])
	}
	
	public enum SectionItem {
		case profile(order: Int, profileURL: String, fullName: String)
    case email(order: Int, title: String, description: String)
    case displayName(order: Int, title: String, name: String)
    case joined(order: Int, title: String, description: String)
    case friend(id: Int, displayName: String)
	}
}

// MARK:  AnimatableSectionModelType
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
  
  public func delete(at index: Int) -> ProfileViewModel.SectionModel {
    switch self {
    case let .friendRequests(order, title, items):
      var newItems = items
      newItems.remove(at: index)
      return ProfileViewModel.SectionModel.friendRequests(order: order, title: title, items: newItems)
    case let .friends(order, title, items):
      return ProfileViewModel.SectionModel.friends(order: order, title: title, items: items)
    case let .profile(order, title, items):
      return ProfileViewModel.SectionModel.profile(order: order, title: title, items: items)
    }
  }
  
  public func add(item: ProfileViewModel.SectionItem) -> ProfileViewModel.SectionModel {
    switch self {
    case let .friendRequests(order, title, items):
      return ProfileViewModel.SectionModel.friendRequests(order: order, title: title, items: items)
    case let .friends(order, title, items):
      var newItems = items
      newItems.append(item)
      return ProfileViewModel.SectionModel.friends(order: order, title: title, items: newItems)
    case let .profile(order, title, items):
      return ProfileViewModel.SectionModel.profile(order: order, title: title, items: items)
    }
  }
}

// MARK:  Equatable
extension ProfileViewModel.SectionModel: Equatable {
	public static func ==(lhs: ProfileViewModel.SectionModel, rhs: ProfileViewModel.SectionModel) -> Bool {
		return lhs.order == rhs.order
	}
}

// MARK:  SectionItem
extension ProfileViewModel.SectionItem {
	public var order: Int {
		switch self {
		case let .profile(order, _, _):
			return order
		case let .displayName(order, _, _):
			return order
		case let .email(order, _, _):
			return order
    default:
      return 0
		}
	}
}

// MARK:  Equatable
extension ProfileViewModel.SectionItem: Equatable {
	public static func ==(lhs: ProfileViewModel.SectionItem, rhs: ProfileViewModel.SectionItem) -> Bool {
		return lhs.order == rhs.order
	}
}

extension ProfileViewModel.SectionItem: IdentifiableType {
  public typealias Identity = Int
  
  public var identity: Int {
    switch self {
    case let .friend(id, _):
      return id
    default:
      return 0
    }
  }
}
