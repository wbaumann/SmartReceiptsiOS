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
#import "FetchedModelAdapter.h"
#import "FetchedModelAdapterDelegate.h"

NSString *const FetchedCollectionTableViewControllerCellIdentifier = @"FetchedCollectionTableViewControllerCellIdentifier";

@interface FetchedCollectionTableViewController () <FetchedModelAdapterDelegate>

@property (nonatomic, strong) FetchedModelAdapter *presentedObjects;

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
    id object = [self objectAtIndexPath:indexPath];
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
        FetchedModelAdapter *objects = [self createFetchedModelAdapter];
        [objects setDelegate:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setPresentedObjects:objects];
            [self.tableView reloadData];
            [self contentChanged];
            [HUD hideUIBlockingIndicator];
        });
    });
}

- (FetchedModelAdapter *)createFetchedModelAdapter {
    ABSTRACT_METHOD
    return nil;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.presentedObjects objectAtIndex:indexPath.row];
}

- (NSUInteger)numberOfItems {
    return self.presentedObjects.numberOfObjects;
}

- (void)willChangeContent {
    [self.tableView beginUpdates];
}

- (void)didInsertObject:(id)object atIndex:(NSUInteger)index {
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didDeleteObject:(id)object atIndex:(NSUInteger)index {
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didChangeContent {
    [self.tableView endUpdates];
    [self contentChanged];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id model = [self objectAtIndexPath:indexPath];
        [self deleteObject:model atIndexPath:indexPath];
    }
}

- (void)deleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    SRLog(@"deleteObject:atIndexPath:%@", indexPath);
}

@end
