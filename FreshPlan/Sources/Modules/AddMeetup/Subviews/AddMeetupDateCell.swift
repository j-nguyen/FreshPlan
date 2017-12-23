//
//  AddMeetupDateCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import UIKit
import MaterialComponents

public final class AddMeetupDateCell: UITableViewCell {
  //MARK: - Publish Subject
  public var title: PublishSubject<String> = PublishSubject()
  
  //MARK: - Views
  private var titleLabel: UILabel!
  private var textField: UITextField!
  private var inkViewController: MDCInkTouchController!
  
  private let disposeBag: DisposeBag = DisposeBag()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepareView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func prepareView() {
    selectionStyle = .none
    prepareTitleLabel()
    prepareTextField()
    prepareInkView()
  }
  
  private func prepareTitleLabel() {
    titleLabel = UILabel()
    titleLabel.font = MDCTypography.body1Font()
    
    contentView.addSubview(titleLabel)
    
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(contentView).offset(10)
      make.centerY.equalTo(contentView)
    }
    
    title
      .asObservable()
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func prepareTextField() {
    
  }
  
  private func prepareInkView() {
    inkViewController = MDCInkTouchController()
    inkViewController.delegate = self
    inkViewController.addInkView()
  }
}

// MARK: InkViewController
extension AddMeetupDateCell: MDCInkTouchControllerDelegate {
  public func inkTouchController(_ inkTouchController: MDCInkTouchController, shouldProcessInkTouchesAtTouchLocation location: CGPoint) -> Bool {
    return true
  }
}
