//
//  MeetupTitleCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-18.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import UIKit
import SnapKit
import MaterialComponents

public final class MeetupTitleCell: UITableViewCell {
  //MARK: PublishSubject
  public var startDate: PublishSubject<Date> = PublishSubject()
  public var endDate: PublishSubject<Date> = PublishSubject()
  
  //MARK: Views
  public var startDateLabel: UILabel!
  public var endDateLabel: UILabel!
  private var inkViewController: MDCInkTouchController!
  
  //MARK: DisposeBag
  public let disposeBag: DisposeBag = DisposeBag()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepareView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func prepareView() {
    selectionStyle = .none
    prepareStartDateLabel()
    prepareEndDateLabel()
  }
  
  private func prepareStartDateLabel() {
    startDateLabel = UILabel()
    startDateLabel.font = MDCTypography.body1Font()
    
    contentView.addSubview(startDateLabel)
    
    startDateLabel.snp.makeConstraints { make in
      make.top.equalTo(contentView.snp.top).offset(5)
      make.centerX.equalTo(contentView)
    }
    
    startDate
      .asObservable()
      .map { date -> String? in
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let dateString = dateFormatter.string(from: date)
        return "Start Date: \(dateString)"
      }
      .bind(to: startDateLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func prepareEndDateLabel() {
    endDateLabel = UILabel()
    endDateLabel.font = MDCTypography.body1Font()
    
    contentView.addSubview(endDateLabel)
    
    endDateLabel.snp.makeConstraints { make in
      make.top.equalTo(startDateLabel.snp.bottom).offset(5)
      make.centerX.equalTo(contentView)
    }
    
    endDate
      .asObservable()
      .map { date -> String? in
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let dateString = dateFormatter.string(from: date)
        return "End Date: \(dateString)"
      }
      .bind(to: endDateLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
