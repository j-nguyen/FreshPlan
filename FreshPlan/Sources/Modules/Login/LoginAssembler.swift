//
//  LoginAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-05.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit

public final class LoginAssembler: AssemblerProtocol {
	public static func make() -> UIViewController {
		let viewModel = LoginViewModel()
		let router = LoginRouter()
		return LoginViewController(viewModel: viewModel, router: router)
	}
}
