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
