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
}

public class AddFriendViewModel: AddFriendViewModelProtocol {
  private var provider: MoyaProvider<FreshPlan>
  
  public var searchText: Variable<String> = Variable("")
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
    
    
  }
  
  private func requestFriends(query: String) -> Observable<[Friend]> {
    return provider.rx.request(.)
  }
}
