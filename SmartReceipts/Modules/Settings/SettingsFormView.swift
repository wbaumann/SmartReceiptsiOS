//
//  SettingsFormView.swift
//  SmartReceipts
//
//  Created by Bogdan Evsenev on 06/07/2017.
//  Copyright © 2017 Will Baumann. All rights reserved.
//

import Eureka

class SettingsFormView: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clear
        
        form
        +++ Section(LocalizedString("settings.purchase.section.title"))
        <<< TextRow() { row in
            row.title = LocalizedString("settings.purchase.pro.label")
            row.value = "50110$"
        }.cellSetup({ cell, row in
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            cell.textField.isUserInteractionEnabled = false
        }).cellUpdate({ cell, row in
            cell.textField?.textColor = AppTheme.themeColor
        })
            
        <<< ButtonRow() { row in
            row.title = LocalizedString("settings.purchase.restore.label")
        }
        
        +++ Section(LocalizedString("settings.pro.section.title"))
        <<< textInput(LocalizedString("settings.default.email.recipient.lebel"))
            
        +++ Section(LocalizedString("settings.pro.section.title"))
        <<< textInput(LocalizedString("settings.default.email.recipient.lebel"))
        <<< textInput(LocalizedString("settings.default.email.cc.lebel"))
        <<< textInput(LocalizedString("settings.default.email.subject.label"))
        <<< textInput(LocalizedString("settings.default.email.subject.label"))

        +++ Section(LocalizedString("settings.general.section.title"))
        <<< switchRow(LocalizedString("settings.enable.autocomplete.label"))
        
        <<< textInput(LocalizedString("settings.default.trip.length.label"))
        
        <<< switchRow(LocalizedString("settings.allow.data.outside.trip.bounds.label"))
        
        <<< textInput(LocalizedString("settings.min.receipt.price.label"))
        <<< textInput(LocalizedString("settings.user.id.label"))
        <<< textInput(LocalizedString("settings.name.label"))

        <<< PickerInlineRow<String>() { row in
            row.title = LocalizedString("settings.default.currency.label")
            row.options = Currency.allCurrencyCodesWithCached()
            row.value = WBPreferences.defaultCurrency()
        }.onChange({ row in
            WBPreferences.setDefaultCurrency(row.value!)
        }).cellSetup({ cell, _ in
            cell.textLabel?.font = AppTheme.boldFont
            cell.detailTextLabel?.textColor = AppTheme.themeColor
            cell.detailTextLabel?.font = AppTheme.boldFont
        })
            
        <<< segmentedRow(LocalizedString("settings.date.separator.label"), options: ["-", "/", "."], selected: 0)
        
        <<< switchRow(LocalizedString("settings.track.cost.center.label"))
        <<< switchRow(LocalizedString("settings.predict.recept.category.label"))
        <<< switchRow(LocalizedString("settings.include.tax.field.label"))
        <<< textInput(LocalizedString("settings.default.tax.percentage"))
        <<< switchRow(LocalizedString("settings.assume.price.pre.tax.label"))
        <<< switchRow(LocalizedString("settings.receipt.assume.full.page.image.label"))
        <<< switchRow(LocalizedString("settings.match.name.to.category.label"))
        <<< switchRow(LocalizedString("settings.match.comments.to.categories"))
        <<< switchRow(LocalizedString("settings.only.report.reimbursable.label"))
        <<< switchRow(LocalizedString("settings.default.receipt.date.to.start.date.label"))
        <<< switchRow(LocalizedString("settings.show.receipt.id.label"))
        <<< switchRow(LocalizedString("settings.enable.payment.methods.label"))
        <<< openModuleButton(LocalizedString("settings.customize.payment.methods.label"))

        
        let pixelsString = LocalizedString("settings.camera.pixels.label")
        let preset1 = "512 "+pixelsString
        let preset2 = "1024 "+pixelsString
        let preset3 = LocalizedString("settings.camera.value.default.label")
        form
        +++ Section(LocalizedString("settings.camera.section.title"))
        <<< segmentedRow(LocalizedString("settings.max.camera.resolution.label"),
                         options: [preset1, preset2, preset3], selected: 0)
        <<< switchRow(LocalizedString("settings.convert.to.grayscale.label"))
        
        +++ Section(LocalizedString("settings.categories.section.title"))
        <<< openModuleButton(LocalizedString("settings.manage.categories.label"))
        
        +++ Section(LocalizedString("settings.csv.section.title"))
        <<< switchRow(LocalizedString("settings.csv.include.header.columns.label"))
        <<< openModuleButton(LocalizedString("settings.csv.configure.columns.label"))
    
        +++ Section(LocalizedString("settings.pdf.section.title"))
        <<< switchRow(LocalizedString("settings.pdf.print.id.by.photo.label"))
        <<< switchRow(LocalizedString("settings.pdf.print.receipt.comment.by.photo.label"))
        <<< switchRow(LocalizedString("settings.pdf.print.receipt.table.landscape.label"))
        <<< openModuleButton(LocalizedString("settings.pdf.configure.columns.label"))
        
        +++ Section(LocalizedString("settings.distance.section.title"))
        <<< switchRow(LocalizedString("settings.add.distance.price.to.report.label"))
        <<< textInput(LocalizedString("settings.gas.rate.label"))
        <<< switchRow(LocalizedString("settings.include.distance.table.label"))
        <<< switchRow(LocalizedString("settings.distance.report.on.daily.distance"))
        
        +++ Section(LocalizedString("settings.layout.section.title"))
        <<< switchRow(LocalizedString("settings.layout.include.receipt.date.label"))
        <<< switchRow(LocalizedString("settings.layout.include.receipt.category.label"))
        <<< switchRow(LocalizedString("settings.layout.include.attachment.marker.label"))
        
        +++ Section(LocalizedString("settings.backup.section.title"))
        <<< openModuleButton(LocalizedString("settings.backup.button.label"))
    
        +++ Section(LocalizedString("settings.feedback.section.label"))
        <<< openModuleButton(LocalizedString("settings.feedback.sendLove.label"))
        <<< openModuleButton(LocalizedString("settings.feedback.sendFeedback.label"))
        <<< openModuleButton(LocalizedString("settings.feedback.sendBugReport.label"))
    
        +++ Section(LocalizedString("settings.about.section.label"))
        <<< openModuleButton(LocalizedString("settings.about.privacy.label"))
    }
    
    private func textInput(_ title: String) -> InputTextRow {
        return InputTextRow() { row in
            row.title = title
        }.cellUpdate({ cell, row in
            cell.textField.font = UIFont.systemFont(ofSize: 12)
        })
    }
    
    private func switchRow(_ title: String) -> SwitchRow {
        return SwitchRow() { row in
            row.title = title + "  " //  Fix offset between UILabel and UISwtich
        }.cellSetup({ cell, row in
            cell.switchControl.onTintColor = AppTheme.themeColor
            cell.textLabel?.adjustsFontSizeToFitWidth = true
        }).cellUpdate({ cell, row in
            
        })
    }
    
    private func openModuleButton(_ title: String) -> ButtonRow {
        return ButtonRow() { row in
            row.title = title
        }.cellUpdate({ cell, row in
            cell.textLabel?.textAlignment = .left
            cell.accessoryType = .disclosureIndicator
            cell.editingAccessoryType = cell.accessoryType
            cell.textLabel?.textColor = UIColor.black
        })
    }
    
    private func segmentedRow(_ title: String, options: [String], selected: Int = 0) -> CustomSegmentedRow {
        return CustomSegmentedRow() { row in
            row.title = title
            row.options = options
            row.value = selected
        }.cellUpdate({ cell, row in
            cell.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        })
    }
}


