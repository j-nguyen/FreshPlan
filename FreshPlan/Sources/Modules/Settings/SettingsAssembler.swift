//
//  SettingsAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-28.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit

public final class SettingsAssembler {
  public static func make() -> UIViewController {
    let viewModel = SettingsViewModel()
    
    return SettingsViewController(viewModel: viewModel)
  }
}
