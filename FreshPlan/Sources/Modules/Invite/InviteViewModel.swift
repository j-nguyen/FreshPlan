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
  var invitations: Variable<[Invitation]> { get }
  var acceptInvitation: PublishSubject<IndexPath> { get }
  var declineInvitation: PublishSubject<IndexPath> { get }
  
  //func bindButtons()
}

public class InviteViewModel: InviteViewModelProtocol {

  public var acceptInvitation: PublishSubject<IndexPath> = PublishSubject()
  public var declineInvitation: PublishSubject<IndexPath> = PublishSubject()
  
    
    private let provider: MoyaProvider<FreshPlan>!
    public var invitations: Variable<[Invitation]> = Variable([])
  
  // MARK: disposeBag
  private let disposeBag: DisposeBag = DisposeBag()
    
    public init(provider: MoyaProvider<FreshPlan>) {
        self.provider = provider
      
        requestInvitation()
          .bind(to: invitations)
          .disposed(by: disposeBag)
    }
    
    private func requestInvitation() -> Observable<[Invitation]> {
        return provider.rx.request(.invitations)
          .asObservable()
          .map([Invitation].self, using: JSONDecoder.Decode)
          .catchErrorJustReturn([])

    }
  
  private func deleteInvitation(inviteId id: Int) -> Observable<Response> {
    return provider.rx.request(.deleteInvitation(id))
    .asObservable()
  }
}

extension InviteViewModel {
  public struct Section {
    public var header: String
    public var items:[Invitation]
  }
}

// MARK: Identity
extension Invitation: IdentifiableType {
  public typealias Identity = Int
  
  public var identity: Int {
    return id
  }
}

// MARK: Equatable
extension Invitation: Equatable {
  public static func ==(lhs: Invitation, rhs: Invitation) -> Bool {
    return lhs.id == rhs.id
  }
}

extension InviteViewModel.Section: AnimatableSectionModelType {
  public typealias Item = Invitation
  
  public var identity: String {
    return header
  }
  
  public init(original: InviteViewModel.Section, items: [Item]) {
    self = original
    self.items = items
  }
}
