//
//  WBGenerateViewController.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTableViewController.h"

#import <MessageUI/MessageUI.h>

#import "WBReceipt.h"
#import "WBTrip.h"

@interface WBGenerateViewController : WBTableViewController<MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *fullPdfReportField;
@property (weak, nonatomic) IBOutlet UISwitch *pdfImagesField;
@property (weak, nonatomic) IBOutlet UISwitch *csvFileField;
@property (weak, nonatomic) IBOutlet UISwitch *zipImagesField;


@property (weak, nonatomic) IBOutlet UILabel *labelFullPdfReport;
@property (weak, nonatomic) IBOutlet UILabel *labelPdfReport;
@property (weak, nonatomic) IBOutlet UILabel *labelCsvFile;
@property (weak, nonatomic) IBOutlet UILabel *labelZipImages;


- (void)setReceipts:(NSArray*)receipts forTrip:(WBTrip*) trip andViewController:(UIViewController*) vc;

- (IBAction)actionDone:(id)sender;
- (IBAction)actionCancel:(id)sender;

@end
