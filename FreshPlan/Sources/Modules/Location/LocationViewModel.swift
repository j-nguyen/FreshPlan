//
//  LocationViewModel.swift
//  FreshPlan
//
//  Created by Johnny Nguyen on 2017-12-22.
//  Copyright © 2017 St Clair College. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation
import MapKit

public protocol LocationViewModelProtocol {
  var searchText: Variable<String> { get }
  var coordinate: Variable<CLLocationCoordinate2D?> { get }
  var locations: Variable<[MKMapItem]> { get }
  
  var updateMeetup: PublishSubject<String> { get }
}

public class LocationViewModel: LocationViewModelProtocol {
  private let disposeBag: DisposeBag = DisposeBag()
  
  // MARK: Variables
  public var searchText: Variable<String> = Variable("")
  public var coordinate: Variable<CLLocationCoordinate2D?> = Variable(nil)
  public var locations: Variable<[MKMapItem]> = Variable([])
  
  // MARK: Publish Subjects
  public var updateMeetup: PublishSubject<String> = PublishSubject()
  
  private var meetupViewModel: AddMeetupViewModel!
  
  public init(meetupViewModel: AddMeetupViewModel) {
    self.meetupViewModel = meetupViewModel
    
    updateMeetup
      .asObservable()
      .bind(to: meetupViewModel.metadata)
      .disposed(by: disposeBag)
    
    searchText
      .asObservable()
      .filterEmpty()
      .filter { [unowned self] _ in return self.coordinate.value != nil }
      .throttle(0.4, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .map { [unowned self] query -> MKLocalSearch in
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 80)
        let region = MKCoordinateRegion(center: self.coordinate.value!, span: span)
        request.region = region
        let search = MKLocalSearch(request: request)
        return search
      }
      .flatMapLatest { [unowned self] request -> Observable<[MKMapItem]> in return self.searchLocations(for: request) }
      .bind(to: locations)
      .disposed(by: disposeBag)
  }
  
  /**
   Rx version of getting a location search
   this probably needs to be an extension but that's fine
   **/
  private func searchLocations(for searchRequest: MKLocalSearch) -> Observable<[MKMapItem]> {
    return Observable.create { observer in
      searchRequest.start(completionHandler: { (response, error) in
        if let error = error {
          observer.onError(error)
        } else {
          let items = response?.mapItems ?? []
          observer.onNext(items)
          observer.onCompleted()
        }
      })
      
      // if no results found, we add it in our disposeables to `dispose`
      return Disposables.create {
        searchRequest.cancel()
      }
    }
  }
}
