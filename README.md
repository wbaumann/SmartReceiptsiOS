# Smart Receipts

> A Better Receipt Scanner

![SmartReceipts](SmartReceipts/Images.xcassets/AppIcon.appiconset/iPhone@3x.png)

Turn your phone into a receipt scanner and expense report generator with Smart Receipts! With Smart Receipts, you can track your receipts and easily generate beautiful PDF and CSV reports.
 
Download Smart Receipts on the Apple AppStore:
 
 - [Smart Receipts](https://itunes.apple.com/us/app/smart-receipts/id905698613?ls=1&mt=8). The free version of the app, but it also supports an in-app purchase subscription.

The free and plus versions versions are identical, except the plus version offers the following enhancements:

- The plus version has no ads
- The plus version automatically processes exchange rate conversions (with the newest version)
- The plus version allows you to edit/customize the pdf footer 
    
## Table of Contents

- [Features](#features)
- [Install](#install)
- [Contribute](#contribute)
- [License](#license)

## Features
- [X] Create expense report "folders" to categorize your receipts
- [X] Take receipt photos with your camera's phone
- [X] Import existing pictures on your device
- [X] Import PDF receipts 
- [X] Save receipt price, tax, and currency
- [X] Tag receipt names, categories, payment method, comments, and other metadata
- [X] Create/edit/delete all receipt categories
- [X] Track distance traveled for mileage reimbursement
- [X] Automatic exchange rate processing
- [X] Smart prediction based on past receipts
- [X] Generate PDF, CSV, & ZIP reports
- [X] Fully customizable report output
- [ ] Automatic backup support via Google Drive
- [ ] OCR support for receipt scans
- [ ] Graphical breakdowns of spending per category
- [ ] Cross-organization setting standardization

## Install 

The Smart Receipts code is currently managed via XCode Groups as opposed to folders, so things are a bit messy. We intend to fix this in the near future so that both are aligned.

To install, clone or pull down this project. Please note that it will **NOT** work out of the box, so you will need to add the following files to ensure it will compile:

* `SmartReceipts/GoogleService-Info.plist`. This needs to be added to both the free and plus favors at the root level in order for Firebase to function. Please [refer to the Firebase documentation](https://firebase.google.com/) for more details.
* `SmartReceipts/Service Account.json`. This is is used for Firebase crash reporting.
* `SmartReceipts/GADConstants.m`. This is required to display AdMob advertisments. Replace this with an empty string to prevent ads from loading successfully.
* `SmartReceipts/Secrets.swift`. This is used for low usage "secret" keys that are secret enough that I do not wish to place them in GitHub but are not so secret that they need to be removed from the compiled IPA entirely.

Once these files are included, you should be able to successfully compile, build, unit test, and run the app!

## Contribute

Contributions are always welcome! Please [open an issue](https://github.com/wbaumann/SmartReceiptsiOS/issues/new) to report a bug or file a feature request to get started.  

## License
```
The GNU Affero General Public License (AGPL)

Copyright (c) 2012-2017 Smart Receipts LLC (Will Baumann)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```