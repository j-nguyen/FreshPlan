//
//  FriendProfileUserCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-09.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

public class FriendProfileCell: UITableViewCell {
  // MARK: PublishSubject
  public var profileUrl: PublishSubject<String> = PublishSubject()
  public var fullName: PublishSubject<String> = PublishSubject()
  
  // MARK: Views
  public var profileImageView: UIImageView!
  public var fullNameLabel: UILabel!
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepareView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func prepareView() {
    selectionStyle = .none
  }
}
