//
//  Event+Categories.swift
//  SmartReceipts
//
//  Created by Victor on 12/15/16.
//  Copyright © 2016 Will Baumann. All rights reserved.
//

import Foundation

/// All possible Event's categories are here:
extension Event {
    enum Category: String {
        case Purchases = "Purchases"
        case Navigation = "Navigation"
        case Reports = "Reports"
        case Receipts = "Receipts"
        case Distance = "Distance"
        case Generate = "Generate"
        case Ratings = "Ratings"
        case Informational = "Informational"
        case OnError = "OnError"
        
        static let allValues = [Purchases, Navigation, Reports, Receipts, Distance, Generate, Ratings, Informational, OnError]
    }
}



// MARK: - Event constants



/// Event constructors:
public extension Event {
    
    /*
     Important note:
     
     We can't expose Swift structs to Objective-C. if you want add analytics code into Objective-C, you have two choices:
        1) Add class function in next Event extension below int this file (recommended)
        2) Write a Swift extension for Obj-C class and implement AnalyticsManager logging functions inside that Swift extension.
     
     */
    
    struct Purchases {
        static let PurchaseSuccess = Event(category: Category.Purchases, name: "PurchaseSuccess")
        static let PurchaseFailed = Event(category: Category.Purchases, name: "PurchaseFailed")
        static let ShowPurchaseIntent = Event(category: Category.Purchases, name: "ShowPurchaseIntent") // means that in-app purchase popup presented
        // TODO: AdUpsell not implemented for iOS verion:
//        static let AdUpsellShown = Event(category: Category.Purchases, name: "AdUpsellShown")
//        static let AdUpsellShownOnFailure = Event(category: Category.Purchases, name: "AdUpsellShownOnFailure")
//        static let AdUpsellTapped = Event(category: Category.Purchases, name: "AdUpsellTapped")
    }
    
    struct Navigation {
        static let SettingsOverflow = Event(category: Category.Navigation, name: "SettingsOverflow")
        static let BackupOverflow = Event(category: Category.Navigation, name: "BackupOverflow") // tracks backup action
        static let SmartReceiptsPlusOverflow = Event(category: Category.Navigation, name: "SmartReceiptsPlusOverflow") // means that in-app purchase popup presented
    }
    
    struct Reports {
        static let PersistNewReport = Event(category: Category.Reports, name: "PersistNewReport")
        static let PersistUpdateReport = Event(category: Category.Reports, name: "PersistUpdateReport")
    }
    
    struct Receipts {
        static let AddPictureReceipt = Event(category: Category.Receipts, name: "AddPictureReceipt")
        static let AddTextReceipt = Event(category: Category.Receipts, name: "AddTextReceipt")
        static let ImportPictureReceipt = Event(category: Category.Receipts, name: "ImportPictureReceipt")
        static let ReceiptMenuEdit = Event(category: Category.Receipts, name: "ReceiptMenuEdit") // No such menu item, will track "edit" action
        static let ReceiptMenuRetakePhoto = Event(category: Category.Receipts, name: "ReceiptMenuRetakePhoto")
        static let ReceiptMenuViewPdf = Event(category: Category.Receipts, name: "ReceiptMenuViewPdf")
        static let ReceiptMenuViewImage = Event(category: Category.Receipts, name: "ReceiptMenuViewImage")
        static let ReceiptMenuDelete = Event(category: Category.Receipts, name: "ReceiptMenuDelete")
        static let ReceiptMenuMoveCopy = Event(category: Category.Receipts, name: "ReceiptMenuMoveCopy") // in iOS app we have separate "move" and "copy" actions. Currently both are tracked using this event
        static let ReceiptMenuSwapUp = Event(category: Category.Receipts, name: "ReceiptMenuSwapUp")
        static let ReceiptMenuSwapDown = Event(category: Category.Receipts, name: "ReceiptMenuSwapDown")

        static let ReceiptImageViewRotateCcw = Event(category: Category.Receipts, name: "ReceiptImageViewRotateCcw")
        static let ReceiptImageViewRotateCw = Event(category: Category.Receipts, name: "ReceiptImageViewRotateCw")
        static let ReceiptImageViewRetakePhoto = Event(category: Category.Receipts, name: "ReceiptImageViewRetakePhoto")

        static let PersistNewReceipt = Event(category: Category.Receipts, name: "PersistNewReceipt")
        static let PersistUpdateReceipt = Event(category: Category.Receipts, name: "PersistUpdateReceipt")
        // FIXME: On iOS we have different exchangeRate request results:
        /*
         public enum ExchangeServiceStatus {
            case notEnabled // <- This one will not be tracked (notEnabled == no valid subscription)
            case success
            case retrieveError
            case unsupportedCurrency
         }
         */
        static let RequestExchangeRate = Event(category: Category.Receipts, name: "RequestExchangeRate")
        static let RequestExchangeRateSuccess = Event(category: Category.Receipts, name: "RequestExchangeRateSuccess")
        static let RequestExchangeRateFailed = Event(category: Category.Receipts, name: "RequestExchangeRateFailed")
        static let RequestExchangeRateFailedWithNull = Event(category: Category.Receipts, name: "RequestExchangeRateFailedWithNull")
    }
    
    struct Distance {
        static let PersistNewDistance = Event(category: Category.Distance, name: "PersistNewDistance")
        static let PersistUpdateDistance = Event(category: Category.Distance, name: "PersistUpdateDistance")
    }
    
    struct Generate {
        static let FullPdfReport = Event(category: Category.Generate, name: "FullPdfReport")
        static let ImagesPdfReport = Event(category: Category.Generate, name: "ImagesPdfReport")
        static let CsvReport = Event(category: Category.Generate, name: "CsvReport")
        static let StampedZipReport = Event(category: Category.Generate, name: "StampedZipReport")
    }
    
    struct Ratings {
        static let RatingPromptShown = Event(category: Category.Ratings, name: "RatingPromptShown")
        static let UserSelectedRate = Event(category: Category.Ratings, name: "UserSelectedRate")
        static let UserSelectedNever = Event(category: Category.Ratings, name: "UserSelectedNever")
        static let UserSelectedLater = Event(category: Category.Ratings, name: "UserSelectedLater")
    }
    
    struct Informational {
        static let ConfigureReport = Event(category: Category.Reports, name: "ConfigureReports")
    }
}



// MARK: - Compability trick: Exposing Swift constants to the Objective-C



/// Exposing some of the constants to the Objective-C (Swift structs are not supported in Objective-C)
public extension Event {
    
    // MARK: Event.Receipts (WBReceiptsViewController)
    class func receiptsAddPictureReceipt() -> Event {return Event.Receipts.AddPictureReceipt}
    class func receiptsAddTextReceipt() -> Event {return Event.Receipts.AddTextReceipt}
    class func receiptsImportPictureReceipt() -> Event {return Event.Receipts.ImportPictureReceipt}
    
    // MARK: Event.Receipts - Receipt menu (WBReceiptActionsViewController)
    class func receiptsReceiptMenuEdit() -> Event {return Event.Receipts.ReceiptMenuEdit}
    class func receiptsReceiptMenuRetakePhoto() -> Event {return Event.Receipts.ReceiptMenuRetakePhoto}
    class func receiptsReceiptMenuViewPdf() -> Event {return Event.Receipts.ReceiptMenuViewPdf}
    class func receiptsReceiptMenuViewImage() -> Event {return Event.Receipts.ReceiptMenuViewImage}
    class func receiptsReceiptMenuDelete() -> Event {return Event.Receipts.ReceiptMenuDelete}
    class func receiptsReceiptMenuMoveCopy() -> Event {return Event.Receipts.ReceiptMenuMoveCopy}
    class func receiptsReceiptMenuSwapUp() -> Event {return Event.Receipts.ReceiptMenuSwapUp}
    class func receiptsReceiptMenuSwapDown() -> Event {return Event.Receipts.ReceiptMenuSwapDown}
    
    // MARK: Event.Receipts - ReceiptImageView (WBImageViewController)
    class func receiptsReceiptImageViewRotateCcw() -> Event {return Event.Receipts.ReceiptImageViewRotateCcw}
    class func receiptsReceiptImageViewRotateCw() -> Event {return Event.Receipts.ReceiptImageViewRotateCw}
    class func receiptsReceiptImageViewRetakePhoto() -> Event {return Event.Receipts.ReceiptImageViewRetakePhoto}
    
    // MARK: Event.Receipts - Edit receipt (EditReceiptViewController)
    class func receiptsPersistNewReceipt() -> Event {return Event.Receipts.PersistNewReceipt}
    class func receiptsPersistUpdateReceipt() -> Event {return Event.Receipts.PersistUpdateReceipt}
    
    // MARK: - Event.Ratings (RateApplication)
    class func ratingsRatingPromptShown() -> Event {return Event.Ratings.RatingPromptShown}
    class func ratingsUserSelectedRate() -> Event {return Event.Ratings.UserSelectedRate}
    class func ratingsUserSelectedNever() -> Event {return Event.Ratings.UserSelectedNever}
    class func ratingsUserSelectedLater() -> Event {return Event.Ratings.UserSelectedLater}
    
    // MARK: - Event.Distance (EditDistanceViewController)
    class func distancePersistNewDistance() -> Event {return Event.Distance.PersistNewDistance}
    class func distancePersistUpdateDistance() -> Event {return Event.Distance.PersistUpdateDistance}
    
    // MARK: - Event.Reports (EditTripViewController)
    class func reportsPersistNewReport() -> Event {return Event.Reports.PersistNewReport}
    class func reportsPersistUpdateReport() -> Event {return Event.Reports.PersistUpdateReport}
    
    // MARK: - Event.Informational (WBGenerateViewController)
    class func informationalConfigureReport() -> Event {return Event.Informational.ConfigureReport}
    
}

