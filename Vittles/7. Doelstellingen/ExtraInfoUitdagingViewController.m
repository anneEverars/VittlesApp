//
//  ExtraInfoUitdagingViewController.m
//  Vittles
//
//  Created by Anne Everars on 15/05/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "ExtraInfoUitdagingViewController.h"
#import <Parse/Parse.h>
#import "ECSlidingViewController.h"

@interface ExtraInfoUitdagingViewController ()

@end

@implementation ExtraInfoUitdagingViewController {
    NSMutableArray *vriendenNamen;
    NSMutableArray *vriendenvooruitgang;
    NSMutableArray *vriendenfoto;
    NSString *login;
}

@synthesize naam;

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
    //****Gebruiker****
    PFUser *user = [PFUser currentUser];
    NSString *userName = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [userName stringByAppendingString:email];
    self.naamLabel.text = naam;
    PFQuery *query = [PFQuery queryWithClassName:@"Uitdagingen"];
    [query whereKey:@"Naam" equalTo:naam];
    NSArray *results = [query findObjects];
    PFObject *uitdagingsobject = [results objectAtIndex:0];
    self.beschrijvingTekst.text = [uitdagingsobject objectForKey:@"Beschrijving"];
    self.beschrijvingTekst.font = [UIFont systemFontOfSize:18.0f];
    NSArray *beloningenRij = [uitdagingsobject objectForKey:@"Beloningen"];
    NSString *beloningen = [beloningenRij componentsJoinedByString:@"\n"];
    self.beloningTekst.text = beloningen;
    self.beloningTekst.font = [UIFont systemFontOfSize:18.0f];
    if([vriendenNamen count]==0) {
        [self.Vriendenlijst setHidden:TRUE];
    }
    else {
        [self.Vriendenlijst setHidden:FALSE];
    }
    //Is de gebruiker al bezig met de uitdaging?
    PFQuery *queryUser = [PFQuery queryWithClassName:login];
    [queryUser whereKey:@"type" equalTo:@"Uitdaging"];
    [queryUser whereKey:@"Naam" equalTo:naam];
    NSArray *resultsUser = [queryUser findObjects];
    if (resultsUser.count >0) {
        PFObject *uitdaging = [resultsUser objectAtIndex:0];
        NSString *moment = [uitdaging objectForKey:@"moment"];
        if([moment isEqualToString:@"Actief"]) {
            PFObject *uitdagingsobject = [resultsUser objectAtIndex:0];
            float vooruitgangsgetal = [[uitdagingsobject objectForKey:@"vooruitgang"] floatValue];
            [self.vooruitgang setProgress:vooruitgangsgetal];
            NSString *vooruitgangS =[[NSString stringWithFormat:@"%.2f", (vooruitgangsgetal*100)]stringByReplacingOccurrencesOfString:@"." withString:@","];
            self.vooruitganglabel.text = [vooruitgangS stringByAppendingString:@"%"];
            [self.actieKnop setTitle:@"Geef op" forState:UIControlStateNormal];
            [self.actieKnop setBackgroundColor:[UIColor whiteColor]];
            [self.actieKnop setTitleColor:[self.vriendenUitdagenButton titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
            [self.vriendenUitdagenButton setBackgroundColor:[self.vriendenUitdagenButton titleColorForState:UIControlStateNormal]];
            [self.vriendenUitdagenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else if([moment isEqualToString:@"Voltooid"]) {
            [self.vooruitgang setProgress:1.0f];
            NSString *vooruitgangS =[[NSString stringWithFormat:@"%.2f", 100.0f]stringByReplacingOccurrencesOfString:@"." withString:@","];
            self.vooruitganglabel.text = [vooruitgangS stringByAppendingString:@"%"];
            [self.actieKnop setHidden:TRUE];
            [self.vriendenUitdagenButton setBackgroundColor:[self.vriendenUitdagenButton titleColorForState:UIControlStateNormal]];
            [self.vriendenUitdagenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    else {
        [self.vooruitgang setProgress:0.0f];
        self.vooruitganglabel.text = @"0,0%";
        [self.actieKnop setTitle:@"Ga uitdaging aan" forState:UIControlStateNormal];
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
}
*/

- (IBAction)daagUit:(id)sender {
}

- (IBAction)actieUitvoeren:(id)sender {
    if([self.actieKnop.titleLabel.text isEqualToString:@"Ga uitdaging aan"]) {
        PFObject *uitdaging = [PFObject objectWithClassName:login];
        uitdaging[@"type"] = @"Uitdaging";
        uitdaging[@"Naam"] = self.naamLabel.text;
        uitdaging[@"moment"] = @"Actief";
        uitdaging[@"vooruitgang"] = [NSNumber numberWithFloat: 0.0f];
        [uitdaging saveInBackground];
        //Ga terug naar uitdagingen
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Uitdagingen"];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    }
    //anders geef je op
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Ben je zeker dat je deze uitdaging wil opgeven?"
                                                       delegate:self
                                              cancelButtonTitle:@"Nee"
                                              otherButtonTitles:@"Ja", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Ja"]){
        PFQuery *queryUser = [PFQuery queryWithClassName:login];
        [queryUser whereKey:@"type" equalTo:@"Uitdaging"];
        [queryUser whereKey:@"Naam" equalTo:self.naamLabel.text];
        NSArray *resultaat = [queryUser findObjects];
        PFObject *resultaatObject =[resultaat objectAtIndex:0];
        resultaatObject[@"moment"] = @"Opgegeven";
        [resultaatObject save];
        //Ga terug naar voedingsdagboek
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Uitdagingen"];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)annuleren:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
