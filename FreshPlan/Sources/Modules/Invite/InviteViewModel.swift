//
//  InviteViewModel.swift
//  FreshPlan
//
//  Created by Allan Lin on 2017-12-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Moya
import RxSwift
import RxDataSources

public protocol InviteViewModelProtocol {
  var invitations: Variable<[InviteViewModel.Section]> { get }
  var acceptInvitation: PublishSubject<IndexPath> { get }
  var declineInvitation: PublishSubject<IndexPath> { get }
  
  //func bindButtons()
}

public class InviteViewModel: InviteViewModelProtocol {
  
  public var acceptInvitation: PublishSubject<IndexPath> = PublishSubject()
  public var declineInvitation: PublishSubject<IndexPath> = PublishSubject()
  
  
  private let provider: MoyaProvider<FreshPlan>!
  public var invitations: Variable<[InviteViewModel.Section]> = Variable([])
  
  // MARK: disposeBag
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
    
    requestInvitation()
      .map { Section(header: "", items: $0) }
      .toArray()
      .bind(to: invitations)
      .disposed(by: disposeBag)
  }
  
  private func requestInvitation() -> Observable<[MeetupInvite]> {
    return provider.rx.request(.invitations)
      .asObservable()
      .map([MeetupInvite].self, using: JSONDecoder.Decode)
      .catchErrorJustReturn([])
    
  }
  
  private func deleteInvitation(inviteId id: Int) -> Observable<Response> {
    return provider.rx.request(.deleteInvitation(id))
      .asObservable()
  }
  
  private func getMeetup(meetUpId id: Int) -> Observable<Meetup> {
    return provider.rx.request(.getMeetup(id))
      .asObservable()
      .map(Meetup.self, using: JSONDecoder.Decode)
  }
}

extension InviteViewModel {
  public struct Section {
    public var header: String
    public var items:[MeetupInvite]
  }
}



// MARK: Identity
extension MeetupInvite: IdentifiableType {
  public typealias Identity = Int
  
  public var identity: Int {
    return id
  }
}

// MARK: Equatable
extension MeetupInvite: Equatable {
  public static func ==(lhs: MeetupInvite, rhs: MeetupInvite) -> Bool {
    return lhs.id == rhs.id
  }
}

extension InviteViewModel.Section: AnimatableSectionModelType {
  public typealias Item = MeetupInvite
  
  public var identity: String {
    return header
  }
  
  public init(original: InviteViewModel.Section, items: [Item]) {
    self = original
    self.items = items
  }
}
