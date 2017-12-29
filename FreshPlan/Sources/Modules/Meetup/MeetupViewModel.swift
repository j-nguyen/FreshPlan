//
//  MeetupViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-13.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import RxSwift
import RxDataSources
import Moya

public protocol MeetupViewModelProtocol {
  var meetups: Variable<[MeetupViewModel.Section]> { get }
  var refreshContent: PublishSubject<Void> { get }
  var refreshSuccess: PublishSubject<Void> { get }
  var itemDeleted: Observable<IndexPath>! { get set }
  var authCheck: PublishSubject<Bool> { get }
  
  func bindButtons()
}

public class MeetupViewModel: MeetupViewModelProtocol {
  //MARK: Provider
  private let provider: MoyaProvider<FreshPlan>!
  
  //MARK: Variables
  public var meetups: Variable<[Section]> = Variable([])
  public var refreshContent: PublishSubject<Void> = PublishSubject()
  public var refreshSuccess: PublishSubject<Void> = PublishSubject()
  public var authCheck: PublishSubject<Bool> = PublishSubject()
  
  //MARK: Observables
  public var itemDeleted: Observable<IndexPath>!
  
  //MARK: DisposeBag
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
    
    refreshContent
      .asObservable()
      .flatMap { self.requestMeetups() }
      .map { $0.sorted(by: { $0.id < $1.id }) }
      .map { [Section(header: "", items: $0)] }
      .do(onNext: { [weak self] meetup in
        self?.refreshSuccess.on(.next(()))
      })
      .bind(to: meetups)
      .disposed(by: disposeBag)
    
    self.requestMeetups()
      .map { $0.sorted(by: { $0.id < $1.id }) }
      .map { [Section(header: "", items: $0)] }
      .bind(to: meetups)
      .disposed(by: disposeBag)
  }
  
  public func bindButtons() {
    itemDeleted
      .asObservable()
      .map { [weak self] index -> Meetup? in
        guard let this = self, index.section < this.meetups.value.count, index.row < this.meetups.value[index.section].items.count else { return nil }
        if let token = Token.decodeJWT, let userId = token.body["userId"] as? Int {
          if userId == this.meetups.value[index.section].items[index.row].user.id {
            return this.meetups.value[index.section].items.remove(at: index.row)
          }
          this.authCheck.on(.next(false))
          return nil
        }
        this.authCheck.on(.next(false))
        return nil
      }
      .filterNil()
      .flatMapLatest { self.deleteMeetup(meetupId: $0.id) }
      .subscribe(onNext: { [weak self] _ in
        guard let this = self else { return }
        this.authCheck.on(.next(true))
      })
      .disposed(by: disposeBag)
  }
  
  private func requestMeetups() -> Observable<[Meetup]> {
    return provider.rx.request(.meetup)
      .asObservable()
      .map([Meetup].self, using: JSONDecoder.Decode)
      .catchErrorJustReturn([])
  }
  
  private func deleteMeetup(meetupId id: Int) -> Observable<Response> {
    return provider.rx.request(.deleteMeetup(id))
      .asObservable()
  }
}

extension MeetupViewModel {
  public struct Section {
    public var header: String
    public var items: [Meetup]
  }
}

extension MeetupViewModel.Section: AnimatableSectionModelType {
  public typealias Item = Meetup
  
  public var identity: String {
    return header
  }
  
  public init(original: MeetupViewModel.Section, items: [Item]) {
    self = original
    self.items = items
  }
}
