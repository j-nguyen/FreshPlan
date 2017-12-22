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
  var meetup: Variable<[AddMeetupViewModel.Section]> { get }
}

public class AddMeetupViewModel: AddMeetupViewModelProtocol {
  // MARK: Private Instances
  private var type: String
  private var provider: MoyaProvider<FreshPlan>
  
  public var meetup: Variable<[AddMeetupViewModel.Section]> = Variable([])
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public init(type: String, provider: MoyaProvider<FreshPlan>) {
    self.type = type
    self.provider = provider
    
    // conform the type right in
    let typeObservable = Observable.just(type).share()
    
    // create the ones that we know are already there
    let name = Observable.just("Meetup Name").map { SectionItem.name(order: 0, label: $0) }
    let description = Observable.just("Enter in your description for your meetup name.").map { SectionItem.description(order: 1, label: $0) }
    
    let metadata = typeObservable
      .map { type -> SectionItem in
        if type == MeetupType.Options.location.rawValue {
          return SectionItem.location(order: 2, label: "Location")
        } else {
          return SectionItem.other(order: 3, label: "Additional Information")
        }
      }
    
    // COnform it into the section
    Observable.from([name, description, metadata])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .map { [Section(header: "", items: $0)] }
      .bind(to: meetup)
      .disposed(by: disposeBag)
  }
}

extension AddMeetupViewModel {
  public struct Section {
    public var header: String
    public var items: [SectionItem]
  }
  
  public enum SectionItem {
    case name(order: Int, label: String)
    case description(order: Int, label: String)
    case startDate(order: Int, label: String)
    case endDate(order: Int, label: String)
    case location(order: Int, label: String)
    case other(order: Int, label: String)
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
extension AddMeetupViewModel.SectionItem: Equatable {
  public var order: Int {
    switch self {
    case .name(let order, _):
      return order
    case .description(let order, _):
      return order
    case .startDate(let order, _):
      return order
    case .endDate(let order, _):
      return order
    case .location(let order, _):
      return order
    case .other(let order, _):
      return order
    }
  }
  
  public var label: String {
    switch self {
    case .name(_, let label):
      return label
    case .description(_, let label):
      return label
    case .startDate(_, let label):
      return label
    case .endDate(_, let label):
      return label
    case .location(_, let label):
      return label
    case .other(_, let label):
      return label
    }
  }
  
  public static func ==(lhs: AddMeetupViewModel.SectionItem, rhs: AddMeetupViewModel.SectionItem) -> Bool {
    return lhs.order == rhs.order
  }
}
