//
//  WBCategoriesViewController.m
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBCategoriesViewController.h"
#import "WBDB.h"
#import "WBCustomization.h"
#import "WBNewCategoryViewController.h"
#import "CategoryCell.h"
#import "UIView+LoadHelpers.h"
#import "FetchedModelAdapter.h"
#import "Database+Categories.h"

@interface WBCategoriesViewController ()

@property (nonatomic, strong) WBCategory *tapped;
@property (nonatomic, strong) WBCategory *added;

@end

@implementation WBCategoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [WBCustomization customizeOnViewDidLoad:self];

    [self setPresentationCellNib:[CategoryCell viewNib]];

    self.navigationItem.title = NSLocalizedString(@"Categories", nil);

    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], self.editButtonItem];
}

- (FetchedModelAdapter *)createFetchedModelAdapter {
    return [[Database sharedInstance] fetchedAdapterForCategories];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    CategoryCell *cCell = (CategoryCell *) cell;
    WBCategory *category = object;
    [cCell.textLabel setText:category.name];
    [cCell.detailTextLabel setText:category.code];
}

- (void)deleteObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    WBCategory *category = object;
    [[Database sharedInstance] deleteCategory:category];
}

- (void)tappedObject:(id)tapped atIndexPath:(NSIndexPath *)indexPath {
    [self setTapped:tapped];

    if (self.editing) {
        [self performSegueWithIdentifier:@"CategoryCreator" sender:nil];
    }
}

- (void)didInsertObject:(id)object atIndex:(NSUInteger)index {
    [super didInsertObject:object atIndex:index];
    
    [self setAdded:object];
}

- (void)contentChanged{
    if (!self.added) {
        return;
    }

    NSUInteger index = [self indexOfObject:self.added];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"CategoryCreator"]) {
        WBNewCategoryViewController *vc = (WBNewCategoryViewController *) [[segue destinationViewController] topViewController];
        vc.category = self.tapped;
    }

    [self setTapped:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

@end
