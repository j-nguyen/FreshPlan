//
//  LoginViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-05.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import RxSwift
import Moya

public protocol LoginViewModelProtocol {
	var email: Variable<String> { get }
	var password: Variable<String> { get }
	var error: Variable<String> { get }
	var loginEnabled: Observable<Bool> { get }
	// events
	var loginTap: Observable<Void>! { get set }
	var loginSuccess: Variable<Bool> { get }
	var loginUnverified: Variable<Bool> { get }
	func bindButtons()
}

public class LoginViewModel: LoginViewModelProtocol {
	private let provider: MoyaProvider<FreshPlan>
	
	private let disposeBag = DisposeBag()
	
	public var loginTap: Observable<Void>!
	
	public var email: Variable<String> = Variable("")
	public var password: Variable<String> = Variable("")
	public var error: Variable<String> = Variable("")
	
	public var loginEnabled: Observable<Bool> {
		return Observable.combineLatest(email.asObservable(), password.asObservable()) { (email, password) -> Bool in
			return !email.isEmpty && !password.isEmpty
		}
	}
	
	public var loginSuccess: Variable<Bool> = Variable(false)
	public var loginUnverified: Variable<Bool> = Variable(false)
	
	public init(provider: MoyaProvider<FreshPlan>) {
		self.provider = provider
	}
	
	public func bindButtons() {
		// filter out for unverified so we can move the user to verified controller
		let tap = loginTap
			.flatMap { self.loginRequest(email: self.email.value, password: self.password.value) }
		
//		tap
//			.filter { $0.statusCode >= 200 && $0.statusCode <= 299 }
//			.mapJSON()
//			.map { try? JSONDecoder. }
//			.map { json -> Bool in
//				Defaults[.jwt] = json["token"].stringValue
//				return true
//			}
//			.bind(to: self.loginSuccess)
//			.disposed(by: disposeBag)
		
		tap
			.filter { $0.statusCode > 299 }
			.map { $0.data }
			.map { try? JSONDecoder().decode(ResponseError.self, from: $0) }
			.map { $0.value }
			.filterNil()
			.map { $0.reason }
			.bind(to: error)
			.disposed(by: disposeBag)
		
//		tap
//			.filter { $0.statusCode == 403 }
//			.map { $0.statusCode == 403 }
//			.bind(to: self.loginUnverified)
//			.disposed(by: disposeBag)
	
	}
	
	private func loginRequest(email: String, password: String) -> Observable<Response> {
		return self.provider.rx.request(.login(email, password)).asObservable()
	}
}
