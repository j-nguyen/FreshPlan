//
//  LocationAssembler.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit

public final class LocationAssembler {
  public static func make(meetupViewModel: AddMeetupViewModel) -> UIViewController {
    let viewModel = LocationViewModel(meetupViewModel: meetupViewModel)
    
    return UINavigationController(rootViewController: LocationViewController(viewModel: viewModel))
  }
}
