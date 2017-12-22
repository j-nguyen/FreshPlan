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
  var typeHidden: Variable<String> { get }
}

public class AddMeetupViewModel: AddMeetupViewModelProtocol {
  // MARK: Private Instances
  private var type: String
  private var provider: MoyaProvider<FreshPlan>
  
  public var typeHidden: Variable<String> = Variable("")
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init(type: String, provider: MoyaProvider<FreshPlan>) {
    self.type = type
    self.provider = provider
    
    // conform the type right in
    let typeObservable = Observable.just(type).share()
      
    typeObservable
      .bind(to: typeHidden)
      .disposed(by: disposeBag)
  }
}

extension AddMeetupViewModel {
  public struct Section {
    public var header: String
    public var items: [SectionItem]
  }
  
  public enum SectionItem {
    case name(order: Int, title: String)
  }
}

//MARK: SectionModelType - RxDataSources
extension AddMeetupViewModel.Section: SectionModelType {
  public typealias Item = AddMeetupViewModel.SectionItem
  
  public init(original: AddMeetupViewModel.Section, items: [Item]) {
    self = original
    self.items = items
  }
}

//MARK: SectionItem
extension AddMeetupViewModel.SectionItem {
  public var order: Int {
    switch self {
    case .name(let order, _):
      return order
    }
  }
}
