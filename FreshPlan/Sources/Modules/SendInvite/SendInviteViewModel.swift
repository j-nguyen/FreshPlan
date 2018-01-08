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
import UIKit

public protocol SendInviteViewModelProtocol {
  var invites: Variable<[SendInviteViewModel.Section]> { get }
  var meetup: PublishSubject<Meetup> { get }
  var friends: PublishSubject<[User]> { get }
  
  // set up the invites
  var inviteClicked: PublishSubject<IndexPath> { get }
  var addedInvites: Variable<[Int]> { get }
  var sendInvite: PublishSubject<Void> { get }
  var sendInviteSuccess: PublishSubject<Void> { get }
}

public class SendInviteViewModel: SendInviteViewModelProtocol {
  private let provider: MoyaProvider<FreshPlan>
  
  public var invites: Variable<[SendInviteViewModel.Section]> = Variable([])
  public var addedInvites: Variable<[Int]> = Variable([])
  public var sendInvite: PublishSubject<Void> = PublishSubject()
  public var sendInviteSuccess: PublishSubject<Void> = PublishSubject()
  public var inviteClicked: PublishSubject<IndexPath> = PublishSubject()
  
  public var meetup: PublishSubject<Meetup> = PublishSubject()
  public var friends: PublishSubject<[User]> = PublishSubject()
  
  private let disposeBag = DisposeBag()
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
    // set up the initial
    setup()
    // set up the observables here
    let obsMeetup = meetup.asObservable().share()
    // set up updated
    setupUpdatedMeetup(obsMeetup)
    // send invite
    setupInvites(obsMeetup)
  }
  
  private func setup() {
    let initMeetup = requestMeetup().map { SectionItem.meetup(id: -1, title: "", meetups: $0) }
    let sectionMeetup = initMeetup.map { Section.meetups(order: 0, title: "Meetup", items: [$0]) }
    // set up the initial friends
    let sectionFriends = Observable.just(Section.friends(order: 1, title: "Friends", items: []))
    // Setup the from
    Observable.from([sectionMeetup, sectionFriends])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .bind(to: invites)
      .disposed(by: disposeBag)
    
    print (invites.value)
  }
  
  private func setupUpdatedMeetup(_ meetup: Observable<Meetup>) {
    // if a meetup has been presented, we'll show the new one
    let newMeetup = meetup
      .map { [unowned self] meetup -> Observable<(Meetup, [Meetup])> in
        return self.requestMeetup().map { (meetup, $0) }
      }
      .flatMap { $0 }
      .map { SectionItem.meetup(id: $0.0.id, title: $0.0.title, meetups: $0.1) }
      .map { Section.meetups(order: 0, title: "Meetup", items: [$0]) }
    
    let friends = meetup
      .map { meetup -> Observable<[User]> in
        if let jwt = Token.decodeJWT, let userId = jwt.body["userId"] as? Int {
          let users = meetup.invitations.map { $0.invitee }
          let requests = self.requestUsers(userId: userId)
          return requests.map { reqUsers in
            return reqUsers.filter { filteredUsers in
              return !users.contains(where: { $0.id != filteredUsers.id })
            }
          }
        }
        return Observable.empty()
      }
      .flatMap { $0 }
      .map { users in
        return users.map { user in
          return SectionItem.friend(id: user.id, displayName: user.displayName, email: user.email, checked: false)
        }
      }
      .map { Section.friends(order: 1, title: "Friends", items: $0) }
    
    Observable.from([newMeetup, friends])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .bind(to: invites)
      .disposed(by: disposeBag)
  }
  
  private func setupInvites(_ meetup: Observable<Meetup>) {
    // check for an invite being sent
    let addedInvites = Observable.from(self.addedInvites.value)
    
    sendInvite
      .asObservable()
      .flatMap { meetup }
      .map { meetup -> Observable<(Meetup, Int)> in return addedInvites.map { (meetup, $0) } }
      .flatMap { $0 }
      .flatMap { [unowned self] invite in return self.requestSendInvite(userId: invite.1, meetupId: invite.0.id).catchErrorJustComplete() }
      .subscribe({ [weak self] event in
        guard let this = self else { return }
        switch event {
        case .completed:
          this.sendInviteSuccess.onNext(())
        default:
          return
        }
      })
      .disposed(by: disposeBag)
    
    inviteClicked
      .asObservable()
      .subscribe(onNext: { [weak self] index in
        guard let this = self else { return }
        // fixed it up
        let newChecked = this.invites.value[index.section].check(at: index.row)
        this.invites.value[index.section] = newChecked
      })
      .disposed(by: disposeBag)
  }
  
  private func requestUsers(userId id: Int) -> Observable<[User]> {
    return provider.rx.request(.friends(id))
      .asObservable()
      .map([User].self, using: JSONDecoder.Decode)
      .catchErrorJustReturn([])
  }
  
  private func requestSendInvite(userId: Int, meetupId id: Int) -> Observable<Response> {
    return provider.rx.request(.sendInvite(userId, id))
      .asObservable()
  }
  
  private func requestMeetup() -> Observable<[Meetup]> {
    return provider.rx.request(.meetup)
      .asObservable()
      .map([Meetup].self, using: JSONDecoder.Decode)
      .catchErrorJustReturn([])
  }
}

extension SendInviteViewModel {
  public enum Section {
    case meetups(order: Int, title: String, items: [SectionItem])
    case friends(order: Int, title: String, items: [SectionItem])
  }
  
  public enum SectionItem {
    case meetup(id: Int, title: String, meetups: [Meetup])
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
  
  /**
   Unchecks or checks the mark based on what's given
   */
  public func check(at index: Int) -> SendInviteViewModel.Section {
    switch self {
    case .friends(order, title, _):
      var newItems = items
      switch newItems[index] {
      case let .friend(id, displayName, email, checked):
        newItems[index] = .friend(id: id, displayName: displayName, email: email, checked: !checked)
      default: break
      }
      return SendInviteViewModel.Section.friends(order: order, title: title, items: newItems)
    default: return self
    }
  }
}

extension SendInviteViewModel.SectionItem {
  public var id: Int {
  switch self {
  case let .meetup(id, _, _):
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

extension SendInviteViewModel.Section: Equatable {
  public static func ==(lhs: SendInviteViewModel.Section, rhs: SendInviteViewModel.Section) -> Bool {
    return lhs.identity == rhs.identity
  }
}
