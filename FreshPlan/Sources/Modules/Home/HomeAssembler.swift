//
//  HomeAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import Moya

public final class HomeAssembler {
	public static func make() -> UIViewController {
		let viewModel = HomeViewModel()
		let router = HomeRouter()
		
		return HomeViewController(router: router, viewModel: viewModel)
	}
}
