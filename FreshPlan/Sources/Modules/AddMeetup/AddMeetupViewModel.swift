//
//  AddMeetupViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional
import RxDataSources
import Moya

public protocol AddMeetupViewModelProtocol {
  
}

public class AddMeetupViewModel: AddMeetupViewModelProtocol {
  // MARK: Private Instances
  private var type: String
  private var provider: MoyaProvider<FreshPlan>
  
  public init(type: String, provider: MoyaProvider<FreshPlan>) {
    self.type = type
    self.provider = provider
  }
}
