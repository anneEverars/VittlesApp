//
//  AlleTipsViewController.m
//  Vittles
//
//  Created by Anne Everars on 4/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "AlleTipsViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import <Parse/Parse.h>
#import "CustomCell.h"
#import "TipsContainerViewController.h"

@interface AlleTipsViewController () {
    NSMutableArray *tipsNamen;
    NSMutableArray *tipstags;
    NSArray *searchResults;
}

@end

@implementation AlleTipsViewController
@synthesize menuBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	//****MENU****
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuUitklapbaarViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(20, 24, 44, 34);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    //****Tipsnamen (en tags)****
    self.tipsTable.delegate = self;
    self.tipsTable.dataSource = self;
    tipsNamen = [[NSMutableArray alloc]init];
    tipstags = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Tips"];
    [query selectKeys:@[@"Naam",@"tags"]];
    NSArray *result = [query findObjects];
    for(PFObject *object in result) {
        NSString *naam = object[@"Naam"];
        NSArray *tags = object[@"tags"];
        if(![tipsNamen containsObject:naam]) {
            [tipsNamen addObject:naam];
            [tipstags addObject:tags];
        }
    }
    //****EXTRA INFORMATIE****
    [self.container setHidden:TRUE];
    //****Zoeken****
    self.searchBar.delegate = self;
    //self.searchDisplayController.delegate = self;
    //self.searchDisplayController.searchResultsDataSource = self;
    //self.searchDisplayController.searchResultsDelegate = self;
    searchResults = [[NSArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else {
        return tipsNamen.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TipsCell";
    CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!Cell) {
        Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *naam = [searchResults objectAtIndex:indexPath.row];
        Cell.textLabel.text = naam;
        PFQuery *query = [PFQuery queryWithClassName:@"Tips"];
        [query whereKey:@"Naam" equalTo:naam];
        NSArray *result = [query findObjects];
        PFObject *object = [result objectAtIndex:0];
        NSArray *tagsText = [object objectForKey:@"tags"];
        NSString *tags = @"tags: ";
        for(NSString *string in tagsText) {
            tags = [[tags stringByAppendingString:string] stringByAppendingString:@","];
        }
        NSString *tags2 = [tags substringToIndex:[tags length]-1];
        Cell.detailTextLabel.text = tags2;
        Cell.accessoryType = UITableViewCellAccessoryDetailButton;
    } 
    else {
        Cell.textLabel.text = [tipsNamen objectAtIndex:indexPath.row];
        NSString *tags = @"tags: ";
        for(NSString *string in [tipstags objectAtIndex:indexPath.row]) {
            tags = [[tags stringByAppendingString:string] stringByAppendingString:@","];
        }
        NSString *tags2 = [tags substringToIndex:[tags length]-1];
        Cell.detailTextLabel.text = tags2;
    }
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:255.0/255.0 blue:51.0/255.0 alpha:1];
    bgColorView.layer.cornerRadius = 7;
    bgColorView.layer.masksToBounds = YES;
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setSelectedBackgroundView:bgColorView];
    [self.container setHidden:FALSE];
    TipsContainerViewController * childViewController = ((TipsContainerViewController *) self.childViewControllers.lastObject);
    childViewController.navBar.topItem.title = selectedCell.textLabel.text;
    [childViewController reloadView];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:255.0/255.0 blue:51.0/255.0 alpha:1];
    bgColorView.layer.cornerRadius = 7;
    bgColorView.layer.masksToBounds = YES;
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setSelectedBackgroundView:bgColorView];
    [self.container setHidden:FALSE];
    TipsContainerViewController * childViewController = ((TipsContainerViewController *) self.childViewControllers.lastObject);
    childViewController.navBar.topItem.title = selectedCell.textLabel.text;
    [childViewController reloadView];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    searchResults = [[NSArray alloc]init];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    searchResults = [tipsNamen filteredArrayUsingPredicate:resultPredicate];
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
    [self.searchDisplayController.searchResultsTableView setFrame:self.tipsTable.frame];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

@end
