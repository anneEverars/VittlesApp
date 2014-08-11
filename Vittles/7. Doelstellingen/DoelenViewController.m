//
//  DoelenViewController.m
//  Vittles
//
//  Created by Anne Everars on 4/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "DoelenViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import <Parse/Parse.h>

@interface DoelenViewController () {
    NSString *login;
}

@end

@implementation DoelenViewController

@synthesize menuBtn;
@synthesize DoelLabel;
@synthesize VooruitgangLabel;
@synthesize TijdLabel;
@synthesize Statusbalk;
@synthesize progressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void) viewWillLayoutSubviews {
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    self.Statusbalk.transform = transform;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated {
    //****Gebruiker****
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    [self.volgens setHidden:TRUE];
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
    //****DOELLABEL****
    PFQuery *query = [PFQuery queryWithClassName:login];
    [query whereKey:@"type" equalTo:@"doel"];
    [query whereKey:@"Naam" equalTo:@"naam"];
    NSArray *results = [query findObjects];
    PFObject *object = [results objectAtIndex:0];
    NSString *type = [object objectForKey:@"soort"];
    float hoeveelheid = [[object objectForKey:@"hoeveelheid"] floatValue];
    //****VOORUITGANG****
    PFQuery *queryVooruitgang = [PFQuery queryWithClassName:login];
    [queryVooruitgang whereKey:@"type" equalTo:@"doel"];
    [queryVooruitgang whereKey:@"Naam" equalTo:@"begin"];
    NSArray *resultsVooruitgang = [queryVooruitgang findObjects];
    PFObject *vooruitgangObject = [resultsVooruitgang objectAtIndex:0];
    float hoeveelheidBegin = [[vooruitgangObject objectForKey:@"hoeveelheid"] floatValue];
    float hoeveelheidTeVerliezen = hoeveelheidBegin - hoeveelheid;
    NSString *hoeveelFormat = [[NSString stringWithFormat:@"%.2f", hoeveelheidTeVerliezen]stringByReplacingOccurrencesOfString:@"." withString:@","];
    PFQuery *queryStatus = [PFQuery queryWithClassName:login];
    [queryStatus whereKey:@"type" equalTo:@"profiel"];
    //****INVULLEN****
    if([type isEqualToString:@"gewicht"]) {
        DoelLabel.text = [[@"Verlies " stringByAppendingString:hoeveelFormat] stringByAppendingString:@" kg"];
        [queryStatus whereKey:@"Naam" equalTo:@"gewicht"];
    }
    else if([type isEqualToString:@"heupen"]) {
        DoelLabel.text = [[@"Verlies " stringByAppendingString:hoeveelFormat] stringByAppendingString:@" cm op de heupen"];
        [queryStatus whereKey:@"Naam" equalTo:@"heupen"];
    }
    else {
        DoelLabel.text = [[@"Verlies " stringByAppendingString:hoeveelFormat] stringByAppendingString:@" cm in de taille"];
        [queryStatus whereKey:@"Naam" equalTo:@"taille"];
    }
    [queryStatus orderByDescending:@"updatedAt"];
    NSArray *resultsStatus = [queryStatus findObjects];
    PFObject *statusObject = [resultsStatus objectAtIndex:0];
    float gewicht = [[statusObject objectForKey:@"hoeveelheid"] floatValue];
    float verschil = hoeveelheidBegin - gewicht;
    float vooruitgang = verschil / hoeveelheidTeVerliezen;
    if(vooruitgang > 1.0f){
        vooruitgang = 1.0f;
    }
    Statusbalk.progress = vooruitgang;
    NSString *vooruitgangS =[[NSString stringWithFormat:@"%.2f", (vooruitgang*100)]stringByReplacingOccurrencesOfString:@"." withString:@","];
    VooruitgangLabel.text = [vooruitgangS stringByAppendingString:@"%"];
    //****BADGE VERDIEND?****
    [self checkBadges];
    //****TIJDLABEL****
    NSDate *startDate = [vooruitgangObject updatedAt];
    NSDate *now = [NSDate date];
    NSTimeInterval diff = [now timeIntervalSinceDate:startDate];
    float totalTime;
    totalTime = diff/vooruitgang;
    float remaining = totalTime-diff;
    float days = remaining/86400;
    NSString *tijd = [[NSString stringWithFormat:@"%.2f", days]stringByReplacingOccurrencesOfString:@"." withString:@","];
    if(vooruitgang>0) {
        [self.volgens setHidden:FALSE];
        TijdLabel.text = [tijd stringByAppendingString:@" dagen"];
    }
    else if(diff>500){
        [self.volgens setHidden:FALSE];
        self.volgens.text = @"Je hebt nog geen vooruitgang gemaakt";
        TijdLabel.text = @"Misschien moet je je vooruitgang registreren?";
    }
    else {
        [self.volgens setHidden:FALSE];
        self.volgens.text = @"Veel succes!";
        [TijdLabel setHidden:TRUE];
    }
    //****MOEILIJKHEID****
    float moeilijkheid = 0.33f;
    if(days < 3) {
        moeilijkheid = 0.1f;
    }
    else if(days < 7) {
        moeilijkheid = 0.25f;
    }
    if(vooruitgang < 0.25) {
        moeilijkheid *= 2;
    }
    else if(vooruitgang < 0.5) {
        moeilijkheid *= 1.5;
    }
    else if(vooruitgang > 0.75) {
        moeilijkheid /= 2;
    }
    if(moeilijkheid < 0.33) {
        UIColor *tintColor = [UIColor greenColor];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [[CERoundProgressView appearance] setTintColor:tintColor];
        DoelLabel.textColor = tintColor;

    }
    else if(moeilijkheid < 0.66) {
        UIColor *tintColor = [UIColor orangeColor];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [[CERoundProgressView appearance] setTintColor:tintColor];
        DoelLabel.textColor = tintColor;

    }
    else {
        UIColor *tintColor = [UIColor redColor];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [[CERoundProgressView appearance] setTintColor:tintColor];
        DoelLabel.textColor = tintColor;

    }
    self.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    self.progressView.startAngle = (3.0*M_PI)/2.0;
    self.progressView.progress = moeilijkheid;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setProgressView:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight];
}

-(void) checkBadges {
    PFQuery *queryBadges = [PFQuery queryWithClassName:login];
    [queryBadges whereKey:@"type" equalTo:@"badge"];
    NSArray *resultsBadges = [queryBadges findObjects];
    NSMutableArray *names = [[NSMutableArray alloc]init];
    for (PFObject *badge in resultsBadges) {
        [names addObject:[badge objectForKey:@"Naam"]];
    }
    //Doel behaald?
    if((self.progressView.progress==1.0f) && (![names containsObject:@"Doel behaald"])){
        PFObject *gebruiker = [PFObject objectWithClassName:login];
        gebruiker[@"type"] = @"badge";
        gebruiker[@"Naam"] = @"Doel behaald";
        [gebruiker saveInBackground];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Je hebt net een badge verdiend!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}


@end
