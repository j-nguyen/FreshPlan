//
//  AddMeetupTextFieldCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import MaterialComponents
import SnapKit

public final class AddMeetupTextFieldCell: UITableViewCell {
  //MARK: Subjects
  public var title: PublishSubject<String> = PublishSubject()
  
  //MARK: Views
  private var titleLabel: UILabel!
  private var titleTextField: UITextField!
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepareView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func prepareView() {
    prepareTitleLabel()
    prepareTitleTextField()
  }
  
  private func prepareTitleLabel() {
    titleLabel = UILabel()
    titleLabel.font = MDCTypography.body1Font()
    
    contentView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(contentView).offset(5)
      make.top.equalTo(contentView).offset(5)
    }
  }
  
  private func prepareTitleTextField() {
    
  }
}
