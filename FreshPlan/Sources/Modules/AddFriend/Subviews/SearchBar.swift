//
//  SearchBar.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-03.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import RxSwift

/**
 * Our custom made search bar
 * We'll customize it here, so that it's much better and more orientated for us.
**/
public final class SearchBar: UISearchBar {
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  public convenience init() {
    self.init(frame: .zero)
    prepareView()
  }
  
  private func prepareView() {
    searchBarStyle = .minimal
    placeholder = "Search"
    
  }
}
