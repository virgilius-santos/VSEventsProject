# Uncomment the next line to define a global platform for your project
  platform :ios, '12.1'
  use_frameworks!

def rx_pods
    pod 'RxSwift',    '~> 5.0'
    pod 'RxCocoa',    '~> 5.0'
    pod 'RxAlamofire','~> 5.0'
    pod 'RxDataSources'
    pod 'RxSwiftExt'
    # pod 'RxMapKit'
end

def rx_pods_tests
    pod 'RxBlocking', '~> 5.0'
    pod 'RxTest',     '~> 5.0'
end

def quick_pods_tests
    pod 'Quick', '1.3.2'
    pod 'Nimble', '7.3.1'
end

def alamofire_pods
    pod 'Alamofire',      '~> 4.7'
    pod 'AlamofireImage', '~> 3.4'
end


target 'VSEventsProject' do
    alamofire_pods
    rx_pods
end

target 'VSEventsProjectTests' do
    rx_pods_tests
    quick_pods_tests
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
        config.build_settings['SWIFT_VERSION'] = '5.10'
        config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
      end
    end
  end