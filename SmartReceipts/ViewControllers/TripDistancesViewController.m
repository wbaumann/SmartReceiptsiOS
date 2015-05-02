//
//  TripDistancesViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 29/04/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "TripDistancesViewController.h"
#import "WBTrip.h"
#import "AddDistanceViewController.h"
#import "DistanceSummaryCell.h"
#import "UIView+LoadHelpers.h"
#import "Database.h"
#import "Database+Distances.h"
#import "Distance.h"
#import "WBDateFormatter.h"
#import "WBPrice.h"

static NSString *const PushDistanceAddViewControllerSegue = @"PushDistanceAddViewControllerSegue";

@interface TripDistancesViewController ()

@property (nonatomic, strong) WBDateFormatter *dateFormatter;
@property (nonatomic, assign) CGFloat maxRateWidth;

@end

@implementation TripDistancesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationItem setTitle:NSLocalizedString(@"Distances", nil)];

    [self setDateFormatter:[[WBDateFormatter alloc] init]];

    [self setPresentationCellNib:[DistanceSummaryCell viewNib]];
    [self.tableView setRowHeight:78];
}

- (NSArray *)fetchPresentedObjects {
    return [[Database sharedInstance] fetchAllDistancesForTrip:self.trip];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    DistanceSummaryCell *summaryCell = (DistanceSummaryCell *) cell;
    Distance *distance = object;
    WBPrice *rate = distance.rate;
    summaryCell.rateLabel.text = rate.currencyFormattedPrice;
    summaryCell.destinationLabel.text = distance.location;
    summaryCell.totalLabel.text = distance.totalRate.currencyFormattedPrice;
    summaryCell.dateLabel.text = [self.dateFormatter formattedDate:distance.date inTimeZone:distance.timeZone];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([PushDistanceAddViewControllerSegue isEqualToString:segue.identifier]) {
        AddDistanceViewController *controller = [segue destinationViewController];
        [controller setTrip:self.trip];
    }
}

- (IBAction)done {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)contentChanged {
    self.maxRateWidth = [self findMaxRateWidth];

    for (DistanceSummaryCell *cell in self.tableView.visibleCells) {
        [cell setPriceLabelWidth:self.maxRateWidth];
    }
}

- (CGFloat)findMaxRateWidth {
    CGFloat max = 0;
    for (NSUInteger row = 0; row < self.numberOfItems; row++) {
        Distance *distance = [self objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        NSString *rateString = distance.rate.currencyFormattedPrice;
        CGRect bounds = [rateString boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesDeviceMetrics attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:21]} context:nil];
        max = MAX(max, CGRectGetWidth(bounds) + 10);
    }
    
    return max;
}

@end
