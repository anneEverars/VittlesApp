//
//  FoodViewController.m
//  Vittles
//
//  Created by Anne Everars on 26/02/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "FoodAddViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import "CustomCell.h"
#import "InitViewController.h"
#import <Parse/Parse.h>
#import "ExtraInfoFoodViewController.h"

@interface FoodAddViewController () {
    NSArray *CategoryLabel;
    NSMutableArray *elementen;
    NSString *type;
    NSArray *momenten;
    NSString *moment;
    NSArray *searchResults;
    NSMutableArray *allFoodItems;
}

@end

@implementation FoodAddViewController

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];    
    //****MOMENTEN****
    self.Momenten.delegate = self;
    self.Momenten.dataSource = self;
    self.Momenten.layer.transform = CATransform3DRotate(CATransform3DIdentity,-1.57079633,0,0,1);
    [self.Momenten setBounds:CGRectMake(self.Momenten.frame.origin.x,
                                          self.Momenten.frame.origin.y,
                                          self.Momenten.frame.size.width,
                                          self.Momenten.frame.size.height)];
    momenten = [[NSArray alloc]
                         initWithObjects:@"Ontbijt", @"Tussendoortje", @"Middagmaal", @"Vieruurtje", @"Avondmaal", nil];
    //****CATEGORIEN****
    [self.Categorien setHidden:TRUE];
    self.Categorien.delegate = self;
    self.Categorien.dataSource = self;
    self.Categorien.layer.transform = CATransform3DRotate(CATransform3DIdentity,-1.57079633,0,0,1);
    [self.Categorien setBounds:CGRectMake(self.Categorien.frame.origin.x,
                                    self.Categorien.frame.origin.y,
                                    self.Categorien.frame.size.width,
                                    self.Categorien.frame.size.height)];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"categorie" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:filePath
                                                  encoding:NSMacOSRomanStringEncoding
                                                     error:NULL];
    NSArray *categories = [content componentsSeparatedByString:@"\n"];
    CategoryLabel = categories;
    //****INVULLING****
    [self.Invulling setHidden:TRUE];
    self.Invulling.dataSource = self;
    self.Invulling.delegate = self;
    self.Invulling.layer.transform = CATransform3DRotate(CATransform3DIdentity,-1.57079633,0,0,1);
    [self.Invulling setBounds:CGRectMake(self.Invulling.frame.origin.x,
                                          self.Invulling.frame.origin.y,
                                          self.Invulling.frame.size.width,
                                          self.Invulling.frame.size.height)];
    //****EXTRA INFORMATIE****
    [self.Container setHidden:TRUE];
    //****ZOEKEN****
    self.searchBar.delegate = self;
    //self.searchDisplayController.delegate = self;
    //self.searchDisplayController.searchResultsDelegate = self;
    //self.searchDisplayController.searchResultsDataSource = self;
    searchResults = [[NSArray alloc]init];
    //Alle voedingselementen
    allFoodItems = [[NSMutableArray alloc]init];
    for(NSString *categorie in categories) {
        NSString *cat = [categorie stringByReplacingOccurrencesOfString: @" " withString:@"_"];
        cat = [cat stringByReplacingOccurrencesOfString: @"ë" withString:@"_"];
        PFQuery *query = [PFQuery queryWithClassName:cat];
        [query selectKeys:@[@"Naam"]];
        NSArray *result = [query findObjects];
        for (PFObject *object in result) {
            NSString *naam = object[@"Naam"];
            if(![allFoodItems containsObject:naam]) {
                [allFoodItems addObject:naam];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else if(self.Momenten==tableView) {
        return momenten.count;
    }
    else if(self.Categorien==tableView) {
        return CategoryLabel.count;
    }
    else if(self.Invulling==tableView) {
        return elementen.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    else if(self.Momenten==tableView) {
        static NSString *CellIdentifier = @"MomentCell";
        CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!Cell) {
            Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        Cell.layer.transform = CATransform3DRotate(CATransform3DIdentity,1.57079633,0,0,1);
        Cell.frame=CGRectMake(0,0,234,150);
        Cell.textLabel.text = [momenten objectAtIndex:indexPath.row];
        
        return Cell;
    }
    else if(self.Categorien==tableView) {
        static NSString *CellIdentifier = @"Cell";
        CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!Cell) {
        Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        Cell.layer.transform = CATransform3DRotate(CATransform3DIdentity,1.57079633,0,0,1);
        Cell.frame=CGRectMake(0,0,234,150);
        NSString *naam = nil;
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            naam = [searchResults objectAtIndex:indexPath.row];
        }
        else {
            naam = [CategoryLabel objectAtIndex:indexPath.row];
        }
        Cell.textLabel.text = naam;
    
        return Cell;
    }
    else if(self.Invulling==tableView) {
        static NSString *CellIdentifier = @"DetailCell";
        CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!Cell) {
            Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        Cell.layer.transform = CATransform3DRotate(CATransform3DIdentity,1.57079633,0,0,1);
        Cell.frame=CGRectMake(0,0,234,150);
        
        Cell.textLabel.text = [elementen objectAtIndex:indexPath.row];
        
        return Cell;
    }
    else {
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
    return NULL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:255.0/255.0 blue:51.0/255.0 alpha:1];
    bgColorView.layer.cornerRadius = 7;
    bgColorView.layer.masksToBounds = YES;
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    [selectedCell setSelectedBackgroundView:bgColorView];
    if(self.Momenten==tableView) {
        moment = selectedCell.textLabel.text;
        [self.Categorien setHidden:FALSE];
    }
    if(self.Categorien==tableView){
            elementen = [[NSMutableArray alloc]init];
            NSString *cellText = selectedCell.textLabel.text;
            NSString *cat = [cellText stringByReplacingOccurrencesOfString: @" " withString:@"_"];
            cat = [cat stringByReplacingOccurrencesOfString: @"ë" withString:@"_"];
            PFQuery *query = [PFQuery queryWithClassName:cat];
            int max = 2000;
            [query setLimit:max];
            [query orderByAscending:@"Naam"];
            [query selectKeys:@[@"Naam"]];
            NSArray *result = [query findObjects];
            for (PFObject *object in result) {
                NSString *naam = object[@"Naam"];
                if(![elementen containsObject:naam]) {
                    [elementen addObject:naam];
                }
            }
            [self.Container setHidden:TRUE];
            if(elementen.count > 0){
                [self.Invulling setHidden:FALSE];
            }
            else {
                [self.Invulling setHidden:TRUE];
            }
            [self.Invulling reloadData];
            type = cellText;
    }
    if((self.Invulling==tableView)||(self.searchDisplayController.searchResultsTableView==tableView))  {
        NSString *cellText = selectedCell.textLabel.text;
        ExtraInfoFoodViewController * childViewController = ((ExtraInfoFoodViewController *) self.childViewControllers.lastObject);
        childViewController.ItemLabel.text = cellText;
        childViewController.soorten = [[NSMutableArray alloc] init];
        childViewController.soortenProduct = [[NSMutableArray alloc] init];
        [childViewController.types setHidden:FALSE];
        NSArray *result;
        for(NSString *types in CategoryLabel){
            NSString *cat = [types stringByReplacingOccurrencesOfString: @" " withString:@"_"];
            cat = [cat stringByReplacingOccurrencesOfString: @"ë" withString:@"_"];
            PFQuery *query = [PFQuery queryWithClassName:cat];
            [query whereKey:@"Naam" equalTo:cellText];
            result = [query findObjects];
            if([result count] > 0) {
                [self.Container setHidden:FALSE];
                for (PFObject *object in result) {
                    NSString *inhoud = object[@"Inhoud"];
                    if(![childViewController.soorten containsObject:inhoud]) {
                        [childViewController.soorten addObject:inhoud];
                    }
                    NSString *soort = [object objectForKey:@"Soort"];
                    if(soort != nil && soort != (id)[NSNull null]) {
                        if(! [childViewController.soortenProduct containsObject:soort]) {
                            assert(soort);
                            [childViewController.soortenProduct addObject:soort];
                        }
                    }
                }
                [childViewController.soorten addObject:@"g"];
                childViewController.type = type;
                PFObject *eerste = [result objectAtIndex:0];
                NSNumber *calorien = [eerste objectForKey:@"energie"];
                NSNumber *eiwitten = [eerste objectForKey:@"eiwitten"];
                NSNumber *koolhydraten = [eerste objectForKey:@"koolhydraten"];
                NSNumber *vetten = [eerste objectForKey:@"vetten"];
                childViewController.energie.text = [[calorien stringValue] stringByReplacingOccurrencesOfString:@"." withString:@","];
                childViewController.eiwitten.text = [[[eiwitten stringValue] stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" g"];
                childViewController.vetten.text = [[[vetten stringValue] stringByReplacingOccurrencesOfString:@"." withString:@","]stringByAppendingString:@" g"];
                childViewController.koolhydraten.text = [[[koolhydraten stringValue] stringByReplacingOccurrencesOfString:@"." withString:@","]stringByAppendingString:@" g"];
                [childViewController.soortenPicker reloadAllComponents];
                childViewController.moment = moment;
                if(childViewController.soortenProduct.count == 1){
                    if(childViewController.soortenProduct.firstObject != (id)[NSNull null]) {
                        [childViewController.types reloadData];
                    }
                    else {
                        [childViewController.types setHidden:TRUE];
                        [childViewController.kiesEenSoort setHidden:TRUE];
                    }
                }
                else if(childViewController.soortenProduct.count == 0){
                    [childViewController.types setHidden:TRUE];
                    [childViewController.kiesEenSoort setHidden:TRUE];
                }
                else {
                    [childViewController.kiesEenSoort setHidden:FALSE];
                    [childViewController.types reloadData];
                }
            }
        }
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    searchResults = [[NSArray alloc]init];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    searchResults = [allFoodItems filteredArrayUsingPredicate:resultPredicate];
    return;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

/*-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [self.Categorien setHidden:TRUE];
    [self.Invulling setHidden:TRUE];
    controller.searchResultsTableView.layer.transform = CATransform3DRotate(CATransform3DIdentity,-1.57079633,0,0,1);
    [controller.searchResultsTableView setBounds:CGRectMake(self.Categorien.frame.origin.y,
                                                            self.Categorien.frame.origin.x,
                                                            self.Categorien.frame.size.height,
                                                            self.Categorien.frame.size.width)];
}*/

-(void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    [self.Categorien setHidden:FALSE];
    [self.Container setHidden:TRUE];
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    [self.Categorien setHidden:TRUE];
    [self.Invulling setHidden:TRUE];
    self.searchDisplayController.searchResultsTableView.layer.transform = CATransform3DRotate(CATransform3DIdentity,-1.57079633,0,0,1);
    [self.searchDisplayController.searchResultsTableView setBounds:CGRectMake(self.Categorien.frame.origin.y,
                                                                             self.Categorien.frame.origin.x,
                                                                             self.Categorien.frame.size.height,
                                                                             self.Categorien.frame.size.width)];
    [self.searchDisplayController.searchResultsTableView setFrame:self.Categorien.frame];
    [self.searchDisplayController.searchResultsTableView reloadData];
}

//POPOVER
-(void)flipsideViewControllerDidFinishAdding:(FlipsideViewController *)controller {
    [self.flipsidePopoverController dismissPopoverAnimated:YES];
    self.flipsidePopoverController = nil;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verzoek verstuurd"
                                                    message:@"Zodra het goedgekeurd is, word je item in de voedingsdatabank opgenomen."
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)flipsideViewControllerDidFinishCancel:(FlipsideViewController *)controller {
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
