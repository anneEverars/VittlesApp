//
//  ActivityAddViewController.m
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "ActivityAddViewController.h"
#import "CustomCell.h"
#import <Parse/Parse.h>
#import "ExtraInfoActivitieitViewController.h"

@interface ActivityAddViewController () {
    NSArray *CategoryLabel;
    NSMutableArray *elementen;
    NSString *type;
    NSString *login;
    NSArray *searchResults;
    NSMutableArray *allActivities;
}

@end

@implementation ActivityAddViewController

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Gebruiker
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    //SOORTEN ACTIVITEITEN
    self.SoortenActiviteiten.dataSource = self;
    self.SoortenActiviteiten.delegate = self;
    CategoryLabel = [[NSArray alloc] initWithObjects:@"Frequent gekozen", @"Recent gekozen", @"Sporten", @"Vrijetijd", @"Andere", nil];
    
    
    self.SoortenActiviteiten.layer.transform = CATransform3DRotate(CATransform3DIdentity,-1.57079633,0,0,1);
    [self.SoortenActiviteiten setBounds:CGRectMake(self.SoortenActiviteiten.frame.origin.x,
                                        self.SoortenActiviteiten.frame.origin.y,
                                        self.SoortenActiviteiten.frame.size.width,
                                        self.SoortenActiviteiten.frame.size.height)];
    //ELEMENTEN
    [self.activiteiten setHidden:TRUE];
    self.activiteiten.dataSource = self;
    self.activiteiten.delegate = self;
    self.activiteiten.layer.transform = CATransform3DRotate(CATransform3DIdentity,-1.57079633,0,0,1);
    [self.activiteiten setBounds:CGRectMake(self.activiteiten.frame.origin.x,
                                         self.activiteiten.frame.origin.y,
                                         self.activiteiten.frame.size.width,
                                         self.activiteiten.frame.size.height)];
    //EXTRA INFORMATIE
    [self.Container setHidden:TRUE];
    searchResults = [[NSArray alloc]init];
    //ZOEKEN
    self.searchBar.delegate = self;
    searchResults = [[NSArray alloc]init];
    //Alle activiteiten
    allActivities = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Activiteiten"];
    [query selectKeys:@[@"Naam"]];
    NSArray *result = [query findObjects];
    for (PFObject *object in result) {
        NSString *naam = object[@"Naam"];
        if(![allActivities containsObject:naam]) {
            [allActivities addObject:naam];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return searchResults.count;
    }
    else if(self.SoortenActiviteiten==tableView){
        return CategoryLabel.count;
    }
    else if(self.activiteiten==tableView) {
        return elementen.count;
    }
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            static NSString *CellIdentifier = @"Cell";
            CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!Cell) {
                Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            Cell.layer.transform = CATransform3DRotate(CATransform3DIdentity,1.57079633,0,0,1);
            Cell.frame=CGRectMake(0,0,234,150);
            Cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
            return Cell;

        }
        else if(self.SoortenActiviteiten==tableView) {
            static NSString *CellIdentifier = @"Cell";
            CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!Cell) {
                Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            Cell.layer.transform = CATransform3DRotate(CATransform3DIdentity,1.57079633,0,0,1);
            Cell.frame=CGRectMake(0,0,234,150);
            Cell.textLabel.text = [CategoryLabel objectAtIndex:indexPath.row];
    
            return Cell;
        }
        else if(self.activiteiten==tableView) {
            static NSString *CellIdentifier = @"ActiviteitCell";
            CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!Cell) {
                Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            Cell.layer.transform = CATransform3DRotate(CATransform3DIdentity,1.57079633,0,0,1);
            Cell.frame=CGRectMake(0,0,234,150);
        
            Cell.textLabel.text = [elementen objectAtIndex:indexPath.row];
        
            return Cell;
        }
    return NULL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    searchResults = [[NSArray alloc]init];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    searchResults = [allActivities filteredArrayUsingPredicate:resultPredicate];
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
    [self.activiteiten setHidden:TRUE];
    self.searchDisplayController.searchResultsTableView.layer.transform = CATransform3DRotate(CATransform3DIdentity,-1.57079633,0,0,1);
    [self.searchDisplayController.searchResultsTableView setBounds:CGRectMake(self.SoortenActiviteiten.frame.origin.y, self.SoortenActiviteiten.frame.origin.x, self.SoortenActiviteiten.frame.size.height, self.SoortenActiviteiten.frame.size.width)];
    [self.searchDisplayController.searchResultsTableView setFrame:self.SoortenActiviteiten.frame];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:255.0/255.0 blue:51.0/255.0 alpha:1];
    bgColorView.layer.cornerRadius = 7;
    bgColorView.layer.masksToBounds = YES;
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setSelectedBackgroundView:bgColorView];
    if((self.activiteiten==tableView) || (self.searchDisplayController.searchResultsTableView==tableView)) {
        [self.Container setHidden:FALSE];
        NSString *cellText = selectedCell.textLabel.text;
        ExtraInfoActivitieitViewController * childViewController = ((ExtraInfoActivitieitViewController *) self.childViewControllers.lastObject);
        childViewController.ItemLabel.text = cellText;
        childViewController.type = type;
        childViewController.soorten = [[NSMutableArray alloc]init];
        [childViewController.types setHidden:FALSE];
        PFQuery *query = [PFQuery queryWithClassName:@"Activiteiten"];
        [query whereKey:@"Naam" equalTo:cellText];
        NSArray *result = [query findObjects];
        for(PFObject *object in result) {
            NSString *soort = [object objectForKey:@"soort"];
            if(soort != nil && soort != (id)[NSNull null]) {
                if(! [childViewController.soorten containsObject:soort]) {
                    assert(soort);
                    [childViewController.soorten addObject:soort];
                }
            }
        }
        PFObject *eerste = [result objectAtIndex:0];
        double calorien = [[eerste objectForKey:@"energie"]doubleValue];
        PFQuery *query2 = [PFQuery queryWithClassName:login];
        [query2 whereKey:@"type" equalTo:@"profiel"];
        [query2 whereKey:@"Naam" equalTo:@"gewicht"];
        [query orderByDescending:@"updatedAt"];
        NSArray *result2 = [query2 findObjects];
        PFObject *gewichtR = [result2 objectAtIndex:0];
        double gewicht = [[gewichtR objectForKey:@"hoeveelheid"] doubleValue];
        double energieNr = calorien*gewicht/6;
        childViewController.energie.text  = [[NSString stringWithFormat:@"%.2f", energieNr] stringByReplacingOccurrencesOfString:@"." withString:@","];
        [childViewController.aantal reloadAllComponents];
        if(childViewController.soorten.count == 1){
            if(childViewController.soorten.firstObject != (id)[NSNull null]) {
                [childViewController.types reloadData];
            }
            else {
                [childViewController.types setHidden:TRUE];
                [childViewController.kiesEenSoort setHidden:TRUE];
            }
        }
        else if(childViewController.soorten.count == 0){
            [childViewController.types setHidden:TRUE];
            [childViewController.kiesEenSoort setHidden:TRUE];
        }
        else {
            [childViewController.kiesEenSoort setHidden:FALSE];
            [childViewController.types reloadData];
        }
    }
    else if(self.SoortenActiviteiten==tableView){
        elementen = [[NSMutableArray alloc]init];
        NSString *cellText = selectedCell.textLabel.text;
        PFQuery *query = [PFQuery queryWithClassName:@"Activiteiten"];
        [query whereKey:@"type" equalTo:cellText];
        [query selectKeys:@[@"Naam"]];
        NSArray *result = [query findObjects];
        for (PFObject *object in result) {
            NSString *naam = object[@"Naam"];
            if(![elementen containsObject:naam]) {
                [elementen addObject:naam];
            }
        }
        if(elementen.count>0){
            [self.activiteiten setHidden:FALSE];
        }
        else {
            [self.activiteiten setHidden:TRUE];
        }
        [self.activiteiten reloadData];
        type = cellText;
    }
}

//POPOVER
-(void)flipsideViewControllerDidFinishAdding:(FlipsideActiviteitenViewController *)controller {
    [self.flipsidePopoverController dismissPopoverAnimated:YES];
    self.flipsidePopoverController = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verzoek verstuurd"
                                                    message:@" Zodra het goedgekeurd is, word je item in de activiteitendatabank opgenomen."
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)flipsideViewControllerDidFinishCancel:(FlipsideActiviteitenViewController *)controller {
    [self.flipsidePopoverController dismissPopoverAnimated:YES];
    self.flipsidePopoverController = nil;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.flipsidePopoverController = nil;
}

-(IBAction)togglePopover:(id)sender {
    if(self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
    else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *uipopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = uipopoverController;
        }
    }
}

@end
