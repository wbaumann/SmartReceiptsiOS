//
//  FetchedCollectionTableViewController.m
//  SmartReceipts
//
//  Created by Jaanus Siim on 02/05/15.
//  Copyright (c) 2015 Will Baumann. All rights reserved.
//

#import "FetchedCollectionTableViewController.h"
#import "WBAppDelegate.h"
#import "Constants.h"
#import "FetchedModelAdapter.h"
#import "PendingHUDView.h"

NSString *const FetchedCollectionTableViewControllerCellIdentifier = @"FetchedCollectionTableViewControllerCellIdentifier";

@interface FetchedCollectionTableViewController ()

@property (nonatomic, strong) FetchedModelAdapter *presentedObjects;
@property (nonatomic, strong) FetchedPlaceholderView *placeholderView;

@end

@implementation FetchedCollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setEstimatedRowHeight:40];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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
    [self checkNeedsPlaceholder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkNeedsPlaceholder];
}

- (void)setPresentedObjects:(FetchedModelAdapter *)presentedObjects {
    _presentedObjects = presentedObjects;
    [self checkNeedsPlaceholder];
}

- (void)checkNeedsPlaceholder {
    self.presentedObjects.allObjects.count > 0 ? [self hidePlaceholder] : [self showPlaceholder];
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
    LOGGER_DEBUG(@"configureCell:atIndexPath:%@", indexPath);
}

- (void)contentChanged {
    LOGGER_DEBUG(@"contentChanged");
}

- (void)fetchObjects {
    PendingHUDView *hud = [PendingHUDView showHUDOnView:self.navigationController ? self.navigationController.view : self.view];
    __weak typeof(self) wSelf = self;
    dispatch_async([[WBAppDelegate instance] dataQueue], ^{
        FetchedModelAdapter *objects = [wSelf createFetchedModelAdapter];
        [objects setDelegate:wSelf];
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf setPresentedObjects:objects];
            [wSelf.tableView reloadData];
            [wSelf contentChanged];
            [hud hide];
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

- (void)showPlaceholder {
    LOGGER_DEBUG(@"showPlacehoder");
    [self.placeholderView removeFromSuperview];
    if (self.placeholderTitle) {
        self.placeholderView = [[FetchedPlaceholderView alloc] initWithFrame:self.tableView.frame
                                                        title:self.placeholderTitle];
        [self.view.superview addSubview:self.placeholderView];
    }
}

- (void)hidePlaceholder {
    LOGGER_DEBUG(@"hidePlacehoder");
    [self.placeholderView removeFromSuperview];
    self.placeholderView = nil;
}

- (void)willChangeContent {
    LOGGER_DEBUG(@"willChangeContent");
    [self.tableView beginUpdates];
}

- (void)didInsertObject:(id)object atIndex:(NSUInteger)index {
    LOGGER_DEBUG(@"didInsertObject:atIndex:%tu", index);
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didDeleteObject:(id)object atIndex:(NSUInteger)index {
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didUpdateObject:(id)object atIndex:(NSUInteger)index {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didMoveObject:(id)object fromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:fromIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:toIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didChangeContent {
    LOGGER_DEBUG(@"didChangeContent");
    [self.tableView endUpdates];
    [self contentChanged];
    [self checkNeedsPlaceholder];
}

- (void)reloadData {
    [self.tableView reloadData];
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
    LOGGER_DEBUG(@"deleteObject:atIndexPath:%@", indexPath);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id tapped = [self objectAtIndexPath:indexPath];
    [self tappedObject:tapped atIndexPath:indexPath];
}

- (void)tappedObject:(id)tapped atIndexPath:(NSIndexPath *)indexPath {
    LOGGER_DEBUG(@"tappedObject:atIndexPath:%@", indexPath);
}

- (NSUInteger)indexOfObject:(id)object {
    return [self.presentedObjects indexForObject:object];
}

- (NSArray *)allObjects {
    return self.presentedObjects.allObjects;
}

@end
