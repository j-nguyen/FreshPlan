//
//  InviteViewModel.swift
//  FreshPlan
//
//  Created by Allan Lin on 2017-12-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxDataSources



public protocol InviteViewModelProtocol {
  var invitations: Variable<[Invitation]> { get }
  var acceptInvitation: PublishSubject<IndexPath> { get }
}

public class InviteViewModel: InviteViewModelProtocol {
  
  public var acceptInvitation: PublishSubject<IndexPath> = PublishSubject()
  
    
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
  
}
