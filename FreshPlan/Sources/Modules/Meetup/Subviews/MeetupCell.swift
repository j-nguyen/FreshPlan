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
  private var nameLabel: UILabel!
  private var startDateLabel: UILabel!
  private var endDateLabel: UILabel!
  private var typeImageView: UIImageView!
  private var inkViewController: MDCInkTouchController!
  
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
    prepareNameLabel()
    prepareInkView()
  }
  
  private func prepareNameLabel() {
    nameLabel = UILabel()
    nameLabel.font = MDCTypography.body1Font()
    
    contentView.addSubview(nameLabel)
    
    nameLabel.snp.makeConstraints { make in
      make.left.equalTo(contentView).inset(10)
      make.centerY.equalTo(contentView)
    }
    
    name
      .asObservable()
      .map { text in
        print ("YO: \(text)")
        return text
      }
      .bind(to: nameLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func prepareInkView() {
    inkViewController = MDCInkTouchController(view: self)
    inkViewController.delegate = self
    inkViewController.addInkView()
  }
}

extension MeetupCell: MDCInkTouchControllerDelegate {
  public func inkTouchController(_ inkTouchController: MDCInkTouchController, shouldProcessInkTouchesAtTouchLocation location: CGPoint) -> Bool {
    return true
  }
}
