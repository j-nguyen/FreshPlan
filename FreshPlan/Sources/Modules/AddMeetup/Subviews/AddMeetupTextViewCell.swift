//
//  AddMeetupTextViewCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit
import MaterialComponents
import UIKit
import RxCocoa

public final class AddMeetupTextViewCell: UITableViewCell {
  //MARK: Subjects
  public var title: PublishSubject<String> = PublishSubject()
  private var placeholder: Variable<String> = Variable("")
  
  //MARK: Views
  private var textView: UITextView!
  
  //MARK: Events
  public var textValue: ControlProperty<String?> {
    return textView.rx.text
  }
  
  //MARK: DisposeBag
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
    prepareTextView()
  }
  
  private func prepareTextView() {
    textView = UITextView()
    textView.font = MDCTypography.body1Font()
    
    contentView.addSubview(textView)
    
    textView.snp.makeConstraints { make in
      make.edges.equalTo(contentView).inset(5)
    }
    
    // create an initial placetext
    textView.textColor = .lightGray
    
    title.asObservable()
      .bind(to: textView.rx.text)
      .disposed(by: disposeBag)
    
    title.asObservable()
      .bind(to: placeholder)
      .disposed(by: disposeBag)
    
    textView.rx.didBeginEditing
      .subscribe(onNext: { [weak self] in
        guard let this = self else { return }
        if this.textView.textColor == .lightGray {
          this.textView.text = nil
          this.textView.textColor = .black
        }
      })
      .disposed(by: disposeBag)
    
    textView.rx.didEndEditing
      .subscribe(onNext: { [weak self] in
        guard let this = self else { return }
        if this.textView.text.isEmpty {
          this.textView.textColor = .lightGray
          this.textView.text = this.placeholder.value
        }
      })
      .disposed(by: disposeBag)
  }
}
