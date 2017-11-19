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
		
		// set up the friends list in here
	}
}

//: MARK - Section Models
extension ProfileViewModel {
	public enum SectionModel {
		case email(description: String)
	}
	
	public enum SectionItem {
		case profile(title: String, imageUrl: String, order: Int)
		case friends(title: String, order: Int)
		case friendRequests(title: String, order: Int)
	}
}
