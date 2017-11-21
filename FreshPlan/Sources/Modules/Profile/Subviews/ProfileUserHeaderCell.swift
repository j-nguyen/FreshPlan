//
//  ProfileUserHeaderCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-11-21.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import MaterialComponents

public final class ProfileUserHeaderCell: UITableViewCell {
	//: MARK - Publish Subjects
	public var firstName: PublishSubject<String> = PublishSubject()
	public var lastName: PublishSubject<String> = PublishSubject()
	public var imageUrl: PublishSubject<String> = PublishSubject()
	
	//: MARK - DisposeBag
	private var disposeBag: DisposeBag = DisposeBag()
	
	public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		prepareView()
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	public override func prepareForReuse() {
		super.prepareForReuse()
		disposeBag = DisposeBag()
	}
	
	private func prepareView() {
		
	}
	
	private func prepareCell() {
		selectionStyle = .none
		// prepare the ink here
	}
}
