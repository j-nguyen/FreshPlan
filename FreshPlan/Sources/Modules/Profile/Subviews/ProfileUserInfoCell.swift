//
//  ProfileUserInfoCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-21.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import MaterialComponents

public final class ProfileUserInfoCell: UITableViewCell {
	
	private var inkTouchController: MDCInkTouchController!
  private var lineView: UIView!
  
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
		// set up the ink here
		selectionStyle = .none
    separatorInset = .zero
		inkTouchController = MDCInkTouchController(view: self)
		inkTouchController.delegate = self
		inkTouchController.addInkView()
  }
}

// MARK:  MDCInkTouchControllerDelegate
extension ProfileUserInfoCell: MDCInkTouchControllerDelegate {
	public func inkTouchController(_ inkTouchController: MDCInkTouchController, shouldProcessInkTouchesAtTouchLocation location: CGPoint) -> Bool {
		return true
	}
}
