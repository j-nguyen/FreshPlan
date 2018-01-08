//
//  SendInviteFriendCell.swift
//  FreshPlan
//
//  Created by Allan Lin on 2018-01-07.
//  Copyright © 2018 St Clair College. All rights reserved.
//

import Foundation
import MaterialComponents
import RxSwift
import SnapKit

public final class SendInviteFriendCell: UITableViewCell {
  
  //MARK: Publish Subjects
  public var displayName: PublishSubject<String> = PublishSubject()
  public var email: PublishSubject<String> = PublishSubject()
  public var checked: PublishSubject<Bool> = PublishSubject()
  
  //MARK: ImageView
  private var inviterImageView: UIImageView!
  
  //MARK: disposeBag
  public let disposeBag: DisposeBag = DisposeBag()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    prepareView()
    prepareImageView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func prepareView() {
    selectionStyle = .none
    separatorInset = .zero
    
    displayName
      .asObservable()
      .bind(to: textLabel!.rx.text)
      .disposed(by: disposeBag)
    
    email
      .asObservable()
      .bind(to: detailTextLabel!.rx.text)
      .disposed(by: disposeBag)
  }
  
public func prepareImageView() {
    inviterImageView = UIImageView()
    inviterImageView.contentMode = .scaleAspectFit
    inviterImageView.image = UIImage(named: "ic_done")?.withRenderingMode(.alwaysTemplate)
    
    contentView.addSubview(inviterImageView)
    
    inviterImageView.snp.makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.right.equalTo(contentView).offset(30)
    }
  }
  
}

