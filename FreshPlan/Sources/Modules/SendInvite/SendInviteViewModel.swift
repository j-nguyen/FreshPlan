//
//  SendInviteViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2018-01-07.
//  Copyright © 2018 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxDataSources

public protocol SendInviteViewModelProtocol {
  
}

public class SendInviteViewModel: SendInviteViewModelProtocol {
  private let provider: MoyaProvider<FreshPlan>
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
  }
}

extension SendInviteViewModel {
  public enum Section {
    case meetups(order: Int, title: String, items: [SectionItem])
    case friends(order: Int, title: String, items: [SectionItem])
  }
  
  public enum SectionItem {
    case meetup(id: Int, title: String)
    case friend(id: Int, displayName: String, email: String, checked: Bool)
  }
}

extension SendInviteViewModel.Section {
  public var order: Int {
    switch self {
    case let .meetups(order, _, _):
      return order
    case let .friends(order, _, _):
      return order
    }
  }
  
  public var title: String {
    switch self {
    case let .meetups(_, title, _):
      return title
    case let .friends(_, title, _):
      return title
    }
  }
  
  public var items: [SendInviteViewModel.SectionItem] {
    switch self {
    case let .meetups(_, _, items):
      return items.map { $0 }
    case let .friends(_, _, items):
      return items.map { $0 }
    }
  }
}

extension SendInviteViewModel.SectionItem {
  public var id: Int {
  switch self {
  case let .meetup(id, _):
    return id
  case let .friend(id, _, _, _):
    return id
    }
  }
}

extension SendInviteViewModel.Section: AnimatableSectionModelType {
  public typealias Identity = Int
  
  public var identity: Int {
    return order
  }
  
  public typealias Item = SendInviteViewModel.SectionItem
  
  public init(original: SendInviteViewModel.Section, items: [Item]) {
    switch original {
    case let .friends(order: order, title: title,  _):
      self = .friends(order: order, title: title, items: items)
    case let .meetups(order, title, _):
      self = .meetups(order: order, title: title, items: items)
    }
  }
}

extension SendInviteViewModel.SectionItem: IdentifiableType {
  public typealias Identity = Int
  
  public var identity: Int {
    return id
  }
}

extension SendInviteViewModel.SectionItem: Equatable {
  public static func ==(lhs: SendInviteViewModel.SectionItem, rhs: SendInviteViewModel.SectionItem) -> Bool {
    return lhs.id == rhs.id
  }
}
