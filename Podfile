platform :ios, '8.0'

use_frameworks!

project 'SmartReceipts.xcodeproj'

def pods
    
    # File storage
    pod 'FMDB', '2.6.2' # SQLite wrapper
    pod 'objective-zip', '1.0.3'
    
    # UI
    pod 'MRProgress', '0.8.3'
    pod 'UIAlertView-Blocks', '~> 1.0'
    
    # Utilites
    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
    pod 'Firebase', '~> 3.11'
    pod 'FirebaseAnalytics', '~> 3.6'
    pod 'FirebaseCrash', '~> 1.1'
    pod 'GoogleAPIClientForREST/Drive', '~> 1.2.1'
    pod 'Google/SignIn', '~> 3.0.3'
    pod 'Google/Analytics', '~> 3.0'
    pod 'Google-Mobile-Ads-SDK', '~> 7.20'
    pod 'Tweaks', '~> 2.0.0' # configurable values. Tweaks is an easy way to fine-tune an iOS app.
    pod 'CocoaLumberjack/Swift', '~> 3.2.0' # Logging framework
    
    # Purchases
    pod 'RMStore/Core', :path => '3rdparty/RMStore'
    pod 'RMStore/KeychainPersistence', :path => '3rdparty/RMStore'
    pod 'RMStore/AppReceiptVerificator', :path => '3rdparty/RMStore'
    
    # Architecture
    pod 'Viperit', '~> 0.5.0'
    
end

target 'SmartReceipts' do
    pods
end

target 'SmartReceiptsTests' do
    pods
    pod 'RxBlocking', '~> 3.0'
    pod 'RxTest',     '~> 3.0'

end

# Disable bitcode for targets:

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
