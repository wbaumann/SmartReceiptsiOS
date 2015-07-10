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

@interface PrettyPDFRender ()

@property (nonatomic, strong) NSMutableArray *pages;
@property (nonatomic, strong) PDFPage *openPage;
@property (nonatomic, strong) TripReportHeader *header;

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
    return UIGraphicsBeginPDFContextToFile(path, CGRectMake(0, 0, 595, 842), nil);
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
        _openPage = [PDFPage loadInstance];
        [self.pages addObject:_openPage];
    }

    return _openPage;
}


@end
