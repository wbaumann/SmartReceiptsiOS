//
//  TextEntryCell.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 30/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TextEntryCell.h"

@interface TextEntryCell ()

@property (nonatomic, strong) IBOutlet UITextField *entryField;

@end

@implementation TextEntryCell

- (NSString *)value {
    return [self.entryField text];
}

@end
