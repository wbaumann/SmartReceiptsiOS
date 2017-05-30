//
//  WBPopoverPicker.m
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBActionSheetPicker.h"

@implementation WBActionSheetPicker {
    UILabel *titleLabel;
    // UIActionSheet *actionSheet;
    UIView *actionView;
    UIViewController *_viewController;
    UIView *_rootView;
}

- (id)initAsDatePicker:(BOOL) asDatePicker withController:(UIViewController*) vc {
    self = [super init];
    if (self) {
        _viewController = vc;
        
        int w = _viewController.view.bounds.size.width;
        
        UIView *rootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, 415)];
        UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:@""];
        [rootView addSubview:pickerToolbar];
        CGRect pickerFrame = CGRectMake(0, 44, w, 415 - 44);
        
        if (asDatePicker) {
            UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
            self.datePicker = datePicker;
            datePicker.datePickerMode = UIDatePickerModeDate;
            datePicker.date = [NSDate date];
            [rootView addSubview:datePicker];
        } else {
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
            self.pickerView = pickerView;
            [pickerView setShowsSelectionIndicator:YES];
            [rootView addSubview:pickerView];
        }
        
        _rootView = rootView;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    titleLabel.text = title;
}

- (void)showPickerFromView:(UIView*) view {
    [self removePopoverAnimated:NO];
    [_viewController.view endEditing:YES];
    [self.pickerView reloadComponent:0];
    
    float width = _rootView.frame.size.width;
    float height = _rootView.frame.size.height;
    
    actionView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, width, height)];
    actionView.backgroundColor = [UIColor whiteColor];
    [actionView addSubview:_rootView];

    [UIView animateWithDuration:0.2 animations:^{
        float y = [UIScreen mainScreen].bounds.size.height - 108; // 88 for the two button bars + 20px
        if (self.pickerView) {
            y -= self.pickerView.frame.size.height;
        }
        else if (self.datePicker) {
            y -= self.datePicker.frame.size.height;
        }
        
        actionView.frame = CGRectMake(0, y, width, height);
    }];
    [_viewController.view addSubview:actionView];
    
}

- (void)showPickerFromBarButtonItem:(UIBarButtonItem*) barButtonItem {
    [self showPickerFromView:nil];
}

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title {
    int w = _viewController.view.bounds.size.width;
    CGRect frame = CGRectMake(0, 0, w, 44);
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleDefault;
    pickerToolbar.barTintColor = [UIColor whiteColor];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    [barItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel:)]];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    
    if (title){
        UIBarButtonItem *labelButton = [self createToolbarLabelWithTitle:title];
        [barItems addObject:labelButton];
        [barItems addObject:flexSpace];
    }
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)];
    [barItems addObject:doneButton];
    
    [pickerToolbar setItems:barItems animated:YES];
    return pickerToolbar;
}

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)aTitle {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100,30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    label.backgroundColor = [UIColor clearColor];
    label.text = aTitle;
    titleLabel = label;
    UIBarButtonItem *buttonLabel = [[UIBarButtonItem alloc]initWithCustomView:label];
    return buttonLabel;
}

- (void)actionPickerDone:(id)sender {
    [self removePopoverAnimated:YES];
    [self.delegate abstractPickerDone:self];
}

- (void)actionPickerCancel:(id)sender {
    [self removePopoverAnimated:YES];
    [self.delegate abstractPickerCancel:self];
}

- (void)removePopoverAnimated:(BOOL) animated {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            actionView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height,
                                          _rootView.frame.size.width, _rootView.frame.size.height);
        }
        completion:^(BOOL finished) {
            [actionView removeFromSuperview];
            actionView = nil;
        }];
    }
    else {
        [actionView removeFromSuperview];
        actionView = nil;
    }
}

@end
