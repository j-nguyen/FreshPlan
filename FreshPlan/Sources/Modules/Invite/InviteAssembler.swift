//
//  InviteAssembler.swift
//  FreshPlan
//
//  Created by Allan Lin on 2017-12-10.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit

public final class InviteAssembler {
    public static func make() -> UIViewController {
        let viewModel = InviteViewModel()
        let router = InviteRouter()
        
        return InviteViewController(viewModel: viewModel, router: router)
    }
}
