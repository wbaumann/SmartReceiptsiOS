//
//  FetchedCollectionTableViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "FetchedCollectionTableViewController.h"
#import "HUD.h"
#import "WBAppDelegate.h"
#import "Constants.h"

NSString *const FetchedCollectionTableViewControllerCellIdentifier = @"FetchedCollectionTableViewControllerCellIdentifier";

@interface FetchedCollectionTableViewController ()

@property (nonatomic, strong) NSArray *presentedObjects;

@end

@implementation FetchedCollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.presentedObjects) {
        [self fetchObjects];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfItems];
}

- (void)setPresentationCellNib:(UINib *)nib {
    [self.tableView registerNib:nib forCellReuseIdentifier:FetchedCollectionTableViewControllerCellIdentifier];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FetchedCollectionTableViewControllerCellIdentifier];
    id object = self.presentedObjects[indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:object];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    SRLog(@"configureCell:atIndexPath:%@", indexPath);
}

- (void)contentChanged {
    SRLog(@"contentChanged");
}

- (void)fetchObjects {
    [HUD showUIBlockingIndicatorWithText:@""];
    dispatch_async([[WBAppDelegate instance] dataQueue], ^{
        NSArray *objects = [self fetchPresentedObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setPresentedObjects:objects];
            [self.tableView reloadData];
            [self contentChanged];
            [HUD hideUIBlockingIndicator];
        });
    });
}

- (NSArray *)fetchPresentedObjects {
    ABSTRACT_METHOD
    return nil;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.presentedObjects[indexPath.row];
}

- (NSUInteger)numberOfItems {
    return self.presentedObjects.count;
}

@end
