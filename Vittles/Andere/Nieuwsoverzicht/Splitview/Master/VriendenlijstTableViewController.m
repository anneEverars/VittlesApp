//
//  VriendenlijstTableViewController.m
//  Vittles
//
//  Created by Anne Everars on 23/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "VriendenlijstTableViewController.h"
#import "VriendProfielViewController.h"
#import "NieuwsTabController.h"
#import "CustomCell.h"
#import <Parse/Parse.h>

@interface VriendenlijstTableViewController () {
    NSMutableArray *_objects;
    NSString *login;
}

@end

@implementation VriendenlijstTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.splitViewController setDelegate:self];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //****Gebruiker****
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    //****Vriendenlijst
    _objects = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:login];
    [query whereKey:@"type" equalTo:@"friend"];
    [query selectKeys:@[@"Naam"]];
    NSArray *results = [query findObjects];
    for(PFObject *resultaat in results) {
        [_objects addObject:[resultaat objectForKey:@"Naam"]];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"vriendenCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    NSString *username = [_objects objectAtIndex:indexPath.row];
    cell.textLabel.text = username;
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:username];
    NSArray *results = [query findObjects];
    PFObject *user = [results objectAtIndex:0];
    PFFile *theImage = [user objectForKey:@"ProfilePic"];
    if(theImage) {
        NSData *imageData = [theImage getData];
        UIImage *image = [UIImage imageWithData:imageData];
        cell.imageView.image = image;
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"profilePicture.png"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIStoryboard *storyboard = [self storyboard];
        VriendProfielViewController *newController = [storyboard instantiateViewControllerWithIdentifier:@"VriendProfiel"];
        UINavigationController *navController = [[[self splitViewController ] viewControllers ] lastObject ];
        NieuwsTabController *oldController = [[navController viewControllers] firstObject];
        NSArray *newStack = [NSArray arrayWithObjects:newController, nil];
        [navController setViewControllers:newStack];
        UIBarButtonItem *splitViewButton = [[oldController navigationItem] leftBarButtonItem];
        UIPopoverController *popoverController = [oldController masterPopoverController];
        [newController setSplitViewButton:splitViewButton forPopoverController:popoverController];
        // see if we should be hidden
        if (!UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            // we are in portrait mode so go away
            [popoverController dismissPopoverAnimated:YES];
        }
    }
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    UINavigationController *navController = [[[self splitViewController ] viewControllers ] lastObject ];
    VriendProfielViewController *vc = [[navController viewControllers] firstObject];
    
    [vc setSplitViewButton:barButtonItem forPopoverController:popoverController];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    UINavigationController *navController = [[[self splitViewController ] viewControllers ] lastObject ];
    VriendProfielViewController *vc = [[navController viewControllers] firstObject];
    [vc setSplitViewButton:nil forPopoverController:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
