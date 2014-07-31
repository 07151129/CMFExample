//
//  MasterViewController.m
//  CMFExample
//
//  Created by Pb on 31/07/14.
//  Copyright (c) 2014 Pb. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end


@implementation MasterViewController

-(void)updateBlockList{
    
    if (!self.cfBlockList) {
        return;
    }
    self.blockList = [[self.cfBlockList copyAllItems] mutableCopy];
}

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.cfBlockList = objc_msgSend(objc_getClass("CommunicationsFilterBlockList"), sel_getUid("alloc"));
    self.cfBlockList = [self.cfBlockList init];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blockListDidChange:) name:CMFBlockListUpdatedNotification object:nil];
    
    [self updateBlockList];
}

-(void)blockListDidChange:(NSNotification *)notification{
    
    NSLog(@"blockListDidChange");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.blockList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMFItemCell" forIndexPath:indexPath];

    CommunicationFilterItem *item = [self.blockList objectAtIndex:indexPath.row];
    
    if ([item isPhoneNumber]) {
        cell.textLabel.text = [[item dictionaryRepresentation] objectForKey:(__bridge NSString *)kCMFItemPhoneNumberUnformattedKey];
        cell.detailTextLabel.text = [[item dictionaryRepresentation] objectForKey:(__bridge NSString *)kCMFItemPhoneNumberCountryCodeKey];
    }
    else{
        cell.textLabel.text = [[item dictionaryRepresentation] objectForKey:(__bridge NSString *)kCMFItemEmailUnformattedKey];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.cfBlockList removeItemForAllServices:[self.blockList objectAtIndex:indexPath.row]];
        [self updateBlockList];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailViewController.detailItem = [self.blockList objectAtIndex:indexPath.row];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.blockList[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
    
    
    if ([[segue identifier] isEqualToString:@"addNumber"]) {
        
        ((AddNumberViewController *)[segue destinationViewController]).delegate = self;
    }
}

-(void)addNumber:(NSString *)number{
    
    CommunicationFilterItem *itm = CreateCMFItemFromString((__bridge CFStringRef)number);
    [self.cfBlockList addItemForAllServices:itm];
    [self updateBlockList];
}

@end
