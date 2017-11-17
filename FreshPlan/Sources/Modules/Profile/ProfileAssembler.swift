//
//  ProfileAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit

public final class ProfileAssembler {
	public static func make() -> UIViewController {
		let viewModel = ProfileViewModel()
		let router = ProfileRouter()
		
		return ProfileViewController(viewModel: viewModel, router: router)
	}
}

