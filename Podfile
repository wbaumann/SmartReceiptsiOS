platform :ios, '8.0'

use_frameworks!

project 'SmartReceipts.xcodeproj'

def pods
    
    # File storage
    pod 'FMDB'
    pod 'objective-zip'
    
    # UI
    pod 'MRProgress'
    pod 'UIAlertView-Blocks'
    pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git', :branch => 'Xcode9-Swift3_2'
    pod 'XLPagerTabStrip'
    pod 'Floaty'
    pod 'Toaster'
    
    # Rx
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'RxAlamofire'
    
    # Utilites
    pod 'CocoaLumberjack/Swift'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    
    # Google
    pod 'Google/AdMob'
    pod 'Google/CloudMessaging'
    pod 'GoogleAPIClientForREST/Drive'
    pod 'Google/SignIn'
    pod 'Google/Analytics'
    
    # Firebase
    pod 'Firebase'
    pod 'FirebaseAnalytics'
    pod 'FirebaseCrash'
    
    # Purchases
    pod 'RMStore/Core', :path => '3rdparty/RMStore'
    pod 'RMStore/KeychainPersistence', :path => '3rdparty/RMStore'
    pod 'RMStore/AppReceiptVerificator', :path => '3rdparty/RMStore'
    
    # Architecture
    pod 'Viperit'
    
end

target 'SmartReceipts' do
    pods
end

target 'SmartReceiptsTests' do
    pods
    pod 'RxBlocking'
    pod 'RxTest'
    pod 'Cuckoo'

end

# Disable bitcode for targets:

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
