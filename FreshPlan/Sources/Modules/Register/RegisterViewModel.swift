//
//  RegisterViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import RxSwift
import Moya

public protocol RegisterViewModelProtocol {
  var displayName: Variable<String> { get }
  var email: Variable<String> { get }
  var password: Variable<String> { get }
  var signUpEnabled: Observable<Bool> { get }
  var error: Variable<String?> { get }
  
  var signUpTap: Observable<Void>! { get set }
  var signUpSuccess: Variable<Bool> { get }
  var signUpUnSuccessful: Variable<Bool> { get }
  func bindButtons()
  
}

public class RegisterViewModel: RegisterViewModelProtocol {
  
  private let provider: MoyaProvider<FreshPlan>
  
  private let disposeBag = DisposeBag()
  
  public var displayName: Variable<String> = Variable("")
  public var email: Variable<String> = Variable("")
  public var password: Variable<String> = Variable("")
  public var error: Variable<String?> = Variable(nil)
  
  public var signUpEnabled: Observable<Bool> {
    return Observable.combineLatest(displayName.asObservable(), email.asObservable(), password.asObservable()) { (displayName, email, password) -> Bool in
      return !displayName.isEmpty && !email.isEmpty && !password.isEmpty
    }
  }
  
  public var signUpTap: Observable<Void>!
  
  public var signUpSuccess: Variable<Bool> = Variable(false)
  
  public var signUpUnSuccessful: Variable<Bool> = Variable(false)
  
  public init(provider: MoyaProvider<FreshPlan>) {
    self.provider = provider
  }
  
  public func bindButtons() {
    let tap = signUpTap
      .flatMap { self.registerRequest(displayName: self.displayName.value, email: self.email.value, password: self.password.value) }
      .share()
    
    tap
      .filter { $0.statusCode >= 200 && $0.statusCode <= 299 }
      .map { $0.statusCode >= 200 && $0.statusCode <= 299 }
      .bind(to: self.signUpSuccess)
      .disposed(by: disposeBag)
    
    tap
      .filter { $0.statusCode > 299 }
      .map(ResponseError.self)
      .map { $0.reason }
      .bind(to: error)
      .disposed(by: disposeBag)
  }
  
  private func registerRequest(displayName: String, email: String, password: String) -> Observable<Response> {
    return self.provider.rx.request(.register(displayName, email, password))
      .asObservable()
  }
}
