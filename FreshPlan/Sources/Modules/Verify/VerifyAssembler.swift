//
//  VerifyAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit

public final class VerifyAssembler: AssemblerProtocol {
	public static func make() -> UIViewController {
		let viewModel = VerifyViewModel()
		let router = VerifyRouter()
		
		return VerifyViewController(router: router, viewModel: viewModel)
	}
}
