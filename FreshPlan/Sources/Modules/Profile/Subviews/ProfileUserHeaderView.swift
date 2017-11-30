//
//  ProfileUserFriendHeaderView.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-30.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import MaterialComponents

public class ProfileUserHeaderView: UIView {
  
  //: MARK - PublishSubject
  public var title: PublishSubject<String> = PublishSubject()
  
  //: MARK - Label
  public var titleLabel: UILabel!
  
  //: MARK - DisposeBag
  private var disposeBag: DisposeBag = DisposeBag()
  
  public convenience init() {
    self.init(frame: CGRect.zero)
    prepareView()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func prepareView() {
    backgroundColor = MDCPalette.grey.tint200
    prepareTitleLabel()
  }
  
  private func prepareTitleLabel() {
    titleLabel = UILabel()
    titleLabel.font = MDCTypography.titleFont()
    
    addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(self).inset(10)
      make.centerY.equalTo(self)
    }
    
    title
      .asObservable()
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
