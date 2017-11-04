//
//  SettingsFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka
import RxSwift
import StoreKit

class SettingsFormView: FormViewController {
    
    weak var openModuleSubject: PublishSubject<SettingsRoutes>!
    weak var alertSubject: PublishSubject<AlertTuple>!
    weak var settingsView: SettingsView!
    
    fileprivate var hadPriceRetrieveError = false
    fileprivate var purchaseRow: PurchaseButtonRow!
    fileprivate var footerRow: InputTextRow!
    fileprivate var removeAdsProduct: SKProduct?
    fileprivate let bag = DisposeBag()
    
    var showOption: ShowSettingsOption?
    
    init(settingsView: SettingsView) {
        super.init(nibName: nil, bundle: nil)
        self.settingsView = settingsView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Database.sharedInstance().hasValidSubscription() {
            setupPurchased()
        } else {
            purchaseRow.markSpinning()
            settingsView.retrivePlusSubscriptionPrice().subscribe(onNext: { [unowned self] price in
                self.purchaseRow.setPrice(string: price)
            }, onError: { [unowned self] error in
                _ = self.purchaseRow.markError().subscribe(onNext: { [unowned self] in
                    self.alertSubject.onNext((title: LocalizedString("settings.purchase.price.retrieve.error.title"),
                                            message: LocalizedString("settings.purchase.price.retrieve.error.message")))
                })
            }).disposed(by: bag)
        }
        applySettingsOption()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.clear
        
        form
        +++ Section(LocalizedString("settings.purchase.section.title"))
        <<< PurchaseButtonRow() { [unowned self] row in
            row.title = LocalizedString("settings.purchase.pro.label")
            self.purchaseRow = row
        }.onCellSelection({ [unowned self] _, row in
            if !row.isPurchased() {
                self.settingsView.purchaseSubscription().subscribe(onNext: { [unowned self] in
                    self.setupPurchased()
                    }, onError: { error in
                        self.alertSubject.onNext((title: LocalizedString("settings.purchase.make.purchase.error.title"),
                                                message: error.localizedDescription))
                }).disposed(by: self.bag)
            }
        })
            
        <<< ButtonRow() { row in
            row.title = LocalizedString("settings.purchase.restore.label")
        }.cellUpdate({ cell, row in
            cell.textLabel?.textColor = AppTheme.primaryColor
        }).onCellSelection({ [unowned self] _, _ in
            let hud = PendingHUDView.show(on: self.navigationController!.view)
            self.settingsView.restorePurchases().subscribe(onNext: { [unowned self] in
                self.setupPurchased()
                hud.hide()
            }, onError: { error in
                hud.hide()
                self.alertSubject.onNext((title: LocalizedString("settings.purchase.restore.error.title"),
                                        message: error.localizedDescription))
            }).disposed(by: self.bag)
        })
        
        +++ Section(LocalizedString("settings.pro.section.title"))
        <<< InputTextRow() { [unowned self] row in
            row.title = LocalizedString("settings.pdf.footer.text.label")
            row.value = WBPreferences.pdfFooterString()
            self.footerRow = row
            row.isEnabled = false
        }.onChange({ row in
            WBPreferences.setPDFFooterString(row.value ?? "")
        }).cellUpdate({ cell, row in
            cell.textField.font = UIFont.systemFont(ofSize: 14)
        }).onCellSelection({ [unowned self] _, row in
            if !row.isEnabled {
                self.alertSubject.onNext((title: LocalizedString("settings.pdf.footer.pro.message.title"),
                                        message: LocalizedString("settings.pdf.footer.pro.message.body")))
            }
        })
           
        +++ Section(LocalizedString("settings.email.section.title"))
        <<< textInput(LocalizedString("settings.default.email.recipient.lebel"),
            value: WBPreferences.defaultEmailRecipient(),
            placeholder: LocalizedString("settings.default.email.recipient.placeholder"))
        .onChange({ row in
            WBPreferences.setDefaultEmailRecipient(row.value ?? "")
        })
        
        <<< textInput(LocalizedString("settings.default.email.cc.lebel"),
            value: WBPreferences.defaultEmailCC(),
            placeholder: LocalizedString("settings.default.email.cc.placeholder"))
        .onChange({ row in
            WBPreferences.setDefaultEmailCC(row.value ?? "")
        })
            
        <<< textInput(LocalizedString("settings.default.email.bcc.label"),
            value: WBPreferences.defaultEmailBCC(),
            placeholder: LocalizedString("settings.default.email.bcc.placeholder"))
        .onChange({ row in
            WBPreferences.setDefaultEmailBCC(row.value ?? "")
        })
            
        <<< textInput(LocalizedString("settings.default.email.subject.label"),
            value: WBPreferences.defaultEmailSubject())
        .onChange({ row in
            WBPreferences.setDefaultEmailSubject(row.value ?? "")
        })

        +++ Section(LocalizedString("settings.general.section.title"))
        <<< switchRow(LocalizedString("settings.enable.autocomplete.label"),
            value: WBPreferences.isAutocompleteEnabled())
        .onChange({row in
            WBPreferences.setAutocompleteEnabled(row.value!)
        })
            
        <<< IntRow() { row in
            row.title = LocalizedString("settings.default.trip.length.label")
            row.placeholder = LocalizedString("settings.default.trip.length.placeholder")
            row.value = Int(WBPreferences.defaultTripDuration())
        }.onChange({ row in
            let intValue = row.value ?? 0
            if intValue > 0  && 1000 > intValue {
                WBPreferences.setDefaultTripDuration(Int32(intValue))
            }
        }).cellUpdate({ cell, _ in
            cell.textField.textColor = AppTheme.primaryColor
        }).cellSetup({ cell, _ in
            cell.textLabel?.numberOfLines = 3
        })
        
        <<< switchRow(LocalizedString("settings.allow.data.outside.trip.bounds.label"),
            value: WBPreferences.allowDataEntryOutsideTripBounds())
        .onChange({ row in
            WBPreferences.setAllowDataEntryOutsideTripBounds(row.value!)
        })
            
        <<< DecimalRow() { row in
            row.title = LocalizedString("settings.min.receipt.price.label")
            let value = WBPreferences.minimumReceiptPriceToIncludeInReports()
            row.value = value == WBPreferences.min_FLOAT() ? nil : Double(value)
            row.placeholder = LocalizedString("settings.min.receipt.price.placeholder")
        }.onChange({ row in
            let value = row.value == nil ? Float(Int.min) : Float(row.value!)
            WBPreferences.setMinimumReceiptPriceToIncludeInReports(value)
        }).cellUpdate({ cell, _ in
            cell.textField.textColor = AppTheme.primaryColor
        }).cellSetup({ cell, _ in
            cell.textLabel?.numberOfLines = 3
        })
            
        <<< textInput(LocalizedString("settings.user.id.label"),
            value: WBPreferences.userID())
        .onChange({ row in
            WBPreferences.setUserID(row.value ?? "")
        })
        <<< textInput(LocalizedString("settings.name.label"),
            value: WBPreferences.fullName())
        .onChange({ row in
            WBPreferences.setFullName(row.value ?? "")
        })

        <<< PickerInlineRow<String>() { row in
            row.title = LocalizedString("settings.default.currency.label")
            row.options = Currency.allCurrencyCodesWithCached()
            row.value = WBPreferences.defaultCurrency()
        }.onChange({ row in
            WBPreferences.setDefaultCurrency(row.value!)
        }).cellSetup({ cell, _ in
            cell.detailTextLabel?.textColor = AppTheme.primaryColor
        })
            
        <<< segmentedRow(LocalizedString("settings.date.separator.label"),
            options: ["-", "/", "."], selectedOption: WBPreferences.dateSeparator())
        .onChange({ row in
            WBPreferences.setDateSeparator(row.selectedOption)
        })
        
        <<< switchRow(LocalizedString("settings.track.cost.center.label"),
            value: WBPreferences.trackCostCenter())
        .onChange({ row in
            WBPreferences.setTrackCostCenter(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.predict.recept.category.label"),
            value: WBPreferences.predictCategories())
        .onChange({ row in
            WBPreferences.setPredictCategories(row.value!)
        })
        
        <<< switchRow(LocalizedString("settings.include.tax.field.label"),
            value: WBPreferences.includeTaxField())
        .onChange({ row in
            WBPreferences.setIncludeTaxField(row.value!)
        })
            
            
        <<< decimalRow(LocalizedString("settings.default.tax.percentage"),
            float: WBPreferences.defaultTaxPercentage(),
            placeholder: "%")
        .onChange({ row in
            let value = row.value == nil ? nil : Float(row.value!)
            WBPreferences.setDefaultTaxPercentage(value ?? 0)
        })
            
        <<< switchRow(LocalizedString("settings.assume.price.pre.tax.label"),
            value: WBPreferences.enteredPricePreTax())
        .onChange({ row in
            WBPreferences.setEnteredPricePreTax(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.receipt.assume.full.page.image.label"),
            value: WBPreferences.assumeFullPage())
        .onChange({ row in
            WBPreferences.setAssumeFullPage(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.match.name.to.category.label"),
            value: WBPreferences.matchNameToCategory())
        .onChange({ row in
            WBPreferences.setMatchNameToCategory(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.match.comments.to.categories"),
            value: WBPreferences.matchCommentToCategory())
        .onChange({ row in
            WBPreferences.setMatchCommentToCategory(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.only.report.reimbursable.label"),
            value: WBPreferences.onlyIncludeReimbursableReceiptsInReports())
        .onChange({ row in
            WBPreferences.setOnlyIncludeReimbursableReceiptsInReports(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.default.reimbursable.label"),
            value: WBPreferences.expensableDefault())
        .onChange({ row in
            WBPreferences.setExpensableDefault(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.default.receipt.date.to.start.date.label"),
            value: WBPreferences.defaultToFirstReportDate())
        .onChange({ row in
            WBPreferences.setDefaultToFirstReportDate(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.show.receipt.id.label"),
            value: WBPreferences.showReceiptID())
        .onChange({ row in
            WBPreferences.setShowReceiptID(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.enable.payment.methods.label"),
            value: WBPreferences.usePaymentMethods())
        .onChange({ row in
            WBPreferences.setUsePaymentMethods(row.value!)
        })
            
        <<< openModuleButton(LocalizedString("settings.customize.payment.methods.label"),
            route: .paymentMethods)

        +++ Section(LocalizedString("settings.camera.section.title"))
        <<< segmentedRow(LocalizedString("settings.max.camera.resolution.label"),
            options: imageOptions(), selected: imageOptionFromPreferences())
        .onChange({ row in
            let options = [512, 1024, 0]
            WBPreferences.setCameraMaxHeightWidth(options[row.value!])
        })
        
        <<< switchRow(LocalizedString("settings.convert.to.grayscale.label"),
            value: WBPreferences.cameraSaveImagesBlackAndWhite())
        .onChange({ row in
            WBPreferences.setCameraSaveImagesBlackAndWhite(row.value!)
        })
        
        +++ Section(LocalizedString("settings.categories.section.title"))
        <<< openModuleButton(LocalizedString("settings.manage.categories.label"),
            route: .categories)
        
        +++ Section(LocalizedString("settings.csv.section.title"))
        <<< switchRow(LocalizedString("settings.csv.include.header.columns.label"),
            value: WBPreferences.includeCSVHeaders())
        .onChange({ row in
            WBPreferences.setIncludeCSVHeaders(row.value!)
        })
        <<< openModuleButton(LocalizedString("settings.csv.configure.columns.label"),
            route: .columns(isCSV: true))
    
        +++ Section(LocalizedString("settings.pdf.section.title"))
        <<< switchRow(LocalizedString("settings.pdf.print.id.by.photo.label"),
            value: WBPreferences.printReceiptIDByPhoto())
        .onChange({ row in
            WBPreferences.setPrintReceiptIDByPhoto(row.value!)
        })

        <<< switchRow(LocalizedString("settings.pdf.print.receipt.comment.by.photo.label"),
            value: WBPreferences.printCommentByPhoto())
        .onChange({ row in
            WBPreferences.setPrintCommentByPhoto(row.value!)
        })

        <<< switchRow(LocalizedString("settings.pdf.print.receipt.table.landscape.label"),
            value: WBPreferences.printReceiptTableLandscape())
        .onChange({ row in
            WBPreferences.setPrintReceiptTableLandscape(row.value!)
        })

        <<< openModuleButton(LocalizedString("settings.pdf.configure.columns.label"),
            route: .columns(isCSV: false))
        
        +++ Section(LocalizedString("settings.distance.section.title"))
        <<< switchRow(LocalizedString("settings.add.distance.price.to.report.label"),
            value: WBPreferences.isTheDistancePriceBeIncludedInReports())
        .onChange({ row in
            WBPreferences.setTheDistancePriceBeIncludedInReports(row.value!)
        })
            
        <<< decimalRow(LocalizedString("settings.gas.rate.label"),
            dobule: WBPreferences.distanceRateDefaultValue(),
            placeholder: LocalizedString("settings.gas.rate.placeholder"))
        .onChange({ row in
            WBPreferences.setDistanceRateDefaultValue(row.value ?? -1)
        })
        <<< switchRow(LocalizedString("settings.include.distance.table.label"),
            value: WBPreferences.printDistanceTable())
        .onChange({ row in
            WBPreferences.setPrintDistanceTable(row.value!)
        })

        <<< switchRow(LocalizedString("settings.distance.report.on.daily.distance"),
            value: WBPreferences.printDailyDistanceValues())
        .onChange({ row in
            WBPreferences.setPrintDailyDistanceValues(row.value!)
        })
        
        +++ Section(LocalizedString("settings.layout.section.title"))
        <<< switchRow(LocalizedString("settings.layout.include.receipt.date.label"),
            value: WBPreferences.layoutShowReceiptDate())
        .onChange({ row in
            WBPreferences.setLayoutShowReceiptDate(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.layout.include.receipt.category.label"),
            value: WBPreferences.layoutShowReceiptCategory())
        .onChange({ row in
            WBPreferences.setLayoutShowReceiptCategory(row.value!)
        })
            
        <<< switchRow(LocalizedString("settings.layout.include.attachment.marker.label"),
            value: WBPreferences.layoutShowReceiptAttachmentMarker())
        .onChange({ row in
            WBPreferences.setLayoutShowReceiptAttachmentMarker(row.value!)
        })
        
        +++ Section(LocalizedString("settings.backup.section.title"))
        <<< openModuleButton(LocalizedString("settings.backup.button.label"))
        .onCellSelection({ [unowned self] cell, _ in
            self.settingsView.showBackup(from: self.tableView.convert(cell.frame, to: self.settingsView.view))
        })
    
        +++ Section(LocalizedString("settings.feedback.section.label"))
        <<< openModuleButton(LocalizedString("settings.feedback.sendLove.label"),
            route: .sendLove)
        <<< openModuleButton(LocalizedString("settings.feedback.sendFeedback.label"),
            onTap: { [unowned self] in
            self.settingsView.sendFeedback(subject: FeedbackEmailSubject)
        })
        <<< openModuleButton(LocalizedString("settings.feedback.sendBugReport.label"),
            onTap: { [unowned self] in
            self.settingsView.sendFeedback(subject: FeedbackBugreportEmailSubject)
        })
    
        +++ Section(LocalizedString("settings.about.section.label"))
        <<< openModuleButton(LocalizedString("settings.about.privacy.label"), route: .privacyPolicy)
    }
    
    private func imageOptions() -> [String] {
        let pixelsString = LocalizedString("settings.camera.pixels.label")
        let option1 = "512 "+pixelsString
        let option2 = "1024 "+pixelsString
        let option3 = LocalizedString("settings.camera.value.default.label")
        return [option1, option2, option3]
    }
    
    private func imageOptionFromPreferences() -> Int {
        let options = [512, 1024, 0]
        return options.index(of: WBPreferences.cameraMaxHeightWidth())!
    }
    
    private func setupPurchased() {
        purchaseRow.setSubscriptionEnd(date: Database.sharedInstance().subscriptionEndDate())
        purchaseRow.markPurchased()
        footerRow.isEnabled = true
    }
    
    private func applySettingsOption() {
        if let option = showOption {
            if option == .openFromGenerateReportModule {
                DispatchQueue.main.async { [unowned self] in
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 6), at: .top, animated: false)
                }
            }
        }
    }
}

// MARK: ROW METHODS
extension SettingsFormView {
    fileprivate func textInput(_ title: String, value: String? = nil, placeholder: String? = nil) -> InputTextRow {
        return InputTextRow() { row in
            row.title = title
            row.value = value
            row.cell.textField.placeholder = placeholder
            }.cellUpdate({ cell, row in
                cell.textField.font = UIFont.systemFont(ofSize: 14)
            })
    }
    
    fileprivate func switchRow(_ title: String, value: Bool = false) -> SwitchRow {
        return SwitchRow() { row in
            row.title = title + "  " //  Fix offset between UILabel and UISwtich
            row.value = value
            }.cellSetup({ cell, row in
                cell.switchControl.onTintColor = AppTheme.primaryColor
                cell.textLabel?.numberOfLines = 3
            })
    }
    
    fileprivate func openModuleButton(_ title: String, route: SettingsRoutes) -> ButtonRow {
        return ButtonRow() { row in
            row.title = title
            }.cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.accessoryType = .disclosureIndicator
                cell.editingAccessoryType = cell.accessoryType
                cell.textLabel?.textColor = UIColor.black
            }).onCellSelection({ [unowned self] _ in
                self.openModuleSubject.onNext(route)
            })
    }
    
    fileprivate func openModuleButton(_ title: String, onTap: (()->Void)? = nil) -> ButtonRow {
        return ButtonRow() { row in
            row.title = title
            }.cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.accessoryType = .disclosureIndicator
                cell.editingAccessoryType = cell.accessoryType
                cell.textLabel?.textColor = UIColor.black
            }).onCellSelection({ _ in
                onTap?()
            })
    }
    
    fileprivate func segmentedRow(_ title: String, options: [String], selected: Int? = nil,
                              selectedOption: String? = nil) -> CustomSegmentedRow {
        var value = 0
        if let intVal = selected {
            value = intVal
        } else {
            if let stringValue = selectedOption {
                value = options.index(of: stringValue) ?? 0
            }
        }
        
        return CustomSegmentedRow() { row in
            row.title = title
            row.options = options
            row.value = value
            }.cellUpdate({ cell, row in
                cell.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            })
    }
    
    fileprivate func decimalRow(_ title: String, float: Float, placeholder: String? = nil) -> DecimalRow {
        return DecimalRow() { row in
            row.title = title
            let value = Double(float)
            row.value = value <= 0 ? nil : value
            row.placeholder = placeholder
            }.cellUpdate({ cell, _ in
                cell.textField.textColor = AppTheme.primaryColor
            }).cellSetup({ cell, _ in
                cell.textLabel?.numberOfLines = 3
            })
    }
    
    fileprivate func decimalRow(_ title: String, dobule: Double, placeholder: String? = nil) -> DecimalRow {
        return DecimalRow() { row in
            row.title = title
            let value = dobule
            row.value = value <= 0 ? nil : value
            row.placeholder = placeholder
            }.cellUpdate({ cell, _ in
                cell.textField.textColor = AppTheme.primaryColor
            }).cellSetup({ cell, _ in
                cell.textLabel?.numberOfLines = 3
            })
    }
}


