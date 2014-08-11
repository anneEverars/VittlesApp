//
//  VriendToevoegenViewController.m
//  Vittles
//
//  Created by Anne Everars on 23/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "VriendToevoegenViewController.h"
#import <Parse/Parse.h>
#import "CustomCell.h"
#import "ECSlidingViewController.h"

@interface VriendToevoegenViewController () {
    NSMutableArray *vriendenNamen;
    NSArray *searchResults;
    NSString *login;
}

@end

@implementation VriendToevoegenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    //****Vriendennamen****
    self.vriendenTable.delegate = self;
    self.vriendenTable.dataSource = self;
    NSMutableArray *vrienden = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:login];
    [query whereKey:@"type" equalTo:@"friend"];
    [query selectKeys:@[@"Naam"]];
    NSArray *results = [query findObjects];
    for(PFObject *resultaat in results) {
        [vrienden addObject:[resultaat objectForKey:@"Naam"]];
    }
    vriendenNamen = [[NSMutableArray alloc]init];
    PFQuery *queryUsers = [PFUser query];
    NSArray *result = [queryUsers findObjects];
    for(PFObject *object in result) {
        NSString *gebruikersnaam = object[@"username"];
        if(![vriendenNamen containsObject:gebruikersnaam] && ![gebruikersnaam isEqualToString:naam] && ![vrienden containsObject:gebruikersnaam]) {
            [vriendenNamen addObject:gebruikersnaam];
        }
    }
    //****ZOEKEN****
    self.searchBar.delegate = self;
    searchResults = [[NSArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else {
        return vriendenNamen.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VriendenCell";
    CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSLog(@"We beschouwen nu cell %ld", (long)indexPath.row);
    if (!Cell) {
        Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *naam = [searchResults objectAtIndex:indexPath.row];
        Cell.textLabel.text = naam;
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:naam];
        NSArray *results = [query findObjects];
        PFObject *user = [results objectAtIndex:0];
        PFFile *theImage = [user objectForKey:@"ProfilePic"];
        if(theImage) {
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            Cell.imageView.image = image;
        }
        else {
            Cell.imageView.image = [UIImage imageNamed:@"profilePicture.png"];
        }
    }
    else {
        NSString *naam = [vriendenNamen objectAtIndex:indexPath.row];
        Cell.textLabel.text = naam;
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:naam];
        NSArray *results = [query findObjects];
        PFObject *user = [results objectAtIndex:0];
        PFFile *theImage = [user objectForKey:@"ProfilePic"];
        if(theImage) {
            NSData *imageData = [theImage getData];
            UIImage *image = [UIImage imageWithData:imageData];
            Cell.imageView.image = image;
        }
        else {
            Cell.imageView.image = [UIImage imageNamed:@"profilePicture.png"];
        }
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        PFQuery *query = [PFQuery queryWithClassName:login];
        [query whereKey:@"type" equalTo:@"friend"];
        [query whereKey:@"Naam" equalTo:[searchResults objectAtIndex:indexPath.row]];
        if([[query findObjects]count]==0) {
            //Vriend toevoegen
            PFObject *vriend = [PFObject objectWithClassName:login];
            vriend[@"type"] = @"friend";
            vriend[@"Naam"] = [searchResults objectAtIndex:indexPath.row];
            [vriend saveInBackground];
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        PFQuery *query = [PFQuery queryWithClassName:login];
        [query whereKey:@"type" equalTo:@"friend"];
        [query whereKey:@"Naam" equalTo:[vriendenNamen objectAtIndex:indexPath.row]];
        if([[query findObjects]count]==0) {
            //Vriend toevoegen
            PFObject *vriend = [PFObject objectWithClassName:login];
            vriend[@"type"] = @"friend";
            vriend[@"Naam"] = [vriendenNamen objectAtIndex:indexPath.row];
            [vriend saveInBackground];
            selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Nieuwsoverzicht"];
    [self.slidingViewController.topViewController viewDidLoad];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    searchResults = [[NSArray alloc]init];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    searchResults = [vriendenNamen filteredArrayUsingPredicate:resultPredicate];
    return;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    [self.searchDisplayController.searchResultsTableView setFrame:self.vriendenTable.frame];
    [self.searchDisplayController.searchResultsTableView reloadData];
}
@end
