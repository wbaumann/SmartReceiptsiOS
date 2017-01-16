platform :ios, '8.0'

use_frameworks!

project 'SmartReceipts.xcodeproj'

def pods
    
    # File storage
    pod 'FMDB', '2.6.2' # SQLite wrapper
    pod 'objective-zip', '1.0.2', :inhibit_warnings => true
    
    # UI
    pod 'MRProgress', '0.8.3'
    pod 'UIAlertView-Blocks', '~> 1.0'
    
    # Utilites
    pod 'Google-Mobile-Ads-SDK'
    pod 'SplunkMint' # Usage, performance and crash monitoring for your iOS apps
    pod 'Tweaks', '~> 2.0.0' # configurable values. Tweaks is an easy way to fine-tune an iOS app.
    pod 'CocoaLumberjack/Swift' # Logging framework
    
    # Purchases
    pod 'RMStore/Core', :path => '3rdparty/RMStore'
    pod 'RMStore/KeychainPersistence', :path => '3rdparty/RMStore'
    pod 'RMStore/AppReceiptVerificator', :path => '3rdparty/RMStore'
    
    # Analytics
    pod 'Google/Analytics'
    pod 'FirebaseAnalytics', '~> 3.6'
    pod 'FirebaseCrash', '~> 1.1'
    
end

target 'SmartReceipts' do
    pods
end

target 'SmartReceiptsTests' do
    pods
end

# Disable bitcode for targets:

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
