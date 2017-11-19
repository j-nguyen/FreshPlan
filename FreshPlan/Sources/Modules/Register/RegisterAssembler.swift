//
//  RegisterAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import Moya

public final class RegisterAssembler {
	public static func make() -> UIViewController {
        let viewModel = RegisterViewModel(provider: provider)
		let router = RegisterRouter()
<<<<<<< HEAD
        return RegisterViewController(viewModel: viewModel, router: router)
    }
    
    private static var provider: MoyaProvider<FreshPlan> {
        return MoyaProvider<FreshPlan>(plugins: [NetworkLoggerPlugin(verbose: true)])
    }
=======
		
		return RegisterViewController(viewModel: viewModel, router: router)
	}
>>>>>>> e676f729465e15ce32335f76df1b65da704dc30a
}

