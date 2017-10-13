//
//  VerifyViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import RxSwift
import RxOptional
import SwiftyJSON
import Moya

public protocol VerifyViewModelProtocol {
	var verificationCode: Variable<Int> { get }
	var error: Variable<String> { get }
	
	func bindButton()
	var submitTap: Observable<Void>! { get set }
	var submitSuccess: Variable<Bool> { get }
}

public class VerifyViewModel: VerifyViewModelProtocol {
	private let provider: MoyaProvider<FreshPlan>
	private let email: String
	private let disposeBag = DisposeBag()
	
	public var error: Variable<String> = Variable("")
	public var verificationCode: Variable<Int> = Variable(-1)
	public var submitSuccess: Variable<Bool> = Variable(false)
	
	public var submitTap: Observable<Void>!
	
	public init(provider: MoyaProvider<FreshPlan>, email: String) {
		self.provider = provider
		self.email = email
	}
	
	public func bindButton() {
		
		let response = submitTap
			.flatMap { self.requestVerification(email: self.email, code: self.verificationCode.value) }
			.share()
		
		// TODO: I probably need to fix this type of issue
		response
			.filter { $0.statusCode >= 200 && $0.statusCode <= 299 }
			.map { $0.statusCode >= 200 && $0.statusCode <= 299 }
			.bind(to: submitSuccess)
			.disposed(by: disposeBag)
		
		response
			.filter { $0.statusCode >= 300 }
			.mapJSON()
			.map { JSON($0) }
			.map { $0["reason"].stringValue }
			.bind(to: error)
			.disposed(by: disposeBag)
	}
	
	private func requestVerification(email: String, code: Int) -> Observable<Response> {
		return self.provider.rx.request(.verify(email, code)).asObservable()
	}
}
