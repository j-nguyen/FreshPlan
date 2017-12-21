//
//  MeetupViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-13.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import RxSwift
import Moya

public protocol MeetupViewModelProtocol {
  var meetups: Variable<[Meetup]> { get }
  var refreshContent: PublishSubject<Void> { get }
  var refreshSuccess: PublishSubject<Void> { get }
}

public class MeetupViewModel: MeetupViewModelProtocol {
  //MARK: Provider
  private let provider: MoyaProvider<FreshPlan>!
  
  //MARK: Variables
  public var meetups: Variable<[Meetup]> = Variable([])
  public var refreshContent: PublishSubject<Void> = PublishSubject()
  public var refreshSuccess: PublishSubject<Void> = PublishSubject()
  
  //MARK: DisposeBag
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
    
    refreshContent
      .asObservable()
      .flatMap { self.requestMeetups().map { $0.sorted(by: { $0.startDate < $1.startDate }) } }
      .do(onNext: { [weak self] meetup in
        self?.refreshSuccess.on(.next(()))
      })
      .bind(to: meetups)
      .disposed(by: disposeBag)
    
//    self.requestMeetups()
//      .map { $0.sorted(by: { $0.startDate < $1.startDate }) }
//      .bind(to: meetups)
//      .disposed(by: disposeBag)
  }
  
  private func requestMeetups() -> Observable<[Meetup]> {
    return provider.rx.request(.meetup)
      .asObservable()
      .map([Meetup].self, using: JSONDecoder.Decode)
      .catchErrorJustReturn([])
  }
}
