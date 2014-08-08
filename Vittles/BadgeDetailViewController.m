//
//  BadgeDetailViewController.m
//  Vittles
//
//  Created by Anne Everars on 24/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "BadgeDetailViewController.h"
#import <Parse/Parse.h>

@interface BadgeDetailViewController () {
    NSString *login;
}

@end

@implementation BadgeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        //self.contentSizeForViewInPopover = CGSizeMake(400.0, 400.0);
    }
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
    //****POPOVER INVULLEN****
    self.navBar.topItem.title = self.naam;
    //1. Beschrijving van de badge
    PFQuery *query = [PFQuery queryWithClassName:@"Badges"];
    [query whereKey:@"Naam" equalTo:self.naam];
    NSArray *results = [query findObjects];
    PFObject *object = [results objectAtIndex:0];
    NSString *beschrijvingsTekst = [object objectForKey:@"Uitleg"];
    [self.beschrijving  setFont:[UIFont systemFontOfSize:16]];
    self.beschrijving.text = beschrijvingsTekst;
    PFQuery *queryUser = [PFQuery queryWithClassName:login];
    [queryUser whereKey:@"type" equalTo:@"badge"];
    [queryUser whereKey:@"Naam" equalTo:self.naam];
    NSArray *resultaten = [queryUser findObjects];
    if(resultaten.count >0) {
        PFObject *badgeMoment = [resultaten objectAtIndex:0];
        NSDate *verdiend = [badgeMoment updatedAt];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE dd MMM YYYY, hh:mm"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Brussels"]];
        NSString *stringFromDate = [formatter stringFromDate:verdiend];
        self.datum.text = stringFromDate;
    }
    else {
        [self.behaald setHidden:TRUE];
        [self.datum setHidden:TRUE];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)done:(id)sender
{
    [self.delegate PopoverViewControllerDidFinishAdding:self];
}

@end
