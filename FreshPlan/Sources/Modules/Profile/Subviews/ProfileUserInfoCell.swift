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
    prepareLineView()
  }
  
  private func prepareLineView() {
    lineView = UIView()
    lineView.backgroundColor = UIColor(red: 224.0 / 255.0, green: 224.0 / 255.0, blue: 224.0 / 255.0, alpha: 224.0 / 255.0)
      
    contentView.addSubview(lineView)
    
    lineView.snp.makeConstraints { make in
      make.top.equalTo(contentView.snp.bottom)
      make.height.equalTo(1)
      make.width.equalTo(contentView)
    }
    
  }
}

//: MARK - MDCInkTouchControllerDelegate
extension ProfileUserInfoCell: MDCInkTouchControllerDelegate {
	public func inkTouchController(_ inkTouchController: MDCInkTouchController, shouldProcessInkTouchesAtTouchLocation location: CGPoint) -> Bool {
		return true
	}
}
