//
//  WBGenerateViewController.m
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBGenerateViewController.h"

#import "WBImageStampler.h"

#import "WBReceiptAndIndex.h"
#import "WBPreferences.h"

#import "WBReportUtils.h"

#import "TripCSVGenerator.h"
#import "TripImagesPDFGenerator.h"
#import "TripFullPDFGenerator.h"
#import "Database.h"
#import "Database+Receipts.h"
#import "PendingHUDView.h"
#import "Constants.h"

@interface WBGenerateViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *fullPdfReportField;
@property (weak, nonatomic) IBOutlet UISwitch *pdfImagesField;
@property (weak, nonatomic) IBOutlet UISwitch *csvFileField;
@property (weak, nonatomic) IBOutlet UISwitch *zipImagesField;
@property (weak, nonatomic) IBOutlet UILabel *labelFullPdfReport;
@property (weak, nonatomic) IBOutlet UILabel *labelPdfReport;
@property (weak, nonatomic) IBOutlet UILabel *labelCsvFile;
@property (weak, nonatomic) IBOutlet UILabel *labelZipImages;


@end

@implementation WBGenerateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"generate.report.controller.title", nil);
    
    self.labelFullPdfReport.text = NSLocalizedString(@"generate.report.option.full.pdf", nil);
    self.labelPdfReport.text = NSLocalizedString(@"generate.report.option.pdf.no.table", nil);
    self.labelCsvFile.text = NSLocalizedString(@"generate.report.option.csv", nil);
    self.labelZipImages.text = NSLocalizedString(@"generate.report.option.zip.stamped", nil);
}

- (void) clearPath:(NSString*) path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

- (MFMailComposeViewController*) preparedComposer {
    
    [_trip createDirectoryIfNotExists];

    NSString *pdfPath = [_trip fileInDirectoryPath:[NSString stringWithFormat:@"%@.pdf", [_trip name]]];
    NSString *pdfImagesPath = [_trip fileInDirectoryPath:[NSString stringWithFormat:@"%@Images.pdf", [_trip name]]];
    NSString *csvPath = [_trip fileInDirectoryPath:[NSString stringWithFormat:@"%@.csv", [_trip name]]];
    NSString *zipPath = [_trip fileInDirectoryPath:[NSString stringWithFormat:@"%@.zip", [_trip name]]];

    WBImageStampler *imagesStampler = [[WBImageStampler alloc] init];
    
    NSMutableArray *createdAttachements = @[].mutableCopy;

    if (self.fullPdfReportField.on) {
        [self clearPath:pdfPath];
        TripFullPDFGenerator *generator = [[TripFullPDFGenerator alloc] initWithTrip:self.trip database:[Database sharedInstance]];
        if (![generator generateToPath:pdfPath]) {
            return nil;
        }
        [createdAttachements addObject:pdfPath];
    }

    if (self.pdfImagesField.on) {
        [self clearPath:pdfImagesPath];
        TripImagesPDFGenerator *generator = [[TripImagesPDFGenerator alloc] initWithTrip:self.trip database:[Database sharedInstance]];
        if (![generator generateToPath:pdfImagesPath]) {
            return nil;
        }
        [createdAttachements addObject:pdfImagesPath];
    }

    if (self.csvFileField.on) {
        [self clearPath:csvPath];
        TripCSVGenerator *generator = [[TripCSVGenerator alloc] initWithTrip:self.trip database:[Database sharedInstance]];
        if (![generator generateToPath:csvPath]) {
            return nil;
        }
        [createdAttachements addObject:csvPath];
    }
    
    if (self.zipImagesField.on) {
        [self clearPath:zipPath];

        NSArray *rai = [WBReceiptAndIndex receiptsAndIndicesFromReceipts:[[Database sharedInstance] allReceiptsForTrip:self.trip] filteredWith:^BOOL(WBReceipt *r) {
            return [WBReportUtils filterOutReceipt:r];
        }];

        if (![imagesStampler zipToFile:zipPath stampedImagesForReceiptsAndIndexes:rai inTrip:_trip]) {
            return nil;
        }
        [createdAttachements addObject:zipPath];
    }
    
    // sending

    NSString *suffix = [createdAttachements count] > 1 ? NSLocalizedString(@"generate.report.multiple.attached.suffix", nil) : NSLocalizedString(@"generate.report.one.attached.suffix", nil);
    NSString *messageBody = [NSString stringWithFormat:@"%d %@",
                             (int)[createdAttachements count], suffix];

    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:[[WBPreferences defaultEmailSubject] stringByReplacingOccurrencesOfString:@"%REPORT_NAME%" withString:self.trip.name]];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:[self splitValueFrom:[WBPreferences defaultEmailRecipient]]];
    [mc setCcRecipients:[self splitValueFrom:[WBPreferences defaultEmailCC]]];
    [mc setBccRecipients:[self splitValueFrom:[WBPreferences defaultEmailBCC]]];

    for (NSString* path in createdAttachements) {
        NSData *fileData = [NSData dataWithContentsOfFile:path];
        
        if (fileData == nil) {
            NSLog(@"Failed reading file path: %@", path);
            return nil;
        }
        
        NSString *mimeType;
        if ([path hasSuffix:@"pdf"]) {
            mimeType = @"application/pdf";
        } else if ([path hasSuffix:@"csv"]) {
            mimeType = @"text/csv";
        } else {
            mimeType = @"application/octet-stream";
        }
        
        [mc addAttachmentData:fileData mimeType:mimeType fileName:[path lastPathComponent]];
    }

    return mc;
}

- (NSArray *)splitValueFrom:(NSString *)joined {
    return [joined componentsSeparatedByString:@","];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    if (error) {
        NSLog(@"Mail error: %@", [error localizedDescription]);
    }
    
    switch (result) {
            default:
        case MFMailComposeResultFailed:
        case MFMailComposeResultCancelled:
            [controller dismissViewControllerAnimated:YES completion:nil];
            break;
            
            case MFMailComposeResultSaved:
            case MFMailComposeResultSent:
            [controller dismissViewControllerAnimated:YES completion:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        
            break;
    }
    
    return;
}

- (IBAction)actionDone:(id)sender {
    
    if (!self.fullPdfReportField.on && !self.pdfImagesField.on && !self.csvFileField.on && !self.zipImagesField.on) {
        [self showAlertWithTitle:NSLocalizedString(@"generic.error.alert.title", nil)
                         message:NSLocalizedString(@"generate.report.no.options.selected.alert.message", nil)];
        return;
    }

    PendingHUDView *hud = [PendingHUDView showHUDOnView:self.navigationController.view];
    //start with a small delay, so that HUD can come up before processing begins
    SRDelayedExecution(0.5, ^{
        MFMailComposeViewController *mc = nil;
        @try {
            mc = [self preparedComposer];
        }
        @catch (NSException *exception) {
            mc = nil;
        }


        if (mc) {
            // forward our navbar tint color to mail composer
            [mc.navigationBar setTintColor:[UINavigationBar appearance].tintColor];

            // forward style, mail composer is so dumb and overrides our style
            UIStatusBarStyle barStyle = [UIApplication sharedApplication].statusBarStyle;

            [self presentViewController:mc animated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:barStyle];
            }];
        } else {
            [self showAlertWithTitle:NSLocalizedString(@"generic.error.alert.title", nil)
                             message:NSLocalizedString(@"generate.report.unsuccessful.alert.message", nil)];
        }

        [hud hide];
    });
}

- (IBAction)actionCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString*) title message:(NSString*) message {
    [[[UIAlertView alloc]
      initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"generic.button.title.ok",nil) otherButtonTitles:nil] show];
}

@end
