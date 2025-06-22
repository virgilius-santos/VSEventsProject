platform :ios, '12.1'
use_frameworks!

def rx_pods
    pod 'RxSwift', '~> 5.0', :inhibit_warnings => true
    pod 'RxCocoa', '~> 5.0', :inhibit_warnings => true
    pod 'RxAlamofire', '~> 5.0', :inhibit_warnings => true
    pod 'RxDataSources', :inhibit_warnings => true
    pod 'RxSwiftExt', :inhibit_warnings => true
    pod 'RxMapKit', :git => 'https://github.com/virgilius-santos/RxMapKit.git'
end

def rx_pods_tests
    pod 'RxBlocking', '~> 5.0', :inhibit_warnings => true
    pod 'RxTest', '~> 5.0', :inhibit_warnings => true
end

def quick_pods_tests
    pod 'Quick', '~> 5.0', :inhibit_warnings => true
    pod 'Nimble', '~> 10.0', :inhibit_warnings => true
end

def alamofire_pods
    pod 'Alamofire', '~> 4.7', :inhibit_warnings => true
    pod 'AlamofireImage', '~> 3.4', :inhibit_warnings => true
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
            config.build_settings['SWIFT_VERSION'] = '5.0' # RxSwift 5.x requer Swift 5.0
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
            config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
            config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) -suppress-warnings'
            config.build_settings['OTHER_CFLAGS'] = '$(inherited) -w'
        end
    end
end