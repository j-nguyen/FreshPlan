//
//  VerifyViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import RxSwift
import RxOptional
import Moya

public protocol VerifyViewModelProtocol {
	var verificationCode: Variable<String> { get }
	var error: Variable<String> { get }
	
	func bindButton()
	var submitTap: Observable<Void>! { get set }
	var submitSuccess: Variable<Bool> { get }
}

public class VerifyViewModel: VerifyViewModelProtocol {
	private let provider: MoyaProvider<FreshPlan>
	private let email: String
	
	public var error: Variable<String> = Variable("")
	public var verificationCode: Variable<String> = Variable("")
	public var submitSuccess: Variable<Bool> = Variable(false)
	
	public var submitTap: Observable<Void>!
	
	public init(provider: MoyaProvider<FreshPlan>, email: String) {
		self.provider = provider
		self.email = email
	}
	
	public func bindButton() {
		submitTap
			.flatMap { self.requestVerification(email: self.email, code: Int(self.verificationCode.value)!) }
		
	}
	
	private func requestVerification(email: String, code: Int) -> Observable<Any> {
		return self.provider.rx.request(.verify(email, code))
			.asObservable()
			.mapJSON()
	}
}
