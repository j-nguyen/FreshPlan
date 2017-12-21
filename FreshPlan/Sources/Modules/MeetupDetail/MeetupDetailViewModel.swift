//
//  MeetupDetailViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-17.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxOptional
import Moya

public protocol MeetupDetailViewModelProtocol {
  var title: Variable<String> { get }
  var section: Variable<[MeetupDetailViewModel.Section]> { get }
}

public class MeetupDetailViewModel: MeetupDetailViewModelProtocol {
  private let provider: MoyaProvider<FreshPlan>!
  
  public var title: Variable<String> = Variable("")
  public var section: Variable<[MeetupDetailViewModel.Section]> = Variable([])
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private var meetupId: Int
  
  public init(provider: MoyaProvider<FreshPlan>, meetupId: Int) {
    self.provider = provider
    self.meetupId = meetupId
    
    let meetup = requestMeetup(meetupId: meetupId)
      .share()
    
    meetup
      .map { $0.title }
      .bind(to: self.title)
      .disposed(by: disposeBag)
    
    //MARK: Table Creation
    
    let title = meetup.map { SectionItem.title(order: 0, startDate: $0.startDate, endDate: $0.endDate) }
    // we're checking the type so we can dislpay accordingly on the SectionItem
    let type = meetup.map { meetup -> SectionItem? in
      // convert to a json data format
      if meetup.metadata.isNotEmpty, let data = meetup.metadata.data(using: .utf8) {
        if meetup.meetupType.type == MeetupType.Options.location.rawValue {
          let metadata = try JSONDecoder().decode(Location.self, from: data)
          return SectionItem.location(order: 1, title: metadata.title, latitude: metadata.latitude, longitude: metadata.longitude)
        } else if meetup.meetupType.type == MeetupType.Options.other.rawValue {
          let metadata = try JSONDecoder().decode(Other.self, from: data)
          return SectionItem.other(order: 1, title: metadata.title, description: metadata.description)
        }
      }
      return nil
    }
    .filterNil()
    
    // now wrap these into a group
    let meetupSection = Observable.from([title, type])
      .asObservable()
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .map { Section.meetup(order: 0, title: "", items: $0) }
    
    //MARK: Invitations
    let invitationSection = meetup
      .map { $0.invitations }
      .map { invitations -> [SectionItem] in
        return invitations.enumerated().map { (index, invite) -> SectionItem in
          return SectionItem.invitations(order: index, inviteeId: invite.invitee.id, invitee: invite.invitee.displayName, accepted: invite.accepted)
        }
      }
      .map { $0.sorted(by: { $0.order < $1.order } )}
      .map { Section.invitations(order: 1, title: "Invited", items: $0) }
    
    // MARK: Table Add
    Observable.from([meetupSection, invitationSection])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .bind(to: section)
      .disposed(by: disposeBag)
  }
  
  private func requestMeetup(meetupId: Int) -> Observable<Meetup> {
    return provider.rx.request(.getMeetup(meetupId))
      .asObservable()
      .map(Meetup.self, using: JSONDecoder.Decode)
  }
}

extension MeetupDetailViewModel {
  public enum Section {
    case meetup(order: Int, title: String, items: [SectionItem])
    case invitations(order: Int, title: String, items: [SectionItem])
  }
  
  public enum SectionItem {
    case title(order: Int, startDate: Date, endDate: Date)
    case location(order: Int, title: String, latitude: Double, longitude: Double)
    case other(order: Int, title: String, description: String)
    case invitations(order: Int, inviteeId: Int, invitee: String, accepted: Bool)
  }
}

extension MeetupDetailViewModel.Section: SectionModelType {
  public typealias Items = MeetupDetailViewModel.SectionItem
  
  public var items: [Items] {
    switch self {
    case let .meetup(_, _, items):
      return items.map { $0 }
    case let .invitations(_, _, items):
      return items.map { $0 }
    }
  }
  
  public var order: Int {
    switch self {
    case let .meetup(order, _, _):
      return order
    case let .invitations(order, _, _):
      return order
    }
  }
  
  public var title: String {
    switch self {
    case let .meetup(_, title, _):
      return title
    case let .invitations(_, title, _):
      return title
    }
  }
  
  public init(original: MeetupDetailViewModel.Section, items: [Items]) {
    switch original {
    case let .invitations(order: order, title: title, _):
      self = .invitations(order: order, title: title, items: items)
    case let .meetup(order, title, _):
      self = .meetup(order: order, title: title, items: items)
    }
  }
}

extension MeetupDetailViewModel.SectionItem: Equatable {
  public var order: Int {
    switch self {
    case .title(let order, _, _):
      return order
    case .location(let order, _, _, _):
      return order
    case .other(let order, _, _):
      return order
    case .invitations(let order, _, _, _):
      return order
    }
  }
  
  public static func ==(lhs: MeetupDetailViewModel.SectionItem, rhs: MeetupDetailViewModel.SectionItem) -> Bool {
    return lhs.order == rhs.order
  }
}
