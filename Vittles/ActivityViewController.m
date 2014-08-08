//
//  ActivityViewController.m
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "ActivityViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import "InitViewController.h"
#import "CustomCell.h"
#import "ActiviteitenItemViewController.h"
#import <Parse/Parse.h>

@interface ActivityViewController ()

@end

@implementation ActivityViewController {
    NSMutableArray *activiteiten;
    NSMutableArray *duur;
    NSMutableArray *energie;
    NSArray *voorgesteld;
    NSString *login;
    NSDate* dateOnly;
}

@synthesize menuBtn;
@synthesize dagoverzicht;

- (void) viewWillLayoutSubviews {
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    self.calorieBar.transform = transform;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    //****Gebruiker****
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    //Datum
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    dateOnly = [calendar dateFromComponents:components];
    [self.voegToeKnop setHidden:TRUE];
    self.dagoverzicht.dataSource = self;
    self.dagoverzicht.delegate = self;
	//****MENU****
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuUitklapbaarViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.parentViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(20, 24, 44, 34);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    //****ACTIVITEITEN****
    PFQuery *query = [PFQuery queryWithClassName:login];
    [query whereKey:@"type" equalTo:@"activity"];
    [query whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
    NSArray *results = [query findObjects];
    activiteiten = [[NSMutableArray alloc]
                    initWithObjects:@"Slapen", @"Rusten", nil];
    duur = [[NSMutableArray alloc]initWithObjects:@"12u00", @"12u00", nil];
    PFQuery *queryUserGewicht = [PFQuery queryWithClassName:login];
    [queryUserGewicht whereKey:@"type" equalTo:@"profiel"];
    [queryUserGewicht whereKey:@"Naam" equalTo:@"gewicht"];
    [queryUserGewicht orderByDescending:@"updatedAt"];
    NSArray *resultaten = [queryUserGewicht findObjects];
    float rusten = 0.0f;
    float slapen = 0.0f;
    if([resultaten count] > 0) {
        PFObject *resultaatGewicht = [resultaten objectAtIndex:0];
        NSNumber *gewichtNb = [resultaatGewicht objectForKey:@"hoeveelheid"];
        float kg = [gewichtNb floatValue];
        rusten = (1.04/60*kg*720);
        slapen = (0.95/60*kg*720);
    }
    energie = [[NSMutableArray alloc]init];
    [energie addObject:[NSNumber numberWithFloat:slapen]];
    [energie addObject:[NSNumber numberWithFloat:rusten]];
    int minSlapen = 720;
    int minRusten = 720;
    float activiteitenAantal = 0;
    for(PFObject *result in results) {
        NSString *moment = [result objectForKey:@"moment"];
        NSString *naam = [result objectForKey:@"Naam"];
        float energieAantal = [[result objectForKey:@"energie"] floatValue];
        NSNumber *hoeveelheid = [result objectForKey:@"hoeveelheid"];
        int hoeveel = [hoeveelheid intValue];
        if([moment compare:@"slapen"] == 0) {
            minSlapen -= hoeveel;
        }
        else {
            minRusten -= hoeveel;
        }
        [energie addObject:[NSNumber numberWithFloat:energieAantal]];
        [activiteiten addObject:naam];
        int uren = hoeveel/60;
        int minU = uren*60;
        int min = (int)hoeveel - minU;
        NSString *duurU = [NSString stringWithFormat:@"%02d", uren];
        NSString *duurM = [NSString stringWithFormat:@"%02d", min];
        NSString *totaleDuur = [[duurU stringByAppendingString:@"u"] stringByAppendingString:duurM];
        [duur addObject:totaleDuur];
        activiteitenAantal += [[result objectForKey:@"energie"] floatValue];
    }
    int uSlapen = (int)minSlapen/60;
    int minS = uSlapen*60;
    int slapenTijd = ((int)minSlapen - minS);
    NSString *minutenSlapen = [NSString stringWithFormat:@"%02d", slapenTijd];
    NSString *urenSlapen = [NSString stringWithFormat:@"%02d", uSlapen];
    int uRusten = (int)minRusten/60;
    int minR = uRusten*60;
    int rustenTijd = ((int)minRusten - minR);
    NSString *minutenRusten = [NSString stringWithFormat:@"%02d",rustenTijd];
    NSString *urenRusten = [NSString stringWithFormat:@"%02d", uRusten];
    NSString *slaapduur = [[urenSlapen stringByAppendingString:@"u"] stringByAppendingString:minutenSlapen];
    NSString *rustduur = [[urenRusten stringByAppendingString:@"u"] stringByAppendingString:minutenRusten];
    [queryUserGewicht whereKey:@"type" equalTo:@"profiel"];
    [queryUserGewicht whereKey:@"Naam" equalTo:@"gewicht"];
    [queryUserGewicht orderByDescending:@"updatedAt"];
    NSArray *resultatenGewicht = [queryUserGewicht findObjects];
    rusten = 0.0f;
    slapen = 0.0f;
    if([resultatenGewicht count] > 0) {
        PFObject *resultaatGewicht = [resultatenGewicht objectAtIndex:0];
        NSNumber *gewichtNb = [resultaatGewicht objectForKey:@"hoeveelheid"];
        float kg = [gewichtNb floatValue];
        rusten = (1.04/60*kg*minRusten);
        slapen = (0.95/60*kg*minSlapen);
    }
    [energie replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:slapen]];
    [energie replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:rusten]];
    [duur replaceObjectAtIndex:0 withObject:slaapduur];
    [duur replaceObjectAtIndex:1 withObject:rustduur];
    //****CALORIEMETER****
    //1. Opname
    PFQuery *queryUser = [PFQuery queryWithClassName:login];
    [queryUser whereKey:@"type" equalTo:@"consumptie"];
    [queryUser whereKey:@"Naam" equalTo:@"opname"];
    [queryUser whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
    NSArray *resultaat = [queryUser findObjects];
    float energieOpname = 0;
    if([resultaat count]> 0) {
        PFObject *resultaatOpname =[resultaat objectAtIndex:0];
        energieOpname = [[resultaatOpname objectForKey:@"hoeveelheid"] floatValue];
    }
    //2. Verbruik
    PFQuery *queryUser2 = [PFQuery queryWithClassName:login];
    [queryUser2 whereKey:@"type" equalTo:@"consumptie"];
    [queryUser2 whereKey:@"Naam" equalTo:@"verbruik"];
    [queryUser2 whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
    NSArray *resultaat2 = [queryUser2 findObjects];
    float energieVerbruik = 0;
    if([resultaat2 count] > 0) {
        PFObject *resultaatVerbruik =[resultaat2 objectAtIndex:0];
        energieVerbruik = [[resultaatVerbruik objectForKey:@"hoeveelheid"] floatValue];
    }
    //Activiteitenmeter
    PFQuery *queryADH = [PFQuery queryWithClassName:login];
    [queryADH whereKey:@"type" equalTo:@"ADH"];
    NSArray *resultsADH = [queryADH findObjects];
    PFObject *resultADH = [resultsADH objectAtIndex:0];
    float ADHActiviteiten = [[resultADH objectForKey:@"hoeveelheid"] floatValue];
    float waarde = (activiteitenAantal/ADHActiviteiten)*100;
    NSString *gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
    if(waarde > 100) {
        gebruikt = @"100,00";
        waarde = 100.0f;
    }
    UIColor *tintColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0f];
    [[UISlider appearance] setMinimumTrackTintColor:tintColor];
    [self.activityView setTintColor:tintColor];
    self.activityView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    self.activityView.startAngle = (3.0*M_PI)/2.0;
    self.activityView.progress = waarde/100.0f;
    self.activiteitenLabel.text = [gebruikt stringByAppendingString:@"%"];
    //Caloriemeter
    float energieF = energieOpname - energieVerbruik;
    self.energiemeter.text = [[[NSString stringWithFormat:@"%.2f", energieF]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
    energieF /= 4000;
    energieF += 0.5;
    if(energieF < 0.01f){
        energieF = 0.01f;
    }
    if(energieF > 1) {
        energieF = 1.0f;
    }
    [self.calorieBar setProgress:energieF];
    //****CONTAINER****
    [self.Container setHidden:TRUE];
    
    [self checkBadges];
    [self.dagoverzicht reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dagoverzicht==tableView) {
        return activiteiten.count;
    }
    return voorgesteld.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dagoverzicht==tableView) {
        static NSString *CellIdentifier = @"activiteitCell";
        UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier: CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        UILabel *activiteitName = (UILabel *)[cell viewWithTag:100];
        [activiteitName setText:[activiteiten objectAtIndex:indexPath.row]];
        UILabel *duurName = (UILabel *)[cell viewWithTag:200];
        [duurName setText:[duur objectAtIndex:indexPath.row]];
        
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"voorgesteldeCell";
        CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!Cell) {
            Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        Cell.textLabel.text = @"Hallo";
        
        return Cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row > 1) {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *activiteitName = (UILabel *)[selectedCell viewWithTag:100];
        NSString *naam = activiteitName.text;
        UILabel *duurName = (UILabel *)[selectedCell viewWithTag:200];
        NSString *hoeveelheid = duurName.text;
        ActiviteitenItemViewController *childViewController = ((ActiviteitenItemViewController *) self.childViewControllers.lastObject);
        childViewController.bar.topItem.title = naam;
        childViewController.hoeveelheid.text = hoeveelheid;
        childViewController.calorien = [[energie objectAtIndex:indexPath.row] floatValue];
        //****RESET****
        [childViewController viewWillAppear:TRUE];
        [self.Container setHidden:FALSE];
    }
    else {
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *activiteitName = (UILabel *)[selectedCell viewWithTag:100];
        NSString *naam = activiteitName.text;
        UILabel *duurName = (UILabel *)[selectedCell viewWithTag:200];
        NSString *hoeveelheid = duurName.text;
        ActiviteitenItemViewController *childViewController = ((ActiviteitenItemViewController *) self.childViewControllers.lastObject);
        childViewController.bar.topItem.title = naam;
        childViewController.hoeveelheid.text = hoeveelheid;
        childViewController.calorien = [[energie objectAtIndex:indexPath.row] floatValue];
        //****RESET****
        [childViewController viewWillAppear:TRUE];
        [self.Container setHidden:FALSE];
    }
}

-(void) checkBadges {
    BOOL newBadge = FALSE;
    //Voeding
    PFQuery *queryFood = [PFQuery queryWithClassName:login];
    [queryFood whereKey:@"type" equalTo:@"food"];
    NSArray *resultsFood = [queryFood findObjects];
    //Activiteiten
    PFQuery *queryActiviteiten = [PFQuery queryWithClassName:login];
    [queryActiviteiten whereKey:@"type" equalTo:@"activity"];
    NSArray *resultsActiviteiten = [queryActiviteiten findObjects];
    //Newbie badge?
    if(([resultsFood count] ==1) || ([resultsActiviteiten count]==1)) {
        PFQuery *queryBadges = [PFQuery queryWithClassName:login];
        [queryBadges whereKey:@"type" equalTo:@"badge"];
        if([[queryBadges findObjects] count] == 0) {
            PFObject *gebruiker = [PFObject objectWithClassName:login];
            gebruiker[@"type"] = @"badge";
            gebruiker[@"Naam"] = @"Newbie";
            [gebruiker saveInBackground];
            newBadge = TRUE;
        }
    }
    PFQuery *queryBadges = [PFQuery queryWithClassName:login];
    [queryBadges whereKey:@"type" equalTo:@"badge"];
    NSArray *resultsBadges = [queryBadges findObjects];
    NSMutableArray *names = [[NSMutableArray alloc]init];
    for (PFObject *badge in resultsBadges) {
        [names addObject:[badge objectForKey:@"Naam"]];
    }
    //Activiteitssbadge?
    if(([resultsActiviteiten count] ==1) && (![names containsObject:@"Start 2 sport"])){
        PFObject *gebruiker = [PFObject objectWithClassName:login];
        gebruiker[@"type"] = @"badge";
        gebruiker[@"Naam"] = @"Start 2 sport";
        [gebruiker saveInBackground];
        newBadge = TRUE;
    }
    else if(([resultsActiviteiten count] == 5)  && (![names containsObject:@"Sport lover"])){
        PFObject *gebruiker = [PFObject objectWithClassName:login];
        gebruiker[@"type"] = @"badge";
        gebruiker[@"Naam"] = @"Sport lover";
        [gebruiker saveInBackground];
        newBadge = TRUE;
    }
    else if(([resultsActiviteiten count] ==10) && (![names containsObject:@"Sportjunkie"])) {
        PFObject *gebruiker = [PFObject objectWithClassName:login];
        gebruiker[@"type"] = @"badge";
        gebruiker[@"Naam"] = @"Sportjunkie";
        [gebruiker saveInBackground];
        newBadge = TRUE;
    }
    else if(([resultsActiviteiten count] ==25) && (![names containsObject:@"Sportgoeroe"])) {
        PFObject *gebruiker = [PFObject objectWithClassName:login];
        gebruiker[@"type"] = @"badge";
        gebruiker[@"Naam"] = @"Sportgoeroe";
        [gebruiker saveInBackground];
        newBadge = TRUE;
    }
    if(newBadge) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Je hebt net een badge verdiend!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end

