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
  var friendDetail: Variable<[FriendViewModel.Section]> { get }
}

public class FriendViewModel: FriendViewModelProtocol {
  private var provider: MoyaProvider<FreshPlan>!
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public var name: Variable<String> = Variable("")
  public var friendDetail: Variable<[FriendViewModel.Section]> = Variable([])
  
  public init(_ provider: MoyaProvider<FreshPlan>, friend: User) {
    self.provider = provider
    
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
