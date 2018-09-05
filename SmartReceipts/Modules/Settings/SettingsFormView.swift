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
import Crashlytics
import Fabric

fileprivate let IMAGE_OPTIONS = [512, 1024, 2048, 0]

class SettingsFormView: FormViewController {
    private var hasValidSubscription = false
    
    weak var openModuleSubject: PublishSubject<SettingsRoutes>!
    weak var alertSubject: PublishSubject<AlertTuple>!
    weak var settingsView: SettingsView!
    
    fileprivate var hadPriceRetrieveError = false
    fileprivate var purchaseRow: PurchaseButtonRow!
    fileprivate var footerRow: InputTextRow!
    fileprivate var removeAdsProduct: SKProduct?
    fileprivate let bag = DisposeBag()
    
    var hud: PendingHUDView?
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
        purchaseRow.markSpinning()
        checkSubscription()
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
                self.settingsView.purchaseSubscription()
                    .subscribe(onNext: { [weak self] in
                        guard let safeSelf = self else { return }
                        safeSelf.hud = PendingHUDView.show(on: safeSelf.navigationController!.view)
                        safeSelf.checkSubscription()
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
            self.settingsView.restoreSubscription()
                .do(onNext: { _ in
                    hud.hide()
                }).filter({ $0.valid })
                .subscribe(onNext: { [weak self] validation in
                    self?.setupPurchased(expireDate: validation.expireTime)
                }, onError: { error in
                    self.alertSubject.onNext((title: LocalizedString("settings.purchase.restore.error.title"),
                                        message: error.localizedDescription))
                }).disposed(by: self.bag)
        })
        
        +++ Section(LocalizedString("settings.pro.section.title"))
        <<< InputTextRow() { [unowned self] row in
            row.title = LocalizedString("settings.pdf.footer.text.label")
            row.value = WBPreferences.pdfFooterString()
            self.footerRow = row
            row.isEnabled = self.hasValidSubscription
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
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.pro.payments.by.category.title")
            row.value = WBPreferences.separatePaymantsByCategory()
            row.onSubtitle = LocalizedString("settings.pro.payments.by.category.description.on")
            row.offSubtitle = LocalizedString("settings.pro.payments.by.category.description.off")
        }.onChange({ row in
            WBPreferences.setSeparatePaymantsByCategory(row.value!)
        }).cellUpdate({ [unowned self] cell, _ in
            cell.isUserInteractionEnabled = self.hasValidSubscription
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.pro.categorical.summation.title")
            row.value = WBPreferences.includeCategoricalSummation()
            row.onSubtitle = LocalizedString("settings.pro.categorical.summation.description.on")
            row.offSubtitle = LocalizedString("settings.pro.categorical.summation.description.off")
        }.onChange({ row in
            WBPreferences.setIncludeCategoricalSummation(row.value!)
        }).cellUpdate({ [unowned self] cell, _ in
            cell.isUserInteractionEnabled = self.hasValidSubscription
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.pro.omit.default.pdf.table.title")
            row.value = WBPreferences.omitDefaultPdfTable()
        }.onChange({ row in
            WBPreferences.setOmitDefaultPdfTable(row.value!)
        }).cellUpdate({ [unowned self] cell, _ in
            cell.isUserInteractionEnabled = self.hasValidSubscription
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
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.enable.autocomplete.label")
            row.onSubtitle = LocalizedString("settings_receipt_enable_autocomplete_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.isAutocompleteEnabled()
        }.onChange({ row in
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
            row.value = value == WBPreferences.min_FLOAT() || value == Float(Int32.min) ? nil : Double(value)
            row.placeholder = LocalizedString("settings.min.receipt.price.placeholder")
        }.onChange({ row in
            let value = row.value == nil ? WBPreferences.min_FLOAT() : Float(row.value!)
            WBPreferences.setMinimumReceiptPriceToIncludeInReports(value)
        }).cellUpdate({ cell, _ in
            cell.textField.textColor = AppTheme.primaryColor
        }).cellSetup({ cell, _ in
            cell.textLabel?.numberOfLines = 3
            cell.textField.inputView = NumberKeyboard.create(delegate: cell.textField)
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
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.track.cost.center.label")
            row.onSubtitle = LocalizedString("settings_track_cost_center_summaryOn")
            row.offSubtitle = LocalizedString("settings_track_cost_center_summaryOff")
            row.value = WBPreferences.trackCostCenter()
        }.onChange({ row in
            WBPreferences.setTrackCostCenter(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.predict.recept.category.label")
            row.onSubtitle = LocalizedString("settings_receipt_predict_categories_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.predictCategories()
        }.onChange({ row in
            WBPreferences.setPredictCategories(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.include.tax.field.label")
            row.onSubtitle = LocalizedString("settings_receipt_include_tax_field_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.includeTaxField()
        }.onChange({ row in
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
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.receipt.assume.full.page.image.label")
            row.onSubtitle = LocalizedString("settings_receipt_full_page_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.assumeFullPage()
        }.onChange({ row in
            WBPreferences.setAssumeFullPage(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.match.name.to.category.label")
            row.onSubtitle = LocalizedString("settings_receipt_match_name_to_category_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.matchNameToCategory()
        }.onChange({ row in
            WBPreferences.setMatchNameToCategory(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.match.comments.to.categories")
            row.onSubtitle = LocalizedString("settings_receipt_match_comment_to_category_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.matchCommentToCategory()
        }.onChange({ row in
            WBPreferences.setMatchCommentToCategory(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.only.report.reimbursable.label")
            row.onSubtitle = LocalizedString("settings_receipt_reimbursable_only_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.onlyIncludeReimbursableReceiptsInReports()
        }.onChange({ row in
            WBPreferences.setOnlyIncludeReimbursableReceiptsInReports(row.value!)
        })
            
            
        <<< switchRow(LocalizedString("settings.default.reimbursable.label"),
            value: WBPreferences.expensableDefault())
        .onChange({ row in
            WBPreferences.setExpensableDefault(row.value!)
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.default.receipt.date.to.start.date.label")
            row.onSubtitle = LocalizedString("settings_receipt_default_to_report_start_date_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.defaultToFirstReportDate()
        }.onChange({ row in
            WBPreferences.setDefaultToFirstReportDate(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.show.receipt.id.label")
            row.onSubtitle = LocalizedString("settings_receipt_show_id_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.showReceiptID()
        }.onChange({ row in
            WBPreferences.setShowReceiptID(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.enable.payment.methods.label")
            row.onSubtitle = LocalizedString("settings_receipt_use_payment_methods_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.usePaymentMethods()
        }.onChange({ row in
            WBPreferences.setUsePaymentMethods(row.value!)
        })
            
        <<< openModuleButton(LocalizedString("settings.customize.payment.methods.label"),
            subtitle: LocalizedString("settings_receipt_payment_methods_summary"), route: .paymentMethods)

        +++ Section(LocalizedString("settings.camera.section.title"))
        <<< segmentedRow(LocalizedString("settings.max.camera.resolution.label"),
            options: imageOptions(), selected: imageOptionFromPreferences())
        .onChange({ row in
            WBPreferences.setCameraMaxHeightWidth(IMAGE_OPTIONS[row.value!])
        })
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.convert.to.grayscale.label")
            row.onSubtitle = LocalizedString("settings_camera_bw_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.cameraSaveImagesBlackAndWhite()
        }.onChange({ row in
            WBPreferences.setCameraSaveImagesBlackAndWhite(row.value!)
        })
            
        
        +++ Section(LocalizedString("settings.categories.section.title"))
        <<< openModuleButton(LocalizedString("settings.manage.categories.label"),
            subtitle: LocalizedString("settings_receipt_customize_categories_summary"), route: .categories)
        
        +++ Section(LocalizedString("settings.csv.section.title"))
        <<< switchRow(LocalizedString("settings.csv.include.header.columns.label"),
            value: WBPreferences.includeCSVHeaders())
        .onChange({ row in
            WBPreferences.setIncludeCSVHeaders(row.value!)
        })
        <<< openModuleButton(LocalizedString("settings.csv.configure.columns.label"),
            route: .columns(isCSV: true))
    
        +++ Section(LocalizedString("settings.pdf.section.title"))
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.pdf.print.id.by.photo.label")
            row.onSubtitle = LocalizedString("settings_output_print_receipt_id_by_photo_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.printReceiptIDByPhoto()
        }.onChange({ row in
            WBPreferences.setPrintReceiptIDByPhoto(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.pdf.print.receipt.comment.by.photo.label")
            row.onSubtitle = LocalizedString("settings_pdf_print_receipt_comment_by_photo_summaryOn")
            row.offSubtitle = LocalizedString("settings_pdf_print_receipt_comment_by_photo_summaryOff")
            row.value = WBPreferences.printCommentByPhoto()
        }.onChange({ row in
            WBPreferences.setPrintCommentByPhoto(row.value!)
        })

        <<< switchRow(LocalizedString("settings.pdf.print.receipt.table.landscape.label"),
            value: WBPreferences.printReceiptTableLandscape())
        .onChange({ row in
            WBPreferences.setPrintReceiptTableLandscape(row.value!)
        })
            
        <<< segmentedRow(LocalizedString("settings_pdf_page_size"),
            options: pdfFormats(), selected: pdfFormats().index(of: WBPreferences.prefferedPDFSize().rawValue) ?? 0)
        .onChange({ row in
            WBPreferences.setPreferedRawPDFSize(PDFPageSize.pdfPageSizeBy(index: row.value!).rawValue)
        })

        <<< openModuleButton(LocalizedString("settings.pdf.configure.columns.label"),
            route: .columns(isCSV: false))
        
        +++ Section(LocalizedString("settings.distance.section.title"))
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.distance.section.title")
            row.onSubtitle = LocalizedString("settings_distance_include_price_in_report_summaryOn")
            row.offSubtitle = LocalizedString("settings_distance_include_price_in_report_summaryOff")
            row.value = WBPreferences.isTheDistancePriceBeIncludedInReports()
        }.onChange({ row in
            WBPreferences.setTheDistancePriceBeIncludedInReports(row.value!)
        })
            
        <<< decimalRow(LocalizedString("settings.gas.rate.label"),
            dobule: WBPreferences.distanceRateDefaultValue(),
            placeholder: LocalizedString("settings.gas.rate.placeholder"))
        .onChange({ row in
            WBPreferences.setDistanceRateDefaultValue(row.value ?? -1)
        })
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.include.distance.table.label")
            row.onSubtitle = LocalizedString("settings_distance_print_table_summaryOn")
            row.offSubtitle = LocalizedString("settings_distance_print_table_summaryOff")
            row.value = WBPreferences.printDistanceTable()
        }.onChange({ row in
            WBPreferences.setPrintDistanceTable(row.value!)
        })

        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.distance.report.on.daily.distance")
            row.onSubtitle = LocalizedString("settings_distance_print_daily_summaryOn")
            row.offSubtitle = LocalizedString("settings_distance_print_daily_summaryOff")
            row.value = WBPreferences.printDailyDistanceValues()
        }.onChange({ row in
            WBPreferences.setPrintDailyDistanceValues(row.value!)
        })
        
        +++ Section(LocalizedString("settings.layout.section.title"))
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.layout.include.receipt.date.label")
            row.onSubtitle = LocalizedString("settings_layout_display_date_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.layoutShowReceiptDate()
        }.onChange({ row in
            WBPreferences.setLayoutShowReceiptDate(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.layout.include.receipt.category.label")
            row.onSubtitle = LocalizedString("settings_layout_display_category_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.layoutShowReceiptCategory()
        }.onChange({ row in
            WBPreferences.setLayoutShowReceiptCategory(row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("settings.layout.include.attachment.marker.label")
            row.onSubtitle = LocalizedString("settings_layout_display_photo_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.layoutShowReceiptAttachmentMarker()
        }.onChange({ row in
            WBPreferences.setLayoutShowReceiptAttachmentMarker(row.value!)
        })
            
        +++ Section(LocalizedString("pref_privacy_header"))
        <<< openModuleButton(LocalizedString("pref_about_privacy_policy_title"), route: .privacyPolicy)
        
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_privacy_enable_analytics_title")
            row.onSubtitle = LocalizedString("pref_privacy_enable_analytics_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.analyticsEnabled()
        }.onChange({ row in
            WBPreferences.setAnalyticsEnabled(row.value!)
            AnalyticsManager.sharedManager.setAnalyticsSending(allowed: row.value!)
        })
            
        <<< DescribedSwitchRow() { row in
            row.title = LocalizedString("pref_privacy_enable_crash_tracking_title")
            row.onSubtitle = LocalizedString("pref_privacy_enable_crash_tracking_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.crashTrackingEnabled()
        }.onChange({ row in
            WBPreferences.setCrashTrackingEnabled(row.value!)
            _ = row.value! ? Fabric.with([Crashlytics.self]) : Fabric.with([])
        })
            
        <<< DescribedSwitchRow() { row in
            row.hidden = Condition(booleanLiteral: hasValidSubscription)
            row.title = LocalizedString("pref_privacy_enable_ad_personalization_title")
            row.onSubtitle = LocalizedString("pref_privacy_enable_ad_personalization_summary")
            row.offSubtitle = row.onSubtitle
            row.value = WBPreferences.adPersonalizationEnabled()
        }.onChange({ row in
            WBPreferences.setAdPersonalizationEnabled(row.value!)
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
    }
    
    private func imageOptions() -> [String] {
        let pixelsString = LocalizedString("settings.camera.pixels.label")
        let option1 = "512 "+pixelsString
        let option2 = "1024 "+pixelsString
        let option3 = "2048 "+pixelsString
        let option4 = LocalizedString("settings.camera.value.default.label")
        return [option1, option2, option3, option4]
    }
    
    private func pdfFormats() -> [String] {
        return ["A4", LocalizedString("settings_pdf_page_size_letter")]
    }
    
    private func imageOptionFromPreferences() -> Int {
        return IMAGE_OPTIONS.index(of: WBPreferences.cameraMaxHeightWidth())!
    }
    
    private func checkSubscription() {
        settingsView.subscriptionValidation().subscribe(onNext: { [weak self] validation in
            self?.hud?.hide()
            if validation.valid {
                self?.setupPurchased(expireDate: validation.expireTime)
            } else {
                _ = self?.settingsView.retrivePlusSubscriptionPrice().subscribe(onNext: { [weak self] price in
                    self?.purchaseRow.setPrice(string: price)
                }, onError: { [weak self] error in
                    _ = self?.purchaseRow.markError().subscribe(onNext: { [weak self] in
                        self?.alertSubject.onNext((title: LocalizedString("settings.purchase.price.retrieve.error.title"),
                                                  message: LocalizedString("settings.purchase.price.retrieve.error.message")))
                    })
                })
            }
        }, onError: { [weak self] _ in
            self?.hud?.hide()
        }).disposed(by: bag)
    }
    
    private func setupPurchased(expireDate: Date?) {
        hasValidSubscription = true
        purchaseRow.markPurchased()
        purchaseRow.setSubscriptionEnd(date: expireDate)
        footerRow.isEnabled = true
        DispatchQueue.main.async { [unowned self] in
            self.form.allSections[1].reload()
        }
    }
    
    private func applySettingsOption() {
        if let option = showOption {
            DispatchQueue.main.async { [unowned self] in
                switch option {
                case .reportCSVOutputSection:
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 6), at: .top, animated: false)
                case .distanceSection:
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 8), at: .top, animated: false)
                case .privacySection:
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 10), at: .top, animated: false)
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
    
    fileprivate func openModuleButton(_ title: String, subtitle: String? = nil, route: SettingsRoutes) -> DescribedButtonRow {
        return DescribedButtonRow() { row in
            row.title = title
            row.subtitle = subtitle
        }.cellUpdate({ cell, row in
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
            cell.textLabel?.textColor = UIColor.black
        }).onCellSelection({ [unowned self] _,_  in
            self.openModuleSubject.onNext(route)
        })
    }
    
    fileprivate func openModuleButton(_ title: String, subtitle: String? = nil, onTap: (()->Void)? = nil) -> DescribedButtonRow {
        return DescribedButtonRow() { row in
                row.title = title
                row.subtitle = subtitle
            }.cellUpdate({ cell, row in
                cell.textLabel?.textAlignment = .left
                cell.accessoryType = .disclosureIndicator
                cell.editingAccessoryType = cell.accessoryType
                cell.textLabel?.textColor = UIColor.black
            }).onCellSelection({ _,_  in
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


