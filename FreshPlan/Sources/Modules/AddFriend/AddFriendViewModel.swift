//
//  AddFriendViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-03.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import RxSwift
import Moya
import RxDataSources

public protocol AddFriendViewModelProtocol {
  var searchText: Variable<String> { get }
  var friends: Variable<[Friend]> { get }
}

public class AddFriendViewModel: AddFriendViewModelProtocol {
  private var provider: MoyaProvider<FreshPlan>
  
  //: MARK - RxSwift Variables
  public var searchText: Variable<String> = Variable("")
  public var friends: Variable<[Friend]> = Variable([])
  
  //: MARK - DisposeBag
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
    
    searchText
      .asObservable()
      .throttle(0.3, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .flatMapLatest { self.requestFriends(query: $0) }
      .catchErrorJustReturn([])
      .bind(to: friends)
      .disposed(by: disposeBag)
  }
  
  private func requestFriends(query: String) -> Observable<[Friend]> {
    return provider.rx.request(.friendSearch(query))
      .asObservable()
      .filterSuccessfulStatusCodes()
      .map([Friend].self)
  }
}
