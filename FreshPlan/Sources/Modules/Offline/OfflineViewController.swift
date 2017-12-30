//
//  OfflineViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-30.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import MaterialComponents

public final class OfflineViewController: UIViewController {
  
  // MARK: AppBar
  private let appBar = MDCAppBar()
  
  // MARK: Views
  private var stackView: UIStackView!
  private var imageView: UIImageView!
  private var titleLabel: UILabel!
  private var descriptionLabel: UILabel!
  
  private let disposeBag = DisposeBag()
  
  public convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    
    addChildViewController(appBar.headerViewController)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar.headerViewController
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    prepareView()
  }
  
  private func prepareView() {
    prepareStackView()
    prepareImageView()
    prepareTitleLabel()
    prepareDescriptionLabel()
    prepareNavigationBar()
    appBar.addSubviewsToParent()
  }
  
  private func prepareStackView() {
    stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 10
    
    view.addSubview(stackView)
    
    stackView.snp.makeConstraints { make in
      make.center.equalTo(view)
    }
  }
  
  private func prepareImageView() {
    imageView = UIImageView()
    imageView.image = UIImage(named: "ic_wifi")?.withRenderingMode(.alwaysTemplate)
    imageView.tintColor = .black
    
    stackView.addArrangedSubview(imageView)
    
    imageView.snp.makeConstraints { make in
      make.width.equalTo(50)
      make.height.equalTo(50)
    }
  }
  
  private func prepareTitleLabel() {
    titleLabel = UILabel()
    titleLabel.font = MDCTypography.body2Font()
    titleLabel.text = "No Internet Connection!"
    
    stackView.addArrangedSubview(titleLabel)
    
//    titleLabel.snp.makeConstraints { make in
//      make.width.equalTo(150)
//    }
  }
  
  private func prepareDescriptionLabel() {
    descriptionLabel = UILabel()
    descriptionLabel.font = MDCTypography.body1Font()
    descriptionLabel.text = "You appeared to be offline! You need to be online to use FreshPlan"
    descriptionLabel.numberOfLines = 2
    descriptionLabel.textAlignment = .center
    
    stackView.addArrangedSubview(descriptionLabel)
    
    descriptionLabel.snp.makeConstraints { make in
      make.width.equalTo(250)
    }
  }
  
  private func prepareNavigationBar() {
    appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
    appBar.navigationBar.tintColor = UIColor.white
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    
    Observable.just("No Internet Connection!")
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    appBar.navigationBar.observe(navigationItem)
  }
}
