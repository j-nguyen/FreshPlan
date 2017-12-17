//
//  MeetupCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-16.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import MaterialComponents
import SnapKit

public final class MeetupCell: UITableViewCell {
  //MARK: PublishSubject
  public var name: PublishSubject<String> = PublishSubject()
  public var startDate: PublishSubject<Date> = PublishSubject()
  public var endDate: PublishSubject<Date> = PublishSubject()
  public var type: PublishSubject<String> = PublishSubject()
  
  //MARK: Views
  public var nameLabel: UILabel!
  public var startDateLabel: UILabel!
  public var endDateLabel: UILabel!
  public var typeImageView: UIImageView!
  
  //MARK: DisposeBag
  private let disposeBag: DisposeBag = DisposeBag()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    prepareView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  private func prepareView() {
    
  }
}
