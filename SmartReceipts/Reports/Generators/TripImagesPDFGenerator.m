//
//  TripImagesPDFGenerator.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TripImagesPDFGenerator.h"
#import "WBTrip.h"
#import "WBReceipt.h"
#import "WBDateFormatter.h"
#import "Database.h"
#import "WBPreferences.h"
#import "NSString+Validation.h"
#import <SmartReceipts-Swift.h>

@interface TripImagesPDFGenerator ()

@property (nonatomic, strong) WBDateFormatter *dateFormatter;
@property (nonatomic, strong) PrettyPDFRender *pdfRender;

@end

@implementation TripImagesPDFGenerator

- (instancetype)initWithTrip:(WBTrip *)trip database:(Database *)database {
    self = [super initWithTrip:trip database:database];
    if (self) {
        _dateFormatter = [[WBDateFormatter alloc] init];
        _pdfRender = [[PrettyPDFRender alloc] init];
    }

    return self;
}


- (BOOL)generateToPath:(NSString *)outputPath {
    if (![self.pdfRender setOutputWithPath:outputPath]) {
        LOGGER_WARNING(@"generateToPath returned false. Path %@", outputPath);
        return NO;
    }

    [self appendImages];
    BOOL result = [self.pdfRender renderPages];
    return result;
}

- (void)appendImages {
    [self fillPdfWithImagesUsingReceipts:[self receipts]];
}

- (void)fillPdfWithImagesUsingReceipts:(NSArray *)receipts {
    for (WBReceipt *receipt in receipts) {
        @autoreleasepool {
            if ([receipt isFullPage] || [receipt hasPDFFileName]) {
                    [self drawFullPageReceipt:receipt];
            } else if ([receipt hasImage]) {
                UIImage *img = [UIImage imageWithContentsOfFile:[receipt imageFilePathForTrip:receipt.trip]];
                if (img) {
                    [self.pdfRender appendWithImage:img label:[self labelForReceipt:receipt]];
                } else {
                    LOGGER_WARNING(@"Receipt-%@ hasImage=TRUE, but no image", receipt.name);
                }
            }
        }
    }
}

- (NSString *)labelForReceipt:(WBReceipt *)receipt {
    NSMutableString *photoLabel = [NSMutableString string];
    NSUInteger usedID = [WBPreferences printReceiptIDByPhoto] ? receipt.objectId : receipt.reportIndex;
    [photoLabel appendFormat:@"%tu", usedID];
    [photoLabel appendFormat:@" \u2022  %@", [receipt name]];
    [photoLabel appendFormat:@" \u2022  %@", [self.dateFormatter formattedDate:[receipt date] inTimeZone:[receipt timeZone]]];
    if ([WBPreferences printCommentByPhoto] && receipt.comment.hasValue) {
        [photoLabel appendFormat:@" \u2022  %@", receipt.comment];
    }
    return [NSString stringWithString:photoLabel];
}

- (void)drawFullPageReceipt:(WBReceipt *)receipt {
    if ([receipt hasImage]) {
        UIImage *img = [UIImage imageWithContentsOfFile:[receipt imageFilePathForTrip:receipt.trip]];
        if (img) {
            [self.pdfRender appendFullPageWithImage:img label:[self labelForReceipt:receipt]];
        } else {
            LOGGER_WARNING(@"drawFullPageReceipt: Receipt-%@ hasImage=TRUE, but no image", receipt.name);
        }
    } else if ([receipt hasPDF]) {
        [self drawFullPagePDFFile:[receipt imageFilePathForTrip:receipt.trip] withLabel:[self labelForReceipt:receipt]];
    } else {
        LOGGER_WARNING(@"drawFullPageReceipt: Receipt-%@ hasImage && hasPDF = FLASE", receipt.name);
    }

}

- (void)drawFullPagePDFFile:(NSString *)filePath withLabel:(NSString *)label {
    NSURL *url = [NSURL fileURLWithPath:filePath];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef) url);

    if (pdf == nil) {
        LOGGER_ERROR(@"drawFullPagePDFFile: pdf is nil, for path:%@", filePath);
        return;
    }
    
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(pdf);
    if (numberOfPages > 10) {
        LOGGER_WARNING(@"Too many pages (%zu) for %@", numberOfPages, label);
    }

    @autoreleasepool {
        for (NSUInteger i = 0; i < numberOfPages; ++i) {
            CGPDFPageRef page = CGPDFDocumentGetPage(pdf, i + 1);
            [self.pdfRender appendPDFWithPage:page label:label];
        }
    }

    CGPDFDocumentRelease(pdf);
}

@end
