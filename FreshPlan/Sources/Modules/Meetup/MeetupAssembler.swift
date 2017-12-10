//
//  MeetupAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-10-13.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit

public final class MeetupAssembler {
	public static func make() -> MeetupController {
		let viewModel = MeetupViewModel()
		let router = MeetupRouter()
		
		return MeetupController(viewModel: viewModel, router: router)
	}
}
