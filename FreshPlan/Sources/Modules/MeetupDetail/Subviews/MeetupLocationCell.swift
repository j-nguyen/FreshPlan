//
//  MeetupLocationCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-21.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxOptional

public final class MeetupLocationCell: UITableViewCell {
  // MARK: PublishSubjects
  public var latitude: PublishSubject<Double> = PublishSubject()
  public var longitude: PublishSubject<Double> = PublishSubject()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepareView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func prepareView() {
    
  }
}
