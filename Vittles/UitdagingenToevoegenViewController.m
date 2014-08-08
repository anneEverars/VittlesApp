//
//  UitdagingenToevoegenViewController.m
//  Vittles
//
//  Created by Anne Everars on 15/05/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "UitdagingenToevoegenViewController.h"
#import <Parse/Parse.h>
#import "UitdagingInfoViewController.h"
#import "ECSlidingViewController.h"

@interface UitdagingenToevoegenViewController () {
    NSMutableArray *vriendenNamen;
    NSMutableArray *vriendenvooruitgang;
    NSMutableArray *vriendenfoto;
}

@end

@implementation UitdagingenToevoegenViewController{
    NSMutableArray *uitdagingen;
}

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
    // Do any additional setup after loading the view.
}

-(void) viewWillAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    [self.container setHidden:TRUE];
    self.uitdagingenTabel.delegate=self;
    self.uitdagingenTabel.dataSource=self;
    uitdagingen = [[NSMutableArray alloc]init];
    PFQuery *uitdagingenQuery = [PFQuery queryWithClassName:@"Uitdagingen"];
    NSArray *results = [uitdagingenQuery findObjects];
    
    PFQuery *uitdagingenActief = [PFQuery queryWithClassName:login];
    [uitdagingenActief whereKey:@"type" equalTo:@"Uitdaging"];
    [uitdagingenActief whereKey:@"moment" equalTo:@"Actief"];
    NSArray *resultsActief = [uitdagingenActief findObjects];
    
    PFQuery *uitdagingenVoltooid = [PFQuery queryWithClassName:login];
    [uitdagingenVoltooid whereKey:@"type" equalTo:@"Uitdaging"];
    [uitdagingenVoltooid whereKey:@"moment" equalTo:@"Voltooid"];
    NSArray *resultsVoltooid = [uitdagingenVoltooid findObjects];
    
    for(PFObject *result in results) {
        BOOL bezig = FALSE;
        for(PFObject *actieve in resultsActief) {
            if([[result objectForKey:@"Naam"] isEqualToString:[actieve objectForKey:@"Naam"]]) {
                bezig = TRUE;
            }
        }
        for(PFObject *voltooid in resultsVoltooid) {
            if([[result objectForKey:@"Naam"] isEqualToString:[voltooid objectForKey:@"Naam"]]) {
                bezig = TRUE;
            }
        }
        if(!bezig){
            NSString *naam = [result objectForKey:@"Naam"];
            [uitdagingen addObject:naam];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}*/

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return uitdagingen.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier: CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [uitdagingen objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *naam = selectedCell.textLabel.text;
    [self.container setHidden:FALSE];
    UitdagingInfoViewController * childViewController = ((UitdagingInfoViewController *) self.childViewControllers.lastObject);
    childViewController.naam = naam;
    childViewController.naamLabel.text = naam;
    PFQuery *query = [PFQuery queryWithClassName:@"Uitdagingen"];
    [query whereKey:@"Naam" equalTo:naam];
    NSArray *results = [query findObjects];
    PFObject *uitdagingsobject = [results objectAtIndex:0];
    childViewController.beschrijvingTekst.text = [uitdagingsobject objectForKey:@"Beschrijving"];
    childViewController.beschrijvingTekst.font = [UIFont systemFontOfSize:18.0f];
    NSArray *beloningenRij = [uitdagingsobject objectForKey:@"Beloningen"];
    NSString *beloningen = [beloningenRij componentsJoinedByString:@"\n"];
    childViewController.beloningTekst.text = beloningen;
    childViewController.beloningTekst.font = [UIFont systemFontOfSize:18.0f];
    if([vriendenNamen count]==0) {
        [childViewController.Vriendenlijst setHidden:TRUE];
    }
    else {
        [childViewController.Vriendenlijst setHidden:FALSE];
    }

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *naam = selectedCell.textLabel.text;
    [self.container setHidden:FALSE];
    UitdagingInfoViewController * childViewController = ((UitdagingInfoViewController *) self.childViewControllers.lastObject);
    childViewController.naam = naam;
    childViewController.naamLabel.text = naam;
    PFQuery *query = [PFQuery queryWithClassName:@"Uitdagingen"];
    [query whereKey:@"Naam" equalTo:naam];
    NSArray *results = [query findObjects];
    PFObject *uitdagingsobject = [results objectAtIndex:0];
    childViewController.beschrijvingTekst.text = [uitdagingsobject objectForKey:@"Beschrijving"];
    childViewController.beschrijvingTekst.font = [UIFont systemFontOfSize:18.0f];
    NSArray *beloningenRij = [uitdagingsobject objectForKey:@"Beloningen"];
    NSString *beloningen = [beloningenRij componentsJoinedByString:@"\n"];
    childViewController.beloningTekst.text = beloningen;
    childViewController.beloningTekst.font = [UIFont systemFontOfSize:18.0f];
    if([vriendenNamen count]==0) {
        [childViewController.Vriendenlijst setHidden:TRUE];
    }
    else {
        [childViewController.Vriendenlijst setHidden:FALSE];
    }
}

- (IBAction)save:(id)sender {
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Uitdagingen"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
