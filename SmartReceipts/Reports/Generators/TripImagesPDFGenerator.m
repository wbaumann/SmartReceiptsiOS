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
#import "PrettyPDFRender.h"

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
    if (![self.pdfRender setOutputPath:outputPath]) {
        return NO;
    }

    [self appendImages];

    [self.pdfRender renderPages];

    return YES;
}

- (void)appendImages {
    [self fillPdfWithImagesUsingReceipts:[self receipts]];
}

- (void)fillPdfWithImagesUsingReceipts:(NSArray *)receipts {
    NSMutableArray *awaitingFullPageImages = [NSMutableArray array];
    BOOL hitFirstNonFullPage = NO;

    for (WBReceipt *receipt in receipts) {
        @autoreleasepool {
            if ([receipt isFullPage] || [receipt hasPDFFileName]) {
                if (!hitFirstNonFullPage) {
                    [self drawFullPageReceipt:receipt];
                } else {
                    [awaitingFullPageImages addObject:receipt];
                }
                continue;
            }

            if (![receipt hasImage]) {
                continue;
            }

            UIImage *img = [UIImage imageWithContentsOfFile:[receipt imageFilePathForTrip:receipt.trip]];
            if (!img) {
                continue;
            }

            hitFirstNonFullPage = YES;

            [self.pdfRender appendImage:img withLabel:[self labelForReceipt:receipt]];
        }
    }

    for (WBReceipt *receipt in awaitingFullPageImages) {
        @autoreleasepool {
            [self drawFullPageReceipt:receipt];
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
            [self.pdfRender appendFullPageImage:img withLabel:[self labelForReceipt:receipt]];
        }
    } else if ([receipt hasPDF]) {
        [self drawFullPagePDFFile:[receipt imageFilePathForTrip:receipt.trip] withLabel:[self labelForReceipt:receipt]];
    }

}

- (void)drawFullPagePDFFile:(NSString *)filePath withLabel:(NSString *)label {
    NSURL *url = [NSURL fileURLWithPath:filePath];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef) url);

    if (pdf == nil) {
        return;
    }

    @autoreleasepool {
        for (NSUInteger i = 0; i < CGPDFDocumentGetNumberOfPages(pdf); ++i) {
            CGPDFPageRef page = CGPDFDocumentGetPage(pdf, i + 1);
            [self.pdfRender appendPDFPage:page withLabel:label];
        }
    }

    CGPDFDocumentRelease(pdf);
}

@end
