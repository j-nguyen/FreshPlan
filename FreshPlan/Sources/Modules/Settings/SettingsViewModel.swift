//
//  SettingsViewModel.swift
//  
//
//  Created by Johnny Nguyen on 2017-12-28.
//

import Foundation
import RxSwift
import RxDataSources

public protocol SettingsViewModelProtocol {
  var settings: Variable<[SettingsViewModel.Section]> { get }
  var canSendMail: PublishSubject<Void> { get }
}

public class SettingsViewModel: SettingsViewModelProtocol {
  public var settings: Variable<[SettingsViewModel.Section]> = Variable([])
  public var canSendMail: PublishSubject<Void> = PublishSubject()
  
  private let disposeBag = DisposeBag()
  
  public init() {
    setup()
  }
  
  private func setup() {
    // MARK: Feedback
    let version = Observable.just(Bundle.main.releaseVersion)
      .filterNil()
      .map { SectionItem.version(order: 0, title: "Version", version: $0) }
    
    let build = Observable.just(Bundle.main.buildVersion)
      .filterNil()
      .map { SectionItem.build(order: 1, title: "Build Number", build: $0) }

     let about = Observable.from([version, build])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .map { Section.about(order: 0, title: "About", items: $0) }
    
    // MARK: About
    let report = Observable.just("Report a bug").map { SectionItem.report(order: 0, title: $0) }
    let featureRequest = Observable.just("Suggestion & feature request").map { SectionItem.featureRequest(order: 1, title: $0) }
    
    let feedback = Observable.from([report, featureRequest])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .map { Section.feedback(order: 1, title: "Feedback", items: $0) }
    
    Observable.from([about, feedback])
      .flatMap { $0 }
      .toArray()
      .map { $0.sorted(by: { $0.order < $1.order }) }
      .bind(to: settings)
      .disposed(by: disposeBag)
  }
}

extension SettingsViewModel {
  public enum Section {
    case about(order: Int, title: String, items: [SectionItem])
    case feedback(order: Int, title: String, items: [SectionItem])
  }
  
  public enum SectionItem {
    case version(order: Int, title: String, version: String)
    case build(order: Int, title: String, build: String)
    case report(order: Int, title: String)
    case featureRequest(order: Int, title: String)
  }
}

extension SettingsViewModel.Section: SectionModelType {
  public typealias Item = SettingsViewModel.SectionItem
  
  public var order: Int {
    switch self {
    case let .about(order, _, _):
      return order
    case let .feedback(order, _, _):
      return order
    }
  }
  
  public var title: String {
    switch self {
    case let .about(_, title, _):
      return title
    case let .feedback(_, title, _):
      return title
    }
  }
  
  public var items: [Item] {
    switch self {
    case let .about(_, _, items):
      return items.map { $0 }
    case let .feedback(_, _, items):
      return items.map { $0 }
    }
  }
  
  public init(original: SettingsViewModel.Section, items: [Item]) {
    switch original {
    case let .about(order, title, _):
      self = .about(order: order, title: title, items: items)
    case let .feedback(order, title, _):
      self = .feedback(order: order, title: title, items: items)
    }
  }
}

extension SettingsViewModel.Section: Equatable {
  public static func ==(lhs: SettingsViewModel.Section, rhs: SettingsViewModel.Section) -> Bool {
    return lhs.order == rhs.order
  }
}

extension SettingsViewModel.SectionItem: Equatable {
  
  public var order: Int {
    switch self {
    case let .build(order, _, _):
      return order
    case let .featureRequest(order, _):
      return order
    case let .report(order, _):
      return order
    case let .version(order, _, _):
      return order
    }
  }
  
  public var title: String {
    switch self {
    case let .build(_, title, _):
      return title
    case let .featureRequest(_, title):
      return title
    case let .report(_, title):
      return title
    case let .version(_, title, _):
      return title
    }
  }
  
  public static func ==(lhs: SettingsViewModel.SectionItem, rhs: SettingsViewModel.SectionItem) -> Bool {
    return lhs.order == rhs.order
  }
}
