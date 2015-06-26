//
//  WBPreferencesImportExportTest.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 26/06/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SmartReceiptsTestsBase.h"
#import "WBPreferences.h"

@interface WBPreferencesImportExportTest : SmartReceiptsTestsBase

@end

@implementation WBPreferencesImportExportTest

- (void)testEmailsImport {
    NSString *testXML = @"<?xml version='1.0' encoding='utf-8' standalone='yes' ?>\n"
            "<map>\n"
            "    <string name=\"EmailTo\">one@one.com; two@two.com</string>\n"
            "    <string name=\"EmailCC\">three@three.com; three@three.com</string>\n"
            "    <string name=\"EmailBCC\">four@four.com;four@four.com</string>\n"
            "</map>";

    [WBPreferences setFromXmlString:testXML];

    XCTAssertEqualObjects(@"one@one.com, two@two.com", [WBPreferences defaultEmailRecipient]);
    XCTAssertEqualObjects(@"three@three.com, three@three.com", [WBPreferences defaultEmailCC]);
    XCTAssertEqualObjects(@"four@four.com,four@four.com", [WBPreferences defaultEmailBCC]);
}

- (void)testEmailsExport {
    [WBPreferences setDefaultEmailRecipient:@"a@a.com,b@b.com"];
    [WBPreferences setDefaultEmailCC:@"c@c.com, d@d.com"];
    [WBPreferences setDefaultEmailBCC:@"e@e.com, f@f.com"];

    NSString *export = [WBPreferences xmlString];
    XCTAssertNotEqual(NSNotFound, [export rangeOfString:@"a@a.com;b@b.com"].location);
    XCTAssertNotEqual(NSNotFound, [export rangeOfString:@"c@c.com; d@d.com"].location);
    XCTAssertNotEqual(NSNotFound, [export rangeOfString:@"e@e.com; f@f.com"].location);
}

@end
