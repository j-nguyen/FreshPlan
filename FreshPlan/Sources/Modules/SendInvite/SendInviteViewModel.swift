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

public protocol SendInviteViewModelProtocol {
  
}

public class SendInviteViewModel: SendInviteViewModelProtocol {
  private let provider: MoyaProvider<FreshPlan>
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
  }
}
