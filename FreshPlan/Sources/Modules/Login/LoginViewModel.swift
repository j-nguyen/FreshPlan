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
	var loginEnabled: Observable<Bool> { get }
	// events
	var loginTap: Variable<Void>! { get set }
	func bindButtons()
}

public class LoginViewModel: LoginViewModelProtocol {
	private let provider: RxMoyaProvider<FreshPlan>
	
	public var loginTap: Variable<Void>!
	
	public var email: Variable<String> = Variable("")
	public var password: Variable<String> = Variable("")
	
	public var loginEnabled: Observable<Bool> {
		return Observable.combineLatest(email.asObservable(), password.asObservable()) { (email, password) -> Bool in
			return !email.isEmpty && !password.isEmpty
		}
	}
	
	public init(provider: RxMoyaProvider<FreshPlan>) {
		self.provider = provider
	}
	
	public func bindButtons() {
		
	}
}
