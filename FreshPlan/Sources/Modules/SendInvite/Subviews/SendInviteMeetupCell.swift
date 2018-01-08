//
//  SendInviteMeetupCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2018-01-07.
//  Copyright © 2018 St Clair College. All rights reserved.
//

import Foundation
import MaterialComponents
import RxSwift
import SnapKit
import RxCocoa
import UIKit
import Moya

public final class SendInviteMeetupCell: UITableViewCell{
  
  // MARK: Publish Subject
  public var placeholder: PublishSubject<String> = PublishSubject()
  
  // MARK: Label
  private var meetupLabel: UILabel!
  
  // MARK: TextField
  private var textField: UITextField!
  
  // MARK: PickerView
  private var meetupPicker: UIPickerView!
  
  // MARK: Tool Bar
  private var doneButton: UIBarButtonItem!
  private var toolBar: UIToolbar!
  
  // MARK: Bag
  private let disposeBag: DisposeBag = DisposeBag()
  
  private var inkViewController: MDCInkTouchController!
  
  // initializer require for tableview cell
  // set the indentifier
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    prepareView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func prepareView() {
    selectionStyle = .none
    prepareMeetupLabel()

  }
  
  private func prepareMeetupLabel() {
    meetupLabel = UILabel()
    meetupLabel.font = MDCTypography.body1Font()
    
    contentView.addSubview(meetupLabel)
  }
  
  private func prepareTextField() {
    textField = UITextField()
    textField.font = MDCTypography.body1Font()
    textField.tintColor = .clear
    textField.textAlignment = .center
    textField.placeholder = "Click to chose Meetup"
    
    contentView.addSubview(textField)
    
    placeholder
    .asObservable()
    .bind(to: textField.rx.text)
  }
  
  private func prepareMeetupPicker() {
    meetupPicker = UIPickerView()
    
  }
  
  private func prepareToolBar() {
    toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.sizeToFit()
    
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
    
    doneButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] in
        guard let this = self else { return }
        this.textField.resignFirstResponder()
      })
      .disposed(by: disposeBag)
    
    
    toolBar.items = [flexibleSpace, doneButton]
    
    textField.inputAccessoryView = toolBar
  }

  private func prepareInkView() {
    inkViewController = MDCInkTouchController(view: self)
    inkViewController.delegate = self
    inkViewController.addInkView()
  }
}

// MARK: InkViewController
extension SendInviteMeetupCell: MDCInkTouchControllerDelegate {
  public func inkTouchController(_ inkTouchController: MDCInkTouchController, shouldProcessInkTouchesAtTouchLocation location: CGPoint) -> Bool {
    return true
  }
}

extension SendInviteMeetupCell: UITextFieldDelegate {
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return false
  }
}
