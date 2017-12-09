//
//  EmptyView.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-03.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import RxSwift
import MaterialComponents

/**
 * This set-ups an empty view for the tableview, when nothing is there for it to show
 *
**/
public final class EmptyView: UIView {
  //: MARK - Views
  private var stackView: UIStackView!
  private var searchBarImage: UIImageView!
  private var searchTitleLabel: UILabel!
  private var searchDetailLabel: UILabel!
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public convenience init() {
    self.init(frame: CGRect.zero)
    prepareView()
  }
  
  private func prepareView() {
    prepareStackView()
    prepareSearchBarImage()
    prepareSearchTitleLabel()
    prepareSearchDetailLabel()
  }
  
  private func prepareStackView() {
    stackView = UIStackView()
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fill
    
    addSubview(stackView)
    
    stackView.snp.makeConstraints { make in
      make.edges.equalTo(stackView)
    }
  }
  
  private func prepareSearchBarImage() {
    searchBarImage = UIImageView()
    searchBarImage.contentMode = .scaleAspectFit
    searchBarImage.image = UIImage(named: "ic_search")?.withRenderingMode(.alwaysTemplate)
    searchBarImage.tintColor = .black
    
    stackView.addArrangedSubview(searchBarImage)
    
    searchBarImage.snp.makeConstraints { make in
      make.width.equalTo(75)
      make.height.equalTo(75)
    }
  }
  
  private func prepareSearchTitleLabel() {
    searchTitleLabel = UILabel()
    searchTitleLabel.font = MDCTypography.titleFont()
    searchTitleLabel.text = "No Results"
    
    stackView.addArrangedSubview(searchTitleLabel)
    
    searchTitleLabel.snp.makeConstraints { make in
      make.width.equalTo(100)
    }
  }
  
  private func prepareSearchDetailLabel() {
    searchDetailLabel = UILabel()
    searchDetailLabel.font = MDCTypography.body1Font()
    searchDetailLabel.text = "Search for a friend, by entering their display names."
    
    stackView.addArrangedSubview(searchDetailLabel)
    
    searchDetailLabel.snp.makeConstraints { make in
      make.width.equalTo(100)
    }
  }
}
