platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

project 'SmartReceipts.xcodeproj'

def pods
    #AWS
    pod 'AWSCognito'
    pod 'AWSS3'
    
    # File storage
    pod 'FMDB'
    pod 'Zip'
    
    # UI
    pod 'MRProgress'
    pod 'Eureka'
    pod 'XLPagerTabStrip'
    pod 'Floaty'
    pod 'Toaster'
    pod 'MKDropdownMenu'
    
    # Rx
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'RxAlamofire'
    
    # Utilites
    pod 'CocoaLumberjack/Swift'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    
    # Firebase
    pod 'Firebase/Core'
    pod 'Firebase/Analytics'
    pod 'Firebase/Messaging'
    pod 'Firebase/AdMob'
    
    # Google
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'GTMAppAuth'
    pod 'GoogleAPIClientForREST/Drive'
    pod 'GoogleSignIn'
    
    # Purchases
    pod 'SwiftyStoreKit'
    
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
