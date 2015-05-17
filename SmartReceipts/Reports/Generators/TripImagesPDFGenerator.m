//
//  TripImagesPDFGenerator.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TripImagesPDFGenerator.h"
#import "WBTrip.h"
#import "WBPdfDrawer.h"
#import "WBReceipt.h"
#import "WBDateFormatter.h"
#import "Database.h"

@interface TripImagesPDFGenerator ()

@property (nonatomic, strong) WBPdfDrawer *pdfDrawer;
@property (nonatomic, strong) WBDateFormatter *dateFormatter;

@end

@implementation TripImagesPDFGenerator

- (instancetype)initWithTrip:(WBTrip *)trip database:(Database *)database {
    self = [super initWithTrip:trip database:database];
    if (self) {
        _pdfDrawer = [[WBPdfDrawer alloc] init];
        _dateFormatter = [[WBDateFormatter alloc] init];
    }

    return self;
}


- (BOOL)generateToPath:(NSString *)outputPath {
    if (![self.pdfDrawer beginDrawingToFile:outputPath]) {
        return NO;
    }

    [self appendImages];

    [self.pdfDrawer endDrawing];

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

            [self.pdfDrawer drawImage:img withLabel:[self labelForReceipt:receipt]];
        }
    }

    for (WBReceipt *receipt in awaitingFullPageImages) {
        @autoreleasepool {
            [self drawFullPageReceipt:receipt];
        }
    }
}

- (NSString *)labelForReceipt:(WBReceipt *)receipt {
    return [NSString stringWithFormat:@"%ld  \u2022  %@  \u2022  %@",
                                      (long)receipt.reportIndex,
                                      [receipt name],
                                      [self.dateFormatter formattedDate:[receipt dateFromDateMs] inTimeZone:[receipt timeZone]]];
}

- (void)drawFullPageReceipt:(WBReceipt *)receipt {
    if ([receipt hasImage]) {
        UIImage *img = [UIImage imageWithContentsOfFile:[receipt imageFilePathForTrip:receipt.trip]];
        if (img) {
            [self.pdfDrawer drawFullPageImage:img withLabel:[self labelForReceipt:receipt]];
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
            [self.pdfDrawer drawFullPagePDFPage:page withLabel:label];
        }
    }

    CGPDFDocumentRelease(pdf);
}

@end
