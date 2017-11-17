platform :ios, '10.3'
inhibit_all_warnings!
use_frameworks!

target 'FreshPlan' do
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'JWTDecode'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'Moya/RxSwift'
  pod 'RxOptional'
  pod 'MaterialComponents'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    # Configure Pod targets
    config.build_settings['SWIFT_VERSION'] = '4.0'
  end
end
