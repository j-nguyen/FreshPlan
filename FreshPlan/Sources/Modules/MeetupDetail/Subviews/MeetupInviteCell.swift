//
//  MeetupInviteCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-21.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import MaterialComponents

public final class MeetupInviteCell: UITableViewCell {
  // MARK: Subject
  public var displayName: PublishSubject<String> = PublishSubject()
  public var email: PublishSubject<String> = PublishSubject()
  public var accepted: PublishSubject<Bool> = PublishSubject()
  
  // MARK: Views
  private var displayNameLabel: UILabel!
  private var emailLabel: UILabel!
  private var acceptedImageView: UIImageView!
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
    prepareDisplayNameLabel()
    prepareEmailLabel()
    prepareAcceptedImageView()
    prepareInkView()
  }
  
  private func prepareDisplayNameLabel() {
    displayNameLabel = UILabel()
    displayNameLabel.font = MDCTypography.body2Font()
    
    contentView.addSubview(displayNameLabel)
    
    displayNameLabel.snp.makeConstraints { make in
      make.left.equalTo(contentView).offset(5)
      make.top.equalTo(contentView).offset(5)
    }
    
    displayName
      .asObservable()
      .bind(to: displayNameLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func prepareEmailLabel() {
    emailLabel = UILabel()
    emailLabel.font = MDCTypography.body1Font()
    
    contentView.addSubview(emailLabel)
    
    emailLabel.snp.makeConstraints { make in
      make.left.equalTo(contentView).offset(5)
      make.top.equalTo(displayNameLabel.snp.bottom).offset(5)
    }
    
    email
      .asObservable()
      .bind(to: emailLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func prepareAcceptedImageView() {
    acceptedImageView = UIImageView()
    acceptedImageView.contentMode = .scaleAspectFit
    acceptedImageView.tintColor = MDCPalette.green.tint400
    
    contentView.addSubview(acceptedImageView)
    
    acceptedImageView.snp.makeConstraints { make in
      make.right.equalTo(contentView).offset(-10)
      make.centerY.equalTo(contentView)
    }
    
    let sharedAccepted = accepted.asObservable().share()
    
    sharedAccepted
      .filter { $0 }
      .map { _ -> UIImage? in return UIImage(named: "ic_thumb_up")?.withRenderingMode(.alwaysTemplate) }
      .bind(to: acceptedImageView.rx.image)
      .disposed(by: disposeBag)
    
    sharedAccepted
      .filter { $0 }
      .map { _ -> UIColor in return MDCPalette.green.tint400 }
      .bind(to: acceptedImageView.rx.tintColor)
      .disposed(by: disposeBag)
    
    sharedAccepted
      .filter { !$0 }
      .map { _ -> UIImage? in return UIImage(named: "ic_thumb_down")?.withRenderingMode(.alwaysTemplate) }
      .bind(to: acceptedImageView.rx.image)
      .disposed(by: disposeBag)
    
    sharedAccepted
      .filter { !$0 }
      .map { _ -> UIColor in return MDCPalette.red.tint400 }
      .bind(to: acceptedImageView.rx.tintColor)
      .disposed(by: disposeBag)
  }
  
  private func prepareInkView() {
    inkViewController = MDCInkTouchController(view: self)
    inkViewController.delegate = self
    inkViewController.addInkView()
  }
}

// MARK: InkView
extension MeetupInviteCell: MDCInkTouchControllerDelegate {
  public func inkTouchController(_ inkTouchController: MDCInkTouchController, shouldProcessInkTouchesAtTouchLocation location: CGPoint) -> Bool {
    return true
  }
}
