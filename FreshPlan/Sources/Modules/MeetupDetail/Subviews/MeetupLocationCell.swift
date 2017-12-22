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
import CoreLocation
import RxSwift
import RxOptional
import MaterialComponents

public final class MeetupLocationCell: UITableViewCell {
  // MARK: PublishSubjects
  public var title: PublishSubject<String> = PublishSubject()
  public var latitude: PublishSubject<Double> = PublishSubject()
  public var longitude: PublishSubject<Double> = PublishSubject()
  
  // MARK: Variables
  private var placemarkName: Variable<String> = Variable("")
  
  // MARK: - MapViews
  private var mapView: MKMapView!
  private var locationManager: CLLocationManager!
  
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
    prepareLocationManager()
    prepareMapView()
  }
  
  private func prepareLocationManager() {
    locationManager = CLLocationManager()
    locationManager.requestWhenInUseAuthorization()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.startUpdatingLocation()
  }
  
  private func prepareMapView() {
    mapView = MKMapView()
    mapView.delegate = self
    mapView.showsUserLocation = true
    
    contentView.addSubview(mapView)
    
    mapView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
  
    let coords = Observable.zip(title.asObservable(), latitude.asObservable(), longitude.asObservable())
      .share()
    
    coords
      .map { CLLocation(latitude: $0.1, longitude: $0.2) }
      .flatMap { CLGeocoder().rx.reverseGeocodeLocation(location: $0) }
      .map { $0[0].name }
      .filterNil()
      .bind(to: placemarkName)
      .disposed(by: disposeBag)
    
    // we want to get the latest results, so I really only care about the first result, since the variable is going to get
    // me osmething i want
    Observable.combineLatest(coords.asObservable(), placemarkName.asObservable())
      .map { $0.0 }
      .subscribe(onNext: { [weak self] coords in
        guard let this = self else { return }
        let annotation = MeetupAnnotationView(
          title: coords.0,
          locationName: this.placemarkName.value,
          coordinate: CLLocationCoordinate2D(latitude: coords.1, longitude: coords.2)
        )
        this.mapView.addAnnotation(annotation)
      })
      .disposed(by: disposeBag)
  }
}

extension MeetupLocationCell: MKMapViewDelegate, CLLocationManagerDelegate {
  
}
