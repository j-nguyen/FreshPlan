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
    
    var firstName: Variable<String> { get }
    var lastName: Variable<String> { get }
    var displayName: Variable<String> { get }
    var email: Variable<String> { get }
    var password: Variable<String> { get }
    var signUpEnabled: Observable<Bool> { get }
    
    var signUpTap: Observable<Void>! { get set }
    var signUpSuccess: Variable<Bool> { get }
    var signUpUnverified: Variable<Bool> { get }
    func bindButtons()
    
}

public class RegisterViewModel: RegisterViewModelProtocol {
    private let provider: MoyaProvider<FreshPlan>
    
    private let disposeBag = DisposeBag()
    
    public var firstName: Variable<String> = Variable("")
    public var lastName: Variable<String> = Variable("")
    public var displayName: Variable<String> = Variable("")
    public var email: Variable<String> = Variable("")
    public var password: Variable<String> = Variable("")
    

    public var signUpEnabled: Observable<Bool> {
        return Observable.combineLatest(firstName.asObservable(), lastName.asObservable(), displayName.asObservable(), email.asObservable(), password.asObservable()) { (firstName, lastName, displayName, email, password) -> Bool in
            return !firstName.isEmpty && !lastName.isEmpty && !displayName.isEmpty && !email.isEmpty && !password.isEmpty
        }
    }
    
    public var signUpTap: Observable<Void>!
    
    public var signUpSuccess: Variable<Bool> = Variable(false)
    
    public var signUpUnverified: Variable<Bool> = Variable(false)
    
    public init(provider: MoyaProvider<FreshPlan>) {
        self.provider = provider
    }
    
    public func bindButtons() {
        
    }
    
    private func registerRequest(firstName: String, lastName: String, displayName: String, email: String, password: String) -> Observable<Response> {
        return self.provider.rx.request(.register(firstName, lastName, displayName, email, password))
            .asObservable()
    }
    
	
}
