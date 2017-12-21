//
//  MeetupLocationCell.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-21.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import RxSwift
import RxOptional
import MaterialComponents

public final class MeetupLocationCell: UITableViewCell {
  // MARK: PublishSubjects
  public var latitude: PublishSubject<Double> = PublishSubject()
  public var longitude: PublishSubject<Double> = PublishSubject()
  
  // MARK: - Views
  private var mapView: MKMapView!
  
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
    prepareMapView()
  }
  
  private func prepareMapView() {
    mapView = MKMapView()
    
    contentView.addSubview(mapView)
    
    mapView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
  }
}
