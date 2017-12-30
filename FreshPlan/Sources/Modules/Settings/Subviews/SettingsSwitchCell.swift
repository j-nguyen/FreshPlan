//
//  SettingsSliderCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-30.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import MaterialComponents

public final class SettingsSwitchCell: UITableViewCell {
  // MARK: Subject
  public var enabled: PublishSubject<Bool> = PublishSubject()
  
  // MARK: Views
  private var titleLabel: UILabel!
  private var switchView: UISwitch!
  
  private let disposeBag = DisposeBag()
  
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
