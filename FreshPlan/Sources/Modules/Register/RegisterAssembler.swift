//
//  RegisterAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit

public final class RegisterAssembler {
	public static func make() -> UIViewController {
		let viewModel = RegisterViewModel()
		let router = RegisterRouter()
		
		return RegisterViewController(router: router, viewModel: viewModel)
	}
}
