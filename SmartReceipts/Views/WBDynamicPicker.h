//
//  WBAutoPicker.h
//  SmartReceipts
//
//  Created on 18/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBAbstractPicker.h"

typedef enum WBDynamicPickerType {
    WBDynamicPickerTypePicker,
    WBDynamicPickerTypeDate
} WBDynamicPickerType;

@class WBDynamicPicker;

@protocol WBDynamicPickerDelegate <NSObject>

@optional
-(void) dynamicPicker:(WBDynamicPicker*) picker doneWith:(id) subject;

-(NSString*) dynamicPicker:(WBDynamicPicker*) picker titleForRow:(NSInteger) row;
-(NSInteger) dynamicPickerNumberOfRows:(WBDynamicPicker*) picker;

@end

/*
 * Class that uses proper way to display picker depending on device type.
 */

@interface WBDynamicPicker : NSObject<WBAbstractPickerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(weak,nonatomic) id<WBDynamicPickerDelegate> delegate;
@property int tag;

- (id)initWithType:(WBDynamicPickerType) type withController:(UIViewController*) vc;

- (void)setTitle:(NSString*)title;

- (void)showFromView:(UIView*) view;
- (void)showFromBarButtonItem:(UIBarButtonItem*) barButtonItem;

- (void)setSelectedRow:(NSInteger) row;
- (void)setDate:(NSDate*) date;

- (NSInteger) selectedRow;
- (NSDate*) selectedDate;

@end
