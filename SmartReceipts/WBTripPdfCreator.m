//
//  WBTripPdfCreator.m
//  SmartReceipts
//
//  Created on 03/04/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBTripPdfCreator.h"
#import "WBPdfDrawer.h"
#import "WBDateFormatter.h"
#import "WBReceiptAndIndex.h"
#import "ReceiptColumn.h"

static inline NSString* safeString(NSString* str) {
    return str ? str : @"";
}

@implementation WBTripPdfCreator
{
    WBPdfDrawer *_pdfDrawer;
    WBDateFormatter *_dateFormatter;
    
    NSArray *_columns;
}

- (id)initWithColumns:(NSArray *)columns {
    self = [super init];
    if (self) {
        _columns = columns;
        _pdfDrawer = [[WBPdfDrawer alloc] init];
        _dateFormatter = [[WBDateFormatter alloc] init];
    }
    return self;
}

-(BOOL) createFullPdfFileAtPath:(NSString*) filePath receiptsAndIndexes:(NSArray*)receiptsAndIndexes trip:(WBTrip*) trip {
    if(![_pdfDrawer beginDrawingToFile:filePath]) return false;
    
    [_pdfDrawer drawRowText:[NSString stringWithFormat:@"%@  \u2022  %@",
                             [trip priceWithCurrencyFormatted], [trip name]]];
    
    [_pdfDrawer drawRowText:[NSString stringWithFormat:@"From: %@ To: %@",
                             [_dateFormatter formattedDate:[trip startDate] inTimeZone:[trip startTimeZone]],
                             [_dateFormatter formattedDate:[trip endDate] inTimeZone:[trip endTimeZone]]
                             ]];
    
    [_pdfDrawer drawRowText:[NSString stringWithFormat:@"Distance Traveled: %.2f",
                             [trip miles]]];
    
    [_pdfDrawer drawGap];
    
    // now generate table
    {
        // header
        NSMutableArray *array = @[].mutableCopy;
        for (Column *column in _columns) {
            [array addObject:safeString([column name])];
        }
        [_pdfDrawer drawRowBorderedTexts:array];
    }
    
    for (WBReceiptAndIndex *rwi in receiptsAndIndexes) {
        @autoreleasepool {
            WBReceipt *receipt = [rwi receipt];
            int index = [rwi index];
            
            NSMutableArray *array = @[].mutableCopy;
            for (ReceiptColumn* column in _columns) {
                NSString *val = [column valueFromReceipt:receipt forCSV:NO];
                [array addObject:safeString(val)];
            }
            
            [_pdfDrawer drawRowBorderedTexts:array];
        }
    }
    
    [self fillPdfWithImagesForTrip:trip receiptsAndIndexes:receiptsAndIndexes];
    
    [_pdfDrawer endDrawing];
    return true;
}

- (BOOL)createImagesPdfFileAtPath:(NSString *)filePath receiptsAndIndexes:(NSArray *)receiptsAndIndexes trip:(WBTrip *)trip {
    if(![_pdfDrawer beginDrawingToFile:filePath]) return false;
    
    [self fillPdfWithImagesForTrip:trip receiptsAndIndexes:receiptsAndIndexes];
    
    [_pdfDrawer endDrawing];
    return true;
}

-(void) fillPdfWithImagesForTrip:(WBTrip*) trip receiptsAndIndexes:(NSArray*)receiptsAndIndexes {
    NSMutableArray *awaitingFullPageImages = @[].mutableCopy;
    BOOL hitFirstNonFullPage = NO;
    
    for (WBReceiptAndIndex *rwi in receiptsAndIndexes) {
        @autoreleasepool {
            
            WBReceipt *receipt = [rwi receipt];
            int index = [rwi index];
            
            if ([receipt isFullPage] || [receipt hasPDFFileName]) {
                if (!hitFirstNonFullPage) {
                    [self drawFullPageReceipt:receipt withIndex:index inTrip:trip];
                } else {
                    [awaitingFullPageImages addObject:rwi];
                }
                continue;
            }
            
            if (![receipt hasImageForTrip:trip]) {
                continue;
            }
            
            UIImage *img = [UIImage imageWithContentsOfFile:[receipt imageFilePathForTrip:trip]];
            if (!img) {
                continue;
            }
            
            hitFirstNonFullPage = YES;
            
            [_pdfDrawer drawImage:img withLabel:[self labelForReceipt:receipt andIndex:index]];
        }
    }
    
    for (WBReceiptAndIndex *rwi in awaitingFullPageImages) {
        @autoreleasepool {
            [self drawFullPageReceipt:[rwi receipt] withIndex:[rwi index] inTrip:trip];
        }
    }
}

-(NSString*) labelForReceipt:(WBReceipt*) receipt andIndex:(int)index {
    return [NSString stringWithFormat:@"%d  \u2022  %@  \u2022  %@",
            index,
            [receipt name],
            [_dateFormatter formattedDate:[receipt dateFromDateMs] inTimeZone:[receipt timeZone]]];
}

-(void) drawFullPageReceipt:(WBReceipt*)receipt withIndex:(int)index inTrip:(WBTrip*)trip {
    
    if ([receipt hasImageForTrip:trip]) {
        UIImage *img = [UIImage imageWithContentsOfFile:[receipt imageFilePathForTrip:trip]];
        if (img) {
            [_pdfDrawer drawFullPageImage:img withLabel:[self labelForReceipt:receipt andIndex:index]];
        }
    } else if ([receipt hasPDFForTrip:trip]) {
        [self drawFullPagePDFFile:[receipt imageFilePathForTrip:trip] withLabel:[self labelForReceipt:receipt andIndex:index]];
    }
    
}

-(void) drawFullPagePDFFile:(NSString*)filePath withLabel:(NSString*) label {
    NSURL *url = [NSURL fileURLWithPath:filePath];
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithURL((CFURLRef)url);
	
    if (pdf == nil) {
        return;
    }
    
    @autoreleasepool {
        for (int i = 0; i < CGPDFDocumentGetNumberOfPages(pdf); ++i) {
            CGPDFPageRef page = CGPDFDocumentGetPage(pdf, i + 1);
            [_pdfDrawer drawFullPagePDFPage:page withLabel:label];
        }
    }

	CGPDFDocumentRelease(pdf);
}

@end
