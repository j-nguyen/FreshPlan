//
//  InviteCell.swift
//  FreshPlan
//
//  Created by Allan Lin on 2017-12-17.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import MaterialComponents

public class InviteCell: UITableViewCell {
  
  // MARK: Views
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
  
  // prepare a reusable cell
  public override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  // prepares the views
  private func prepareView() {
    // remove the selection style
    selectionStyle = .none
    prepareInkView()
    
  }
  
  // prepare the inkViewController
  private func prepareInkView() {
    inkViewController = MDCInkTouchController(view: self)
    inkViewController.delegate = self
    inkViewController.addInkView()
  }
}

// MARK:  InkDelegate
extension InviteCell: MDCInkTouchControllerDelegate {
  // determine if ink touch controller should be processing touches
  public func inkTouchController(_ inkTouchController: MDCInkTouchController, shouldProcessInkTouchesAtTouchLocation location: CGPoint) -> Bool {
    return true
  }
}
