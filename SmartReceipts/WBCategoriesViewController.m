//
//  WBCategoriesViewController.m
//  SmartReceipts
//
//  Created on 14/03/14.
//  Copyright (c) 2014 Will Baumann. All rights reserved.
//

#import "WBCategoriesViewController.h"

#import "WBDB.h"

@interface WBCategoriesViewController ()
{
    NSMutableArray *_categories;
}
@end

@implementation WBCategoriesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.title = NSLocalizedString(@"Categories", nil);
    
    self.toolbarItems = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], self.editButtonItem];
    
    _categories = [[WBDB categories] selectAll].mutableCopy;
    [self sortCategoriesArray];
}

- (void) sortCategoriesArray
{
    [_categories sortUsingComparator:^NSComparisonResult(WBCategory* obj1, WBCategory* obj2) {
        return [[obj1 name] caseInsensitiveCompare:[obj2 name]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    WBCategory *category = [_categories objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [category name];
    cell.detailTextLabel.text = [category code];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBCategory *category = [_categories objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([[WBDB categories] deleteWithName:[category name]]) {
            [_categories removeObject:category];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.editing){
        [self performSegueWithIdentifier:@"CategoryCreator" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

-(void)viewController:(WBNewCategoryViewController *)viewController newCategory:(WBCategory *)category
{
    [_categories addObject:category];
    [self sortCategoriesArray];
    
    NSUInteger idx = [_categories indexOfObject:category];
    if (idx == NSNotFound) {
        return;
    }
    
    [self.categoriesTableView reloadData];
    
    [self.categoriesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)viewController:(WBNewCategoryViewController *)viewController updatedCategory:(WBCategory *)oldCategory toCategory:(WBCategory *)newCategory
{
    [_categories removeObject:oldCategory];
    [self viewController:viewController newCategory:newCategory];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CategoryCreator"]) {
        WBNewCategoryViewController* vc = (WBNewCategoryViewController*)[[segue destinationViewController] topViewController];
        vc.delegate = self;
        
        NSIndexPath *ip = [self.categoriesTableView indexPathForSelectedRow];
        if (ip && [sender isKindOfClass:[UITableViewCell class]]) {
            vc.category = [_categories objectAtIndex:ip.row];
        }
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.categoriesTableView setEditing:editing animated:animated];
}

@end
