//
//  MeetupDetailViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-17.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import RxDataSources

public protocol MeetupDetailViewModelProtocol {
  var title: Variable<String> { get }
}

public class MeetupDetailViewModel: MeetupDetailViewModelProtocol {
  private let provider: MoyaProvider<FreshPlan>!
  
  public var title: Variable<String> = Variable("")
  
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
  }
  
  private func requestMeetup(meetupId: Int) -> Observable<Meetup> {
    return provider.rx.request(.getMeetup(meetupId))
      .asObservable()
      .map(Meetup.self, using: JSONDecoder.Decode)
  }
}

extension MeetupDetailViewModel {
  public struct Section {
    public var title: String
    public var items: [SectionItem]
  }
  
  public enum SectionItem {
    case title(order: Int, title: String)
    case invitations(order: Int, inviteeId: Int, invitee: String, accepted: Bool)
  }
}

extension MeetupDetailViewModel.Section: SectionModelType {
  public typealias Items = MeetupDetailViewModel.SectionItem
  
  public init(original: MeetupDetailViewModel.Section, items: [Items]) {
    self = original
    self.items = items
  }
}

extension MeetupDetailViewModel.SectionItem: Equatable {
  public var order: Int {
    switch self {
    case .title(let order, _):
      return order
    case .invitations(let order, _, _, _):
      return order
    }
  }
  
  public static func ==(lhs: MeetupDetailViewModel.SectionItem, rhs: MeetupDetailViewModel.SectionItem) -> Bool {
    return lhs.order == rhs.order
  }
}
