//
//  FriendViewController.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-08.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import UIKit
import MaterialComponents
import RxSwift

public class FriendViewController: UIViewController {
  // MARK: ViewModel, Router
  private var viewModel: FriendViewModelProtocol!
  
  // MARK: AppBar
  private let appBar: MDCAppBar = MDCAppBar()
  private var backButton: UIBarButtonItem!
  
  // MARK: Views
  private var scrollView: UIScrollView!
  private var titleLabel: UILabel!
  private var titleImageView: UIImageView!
  
  // MARK: StackViews
  private var stackView: UIStackView!
  private var titleStackView: UIStackView!
  
  // MARK: DisposeBag
  private let disposeBag: DisposeBag = DisposeBag()
  
  public convenience init(viewModel: FriendViewModel) {
    self.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
    
    addChildViewController(appBar.headerViewController)
  }
  
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override var childViewControllerForStatusBarStyle: UIViewController? {
    return appBar.headerViewController
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    prepareView()
  }
  
  private func prepareView() {
    prepareScrollView()
    prepareStackView()
    prepareTitleStackView()
    prepareTitleImageLabel()
    prepareTitleLabel()
    prepareNavigationBar()
    prepareNavigationBackButton()
    appBar.addSubviewsToParent()
  }
  
  private func prepareTitleLabel() {
    titleLabel = UILabel()
    titleLabel.textColor = .black
    titleLabel.font = MDCTypography.body1Font()
    
    titleStackView.addArrangedSubview(titleLabel)
    
    viewModel.friend
      .asObservable()
      .map { "\($0.firstName) \($0.lastName)" }
      .bind(to: titleLabel.rx.text)
      .disposed(by: disposeBag)
  }
  
  private func prepareTitleImageLabel() {
    titleImageView = UIImageView()
    titleImageView.contentMode = .scaleAspectFit
    titleImageView.layer.cornerRadius = 25
    
    titleStackView.addArrangedSubview(titleImageView)
    
    titleImageView.snp.makeConstraints { make in
      make.width.equalTo(50)
      make.height.equalTo(50)
    }
    
    viewModel.friend
      .asObservable()
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .map { $0.profileURL }
      .map { urlString -> UIImage? in
        let cache = CacheStore()
        if let image = cache.getImage(key: urlString as NSString) {
          return image
        } else {
          let url = URL(string: urlString)!
          let data = try? Data(contentsOf: url)
          return UIImage(data: data!)
        }
      }
      .filterNil()
      .observeOn(MainScheduler.instance)
      .bind(to: titleImageView.rx.image)
      .disposed(by: disposeBag)
  }
  
  private func prepareTitleStackView() {
    titleStackView = UIStackView()
    titleStackView.axis = .horizontal
    titleStackView.spacing = 10
    titleStackView.alignment = .center
    
    stackView.addArrangedSubview(titleStackView)
  }
  
  private func prepareStackView() {
    stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fill
    stackView.alignment = .fill
    stackView.spacing = 10
    
    scrollView.addSubview(stackView)
    
    stackView.snp.makeConstraints { $0.edges.equalTo(scrollView) }
  }
  
  private func prepareScrollView() {
    scrollView = UIScrollView()
    scrollView.bounces = true
    scrollView.alwaysBounceHorizontal = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = true
    scrollView.isDirectionalLockEnabled = true
    
    view.addSubview(scrollView)
    
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(view)
      make.top.equalTo(view).offset(76)
    }
  }
  
  private func prepareNavigationBar() {
    appBar.headerViewController.headerView.backgroundColor = MDCPalette.blue.tint700
    appBar.navigationBar.tintColor = UIColor.white
    appBar.headerViewController.headerView.maximumHeight = 76.0
    appBar.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: UIColor.white ]
    
    scrollView.delegate = appBar.headerViewController
    
    viewModel.friend
      .asObservable()
      .map { $0.displayName }
      .bind(to: navigationItem.rx.title)
      .disposed(by: disposeBag)
    
    appBar.navigationBar.observe(navigationItem)
  }
  
  private func prepareNavigationBackButton() {
    backButton = UIBarButtonItem(
      image: UIImage(named: "ic_arrow_back")?.withRenderingMode(.alwaysTemplate),
      style: .plain,
      target: nil,
      action: nil
    )
    
    backButton.rx.tap
      .asObservable()
      .subscribe(onNext: { [weak self] in
        guard let this = self else { return }
        this.navigationController?.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
    navigationItem.leftBarButtonItem = backButton
  }
  
  deinit {
    appBar.navigationBar.unobserveNavigationItem()
  }
}
