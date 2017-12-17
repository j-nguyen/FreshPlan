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

public protocol MeetupDetailViewModelProtocol {
  var meetup: Variable<Meetup?> { get }
}

public class MeetupDetailViewModel: MeetupDetailViewModelProtocol {
  private let provider: MoyaProvider<FreshPlan>!
  
  public var meetup: Variable<Meetup?> = Variable(nil)
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private var meetupId: Int
  
  public init(provider: MoyaProvider<FreshPlan>, meetupId: Int) {
    self.provider = provider
    self.meetupId = meetupId
    
    requestMeetup(meetupId: meetupId)
      .bind(to: meetup)
      .disposed(by: disposeBag)
  }
  
  private func requestMeetup(meetupId: Int) -> Observable<Meetup> {
    return provider.rx.request(.getMeetup(meetupId))
      .asObservable()
      .map(Meetup.self, using: JSONDecoder.Decode)
  }
}
