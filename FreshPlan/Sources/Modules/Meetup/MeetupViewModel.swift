//
//  MeetupViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-13.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import RxSwift
import Moya

public protocol MeetupViewModelProtocol {
  var meetups: Variable<[Meetup]> { get }
}

public class MeetupViewModel: MeetupViewModelProtocol {
  //MARK: Provider
  private let provider: MoyaProvider<FreshPlan>!
  
  //MARK: Variables
  public var meetups: Variable<[Meetup]> = Variable([])
  
  //MARK: DisposeBag
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
  }
}
