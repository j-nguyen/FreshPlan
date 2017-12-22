//
//  MeetupAnnotationView.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-21.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public final class MeetupAnnotationView: NSObject, MKAnnotation {
  public let title: String?
  public let locationName: String
  public let coordinate: CLLocationCoordinate2D
  
  init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.locationName = locationName
    self.coordinate = coordinate
    
    super.init()
  }
}
