platform :ios, '9.0'
use_frameworks!

target 'UTANow' do
  pod 'Kingfisher', '~> 1.7'
  pod 'Mapbox-iOS-SDK', '~> 2.1.2'
  pod 'Firebase', '~> 2.5.0'
  pod 'PKHUD', '~> 3.0.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end

