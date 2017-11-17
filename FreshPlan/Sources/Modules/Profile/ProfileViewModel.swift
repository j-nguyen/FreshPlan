//
//  ProfileViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Moya

public protocol ProfileViewModelProtocol {
	var friends: Variable<[Friend]> { get }
}

public class ProfileViewModel: ProfileViewModelProtocol {
	private let provider: MoyaProvider<FreshPlan>!
	
	public var friends: Variable<[Friend]> = Variable([])
	
	public init(provider: MoyaProvider<FreshPlan>) {
		self.provider = provider
		
		
	}
}
