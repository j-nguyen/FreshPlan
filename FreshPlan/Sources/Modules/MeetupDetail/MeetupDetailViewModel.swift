//
//  MeetupDetailViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-17.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public protocol MeetupDetailViewModelProtocol {
  
}

public class MeetupDetailViewModel: MeetupDetailViewModelProtocol {
  private let provider: MoyaProvider<FreshPlan>!
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  private var meetupId: Int
  
  public init(provider: MoyaProvider<FreshPlan>, meetupId: Int) {
    self.provider = provider
    self.meetupId = meetupId
  }
}
