//
//  FriendViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-08.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public protocol FriendViewModelProtocol {
  var friend: Variable<User>! { get }
}

public class FriendViewModel: FriendViewModelProtocol {
  private var provider: MoyaProvider<FreshPlan>!
  
  public var friend: Variable<User>!
  
  public init(_ provider: MoyaProvider<FreshPlan>, friend: User) {
    self.provider = provider
    self.friend = Variable(friend)
  }
}
