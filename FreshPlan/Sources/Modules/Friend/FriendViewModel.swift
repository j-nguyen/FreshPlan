//
//  FriendViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-08.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxDataSources

public protocol FriendViewModelProtocol {
  var name: Variable<String> { get }
  var tapSend: Observable<Void>! { get set }
  var disabledSend: Variable<Bool> { get }
  var sendFriend: Variable<Bool> { get }
  var friendDetail: Variable<[FriendViewModel.Section]> { get }
  
  func bindButtons()
}

public class FriendViewModel: FriendViewModelProtocol {
  private var provider: MoyaProvider<FreshPlan>!
  
  //MARK: Disposeable
  private let disposeBag: DisposeBag = DisposeBag()
  
  //MARK: Variables
  public var name: Variable<String> = Variable("")
  public var friendDetail: Variable<[FriendViewModel.Section]> = Variable([])
  public var disabledSend: Variable<Bool> = Variable(false)
  public var sendFriend: Variable<Bool> = Variable(false)
  
  //MARK: Observables
  public var tapSend: Observable<Void>!
  
  //MARK: Other Variables
  private var friend: User
  
  public init(_ provider: MoyaProvider<FreshPlan>, friend: User) {
    self.provider = provider
    self.friend = friend
    
    let friendVar = Observable.just(friend).share()
    
    friendVar
      .map { $0.displayName }
      .bind(to: name)
      .disposed(by: disposeBag)
    
    let profile = friendVar.map { SectionItem.profileTitle(order: 0, profileURL: $0.profileURL, fullName: "\($0.firstName) \($0.lastName)") }
    let displayName = friendVar.map { SectionItem.info(order: 1, type: "Display Name:", title: $0.displayName) }
    let email = friendVar.map { SectionItem.info(order: 2, type: "Email:", title: $0.email) }
    let createdAt = friendVar
      .map { friend -> SectionItem in
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = df.string(from: friend.createdAt)
        return SectionItem.info(order: 3, type: "Last Joined:", title: date)
      }
    
    Observable.from([profile, displayName, email, createdAt])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .map { Section(title: "", items: $0) }
      .toArray()
      .bind(to: friendDetail)
      .disposed(by: disposeBag)
    
    setupFriendRequest(friend)
  }
  
  private func setupFriendRequest(_ friend: User) {
    let token = Token.getJWT().filter { $0 != -1 }.share()
    
    token
      .flatMap { self.requestFriends(userId: $0) }
      .map { friends -> Bool in
        if let _ = friends.first(where: { $0.id == friend.id }) {
          return true
        }
        return false
      }
      .bind(to: disabledSend)
      .disposed(by: disposeBag)
  }
  
  public func bindButtons() {
    let token = Token.getJWT().filter { $0 != -1 }.share()
    
    tapSend
      .flatMap { _ -> Observable<Int> in return token }
      .flatMap { self.sendFriendRequest(userId: $0, friendId: self.friend.id) }
      .filter { $0.statusCode >= 200 && $0.statusCode <= 299 }
      .map { $0.statusCode >= 200 && $0.statusCode <= 299 }
      .bind(to: self.sendFriend)
      .disposed(by: disposeBag)
  }
  
  private func requestFriends(userId: Int) -> Observable<[Friend]> {
    return provider.rx.request(.friends(userId))
      .asObservable()
      .map([Friend].self, using: JSONDecoder.Decode)
      .catchErrorJustReturn([])
  }
  
  private func sendFriendRequest(userId: Int, friendId: Int) -> Observable<Response> {
    return provider.rx.request(.sendFriendRequest(userId, friendId))
      .asObservable()
      
  }
}

extension FriendViewModel {
  public enum SectionItem {
    case profileTitle(order: Int, profileURL: String, fullName: String)
    case info(order: Int, type: String, title: String)
  }
  
  public struct Section {
    public var title: String
    public var items: [SectionItem]
  }
}

extension FriendViewModel.Section: SectionModelType {
  public typealias Item = FriendViewModel.SectionItem
  
  public init(original: FriendViewModel.Section, items: [Item]) {
    self = original
    self.items = items
  }
}

extension FriendViewModel.SectionItem: Equatable {
  public var order: Int {
    switch self {
    case let .info(order, _, _):
      return order
    case let .profileTitle(order, _, _):
      return order
    }
  }
  
  public static func ==(lhs: FriendViewModel.SectionItem, rhs: FriendViewModel.SectionItem) -> Bool {
    return lhs.order == rhs.order
  }
}
