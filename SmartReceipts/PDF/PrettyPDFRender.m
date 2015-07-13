//
//  PrettyPDFRender.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 09/07/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "PrettyPDFRender.h"
#import "PDFPage.h"
#import "UIView+LoadHelpers.h"
#import "TripReportHeader.h"
#import "PDFReportTable.h"
#import "PDFImageView.h"

NSUInteger const SRMinNumberOfTableRowsForPage = 3;

@interface PDFReportTable (Expose)

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, assign) NSUInteger rowToStart;

@end

@interface PDFPage (Expose)

@property (nonatomic, assign) NSUInteger imageIndex;

@end

@interface PrettyPDFRender ()

@property (nonatomic, strong) NSMutableArray *pages;
@property (nonatomic, strong) PDFPage *openPage;
@property (nonatomic, strong) TripReportHeader *header;
@property (nonatomic, strong) PDFReportTable *openTable;

@end

@implementation PrettyPDFRender

- (instancetype)init {
    self = [super init];
    if (self) {
        _pages = [NSMutableArray array];
    }

    return self;
}

- (BOOL)setOutputPath:(NSString *)path {
    return UIGraphicsBeginPDFContextToFile(path, self.openPage.bounds, nil);
}

- (void)setTripName:(NSString *)tripName {
    [self.header setTripName:tripName];
}

- (void)appendHeaderRow:(NSString *)row {
    [self.header appendRow:row];
}

- (void)closeHeader {
    [self.openPage appendHeader:self.header];
}

- (void)renderPages {
    for (PDFPage *page in self.pages) {
        UIGraphicsBeginPDFPage();
        CGContextRef pdfContext = UIGraphicsGetCurrentContext();
        [page.layer renderInContext:pdfContext];
    }

    UIGraphicsEndPDFContext();
}

- (TripReportHeader *)header {
    if (!_header) {
        _header = [TripReportHeader loadInstance];
    }

    return _header;
}

- (PDFPage *)openPage {
    if (!_openPage) {
        [self startNextPage];
    }

    return _openPage;
}


- (void)startTable {
    self.openTable = [PDFReportTable loadInstance];
    [self.openTable setFrame:CGRectMake(0, 0, CGRectGetWidth(self.header.frame), 100)];
}

- (void)appendTableHeaders:(NSArray *)columnNames {
    [self.openTable setColumns:columnNames];
}

- (void)appendTableColumns:(NSArray *)rowValues {
    [self.openTable appendValues:rowValues];
}

- (void)closeTable {
    BOOL fullyAdded = [self.openTable buildTable:[self.openPage remainingSpace]];
    [self.openPage appendTable:self.openTable];

    if (fullyAdded) {
        return;
    }

    PDFReportTable *partialTable = self.openTable;

    NSUInteger remainder = partialTable.rows.count - partialTable.rowsAdded;
    if (partialTable.rowToStart == 0 && (partialTable.rowsAdded < SRMinNumberOfTableRowsForPage || remainder < SRMinNumberOfTableRowsForPage)) {
        [self.openTable removeFromSuperview];
        [self startNextPage];
        [self.openTable setRowToStart:partialTable.rowsAdded];
        [self closeTable];
        return;
    }

    [self startNextPage];
    [self startTable];
    [self.openTable setColumns:partialTable.columns];
    [self.openTable setRows:partialTable.rows];
    [self.openTable setRowToStart:partialTable.rowsAdded];
    [self closeTable];
}

- (void)startNextPage {
    self.openPage = [PDFPage loadInstance];
    [self.pages addObject:self.openPage];
}

- (void)appendImage:(UIImage *)image withLabel:(NSString *)label {
    if (self.openPage.imageIndex == 4) {
        [self startNextPage];
    }

    PDFImageView *imageView = [PDFImageView loadInstance];
    [imageView.titleLabel setText:label];
    [imageView.imageView setImage:image];
    [imageView fitImageView];

    [self.openPage appendImage:imageView];
}

@end
