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
	var verificationCode: Variable<Int?> { get }
	var error: Variable<String> { get }
  var resendSuccess: Variable<Bool> { get }
	
	func bindButton()
	var submitTap: Observable<Void>! { get set }
	var submitSuccess: Variable<Bool> { get }
}

public class VerifyViewModel: VerifyViewModelProtocol {
	private let provider: MoyaProvider<FreshPlan>
	private let email: String
	private let disposeBag = DisposeBag()
	
	public var error: Variable<String> = Variable("")
	public var verificationCode: Variable<Int?> = Variable(nil)
	public var submitSuccess: Variable<Bool> = Variable(false)
  public var resendSuccess: Variable<Bool> = Variable(false)
	
	public var submitTap: Observable<Void>!
	
	public init(provider: MoyaProvider<FreshPlan>, email: String) {
		self.provider = provider
		self.email = email
	}
	
	public func bindButton() {
		
		let response = submitTap
      .flatMap { self.requestVerification(email: self.email, code: self.verificationCode.value!) }
      .share()

		response
			.filter { $0.statusCode == 200 }
			.map { $0.statusCode == 200 }
			.bind(to: submitSuccess)
			.disposed(by: disposeBag)
    
    response
      .filter { $0.statusCode == 201 }
      .map { $0.statusCode == 201 }
      .bind(to: resendSuccess)
      .disposed(by: disposeBag)
		
		response
			.filter { $0.statusCode >= 300 }
      .map(ResponseError.self)
			.map { $0.reason }
			.bind(to: error)
			.disposed(by: disposeBag)
	}
	
	private func requestVerification(email: String, code: Int) -> Observable<Response> {
		return self.provider.rx.request(.verify(email, code))
      .asObservable()
	}
  
  private func resendVerification(email: String) -> Observable<Response> {
    return self.provider.rx.request(.resend(email))
      .asObservable()
  }
}
