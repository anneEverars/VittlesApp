//
//  MainViewController.m
//  Vittles
//
//  Created by Anne Everars on 26/02/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "MainViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import <Parse/Parse.h>

@interface MainViewController ()

@end

@implementation MainViewController {
    BOOL voedingsdagboek;
    BOOL activiteiten;
    BOOL gewicht;
    NSString *login;
}

@synthesize menuBtn;

- (void) viewWillLayoutSubviews
{
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 10.0f);
    self.calorieBar.transform = transform;
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
	
    //****GEBRUIKER****
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    //****DATUM****
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    NSDate* dateOnly = [calendar dateFromComponents:components];
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
    //****KNOP****
    PFQuery *queryUserOne = [PFQuery queryWithClassName:login];
    [queryUserOne whereKey:@"type" equalTo:@"food"];
    [queryUserOne whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
    NSArray *resultsE = [queryUserOne findObjects];
    if([resultsE count] <= 0) {
        [self.uitlegLabel setText:@"Je hebt vandaag nog niets gegeten"];
        [self.actieknop setTitle:@"Registreer nu" forState:UIControlStateNormal];
        voedingsdagboek = TRUE;
        activiteiten = FALSE;
        gewicht = FALSE;
    }
    else {
        PFQuery *queryUserTwo = [PFQuery queryWithClassName:login];
        [queryUserTwo whereKey:@"type" equalTo:@"activity"];
        [queryUserTwo whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
        resultsE = [queryUserTwo findObjects];
        if([resultsE count] <= 0) {
            [self.uitlegLabel setText:@"Je hebt vandaag nog geen activiteit toegevoegd"];
            [self.actieknop setTitle:@"Ga nu aan de slag" forState:UIControlStateNormal];
            voedingsdagboek = FALSE;
            activiteiten = TRUE;
            gewicht = FALSE;
        }
        else {
            [self.uitlegLabel setText:@"Update nu je gewicht"];
            [self.actieknop setTitle:@"Ga nu aan de slag" forState:UIControlStateNormal];
            voedingsdagboek = FALSE;
            activiteiten = FALSE;
            gewicht = TRUE;
        }
    }
    //****CONSUMPTIE****
    PFQuery *queryConsumption = [PFQuery queryWithClassName:login];
    [queryConsumption whereKey:@"type" equalTo:@"food"];
    [queryConsumption whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
    NSArray *consumptions = [queryConsumption findObjects];
    float water = 0.0f;
    float fruit = 0.0f;
    float granen = 0.0f;
    float vlees = 0.0f;
    float vetten = 0.0f;
    float melk = 0.0f;
    float suiker = 0.0f;
    float restGroep = 0.0f;
    for(PFObject *object in consumptions) {
        NSString *type = [object objectForKey:@"soort"];
        float hoeveelheid = [[object objectForKey:@"hoeveelheid"] floatValue];
        if([type compare:@"Vleesproducten"] == 0) {
            vlees += hoeveelheid;
        }
        if([type compare:@"Fruit"] == 0) {
            fruit += hoeveelheid;
        }
        if([type compare:@"Vis en schaaldieren"] == 0) {
            vlees += hoeveelheid;
        }
        if([type compare:@"Zuivelproducten"] == 0) {
            melk += hoeveelheid;
        }
        if([type compare:@"Oliën en vetten"] == 0) {
            vetten += hoeveelheid;
        }
        if([type compare:@"Suikerproducten"] == 0) {
            suiker += hoeveelheid;
        }
        if([type compare:@"Graanproducten"] == 0) {
            granen += hoeveelheid;
        }
        if([type compare:@"Groenten"] == 0) {
            fruit += hoeveelheid;
        }
        if([type compare:@"Dranken"] == 0) {
            water += hoeveelheid;
        }
        if([type compare:@"Gerechten"] == 0) {
            //nog niets
        }
        if([type compare:@"Diversen"] == 0) {
            //nog niets
        }
    }
    PFQuery *queryActivities = [PFQuery queryWithClassName:login];
    [queryActivities whereKey:@"type" equalTo:@"activity"];
    [queryActivities whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
    NSArray *activiteitenQuery = [queryActivities findObjects];
    float activiteitenAantal = 0;
    for(PFObject *result in activiteitenQuery) {
        activiteitenAantal += [[result objectForKey:@"hoeveelheid"] floatValue];
    }
    //build up the labels
    PFQuery *queryADH = [PFQuery queryWithClassName:login];
    [queryADH whereKey:@"type" equalTo:@"ADH"];
    NSArray *resultsADH = [queryADH findObjects];
    for(PFObject *result in resultsADH) {
        //1. Water
        float ADHWater = [[result objectForKey:@"water"]floatValue];
        float waarde = (water/ADHWater)*100;
        NSString *gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        UIColor *tintColor1 = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:205.0/255.0 alpha:1.0f];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor1];
        [[CERoundProgressView appearance] setTintColor:tintColor1];
        self.waterView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.waterView.startAngle = (3.0*M_PI)/2.0;
        self.waterView.progress = waarde/100.0f;
        self.waterLabel.text = [gebruikt stringByAppendingString:@"%"];
        //2. fruit
        float ADHFruit = [[result objectForKey:@"fruit"]floatValue];
        waarde = (fruit/ADHFruit)*100;
        gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        UIColor *tintColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:102.0/255.0 alpha:1.0f];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [self.fruitView setTintColor:tintColor];
        self.fruitView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.fruitView.startAngle = (3.0*M_PI)/2.0;
        self.fruitView.progress = waarde/100.0f;
        self.fruitLabel.text = [gebruikt stringByAppendingString:@"%"];
        //3. granen
        float ADHGranen = [[result objectForKey:@"granen"]floatValue];
        waarde = (granen/ADHGranen)*100;
        gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        tintColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [self.wheatView setTintColor:tintColor];
        self.wheatView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.wheatView.startAngle = (3.0*M_PI)/2.0;
        self.wheatView.progress = waarde/100.0f;
        self.wheatLabel.text = [gebruikt stringByAppendingString:@"%"];
        //4. vlees
        float ADHVlees = [[result objectForKey:@"vlees"]floatValue];
        waarde = (vlees/ADHVlees)*100;
        gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        tintColor = [UIColor colorWithRed:153.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0f];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [self.meatView setTintColor:tintColor];
        self.meatView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.meatView.startAngle = (3.0*M_PI)/2.0;
        self.meatView.progress = waarde/100.0f;
        self.meatLabel.text = [gebruikt stringByAppendingString:@"%"];
        //5. vetten
        float ADHVetten = [[result objectForKey:@"vetten"]floatValue];
        waarde = (vetten/ADHVetten)*100;
        gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0f];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [self.oilView setTintColor:tintColor];
        self.oilView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.oilView.startAngle = (3.0*M_PI)/2.0;
        self.oilView.progress = waarde/100.0f;
        self.oilLabel.text = [gebruikt stringByAppendingString:@"%"];
        //6. Melk
        float ADHMelk = [[result objectForKey:@"melk"]floatValue];
        waarde = (melk/ADHMelk)*100;
        gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        tintColor = [UIColor colorWithRed:102.0/255.0 green:205.0/255.0 blue:255.0/255.0 alpha:1.0f];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [self.milkView setTintColor:tintColor];
        self.milkView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.milkView.startAngle = (3.0*M_PI)/2.0;
        self.milkView.progress = waarde/100.0f;
        self.milkLabel.text = [gebruikt stringByAppendingString:@"%"];
        //7. Suiker
        float ADHSuiker = [[result objectForKey:@"suiker"]floatValue];
        waarde = (suiker/ADHSuiker)*100;
        gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        tintColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:153.0/255.0 alpha:1.0f];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [self.sugarView setTintColor:tintColor];
        self.sugarView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.sugarView.startAngle = (3.0*M_PI)/2.0;
        self.sugarView.progress = waarde/100.0f;
        self.sugarLabel.text = [gebruikt stringByAppendingString:@"%"];
        //8. Restgroep
        float ADHRest = [[result objectForKey:@"rest"]floatValue];
        waarde = (restGroep/ADHRest)*100;
        gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        tintColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:204.0/255.0 alpha:1.0f];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [self.restView setTintColor:tintColor];
        self.restView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.restView.startAngle = (3.0*M_PI)/2.0;
        self.restView.progress = waarde/100.0f;
        self.restLabel.text = [gebruikt stringByAppendingString:@"%"];
        //9. Activiteiten
        float ADHActiviteiten = [[result objectForKey:@"hoeveelheid"]floatValue];
        waarde = (activiteitenAantal/ADHActiviteiten)*100;
        gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        tintColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0f];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [self.activityView setTintColor:tintColor];
        self.activityView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.activityView.startAngle = (3.0*M_PI)/2.0;
        self.activityView.progress = waarde/100.0f;
        self.activityLabel.text = [gebruikt stringByAppendingString:@"%"];
    }
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
    else {
        PFQuery *queryUserGewicht = [PFQuery queryWithClassName:login];
        [queryUserGewicht whereKey:@"type" equalTo:@"profiel"];
        [queryUserGewicht whereKey:@"Naam" equalTo:@"gewicht"];
        [queryUserGewicht orderByDescending:@"updatedAt"];
        NSArray *results = [queryUserGewicht findObjects];
        if([results count] > 0) {
            PFObject *resultaatGewicht = [results objectAtIndex:0];
            NSNumber *gewichtNb = [resultaatGewicht objectForKey:@"hoeveelheid"];
            float kg = [gewichtNb floatValue];
            PFObject *opname = [PFObject objectWithClassName:login];
            opname[@"type"] = @"consumptie";
            opname[@"Naam"] = @"verbruik";
            energieVerbruik = (0.95/60*kg*720)+(1.04/60*kg*720);
            opname[@"hoeveelheid"] = [NSNumber numberWithFloat:energieVerbruik];
            [opname saveInBackground];
        }
    }
    float energie = energieOpname - energieVerbruik;
    self.energiemeter.text = [[[NSString stringWithFormat:@"%.2f", energie]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
    energie /= 4000;
    energie += 0.5;
    if(energie < 0.01f){
        energie = 0.01f;
    }
    if(energie > 1) {
        energie = 1.0f;
    }
    [self.calorieBar setProgress:energie];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight];
}

- (IBAction)start:(id)sender {
    if(voedingsdagboek) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Voedingsdagboek"];
    }
    else if (activiteiten) {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Activiteitenlogboek"];
    }
    else {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Vooruitgang"];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//POPOVER
-(void)DetailPopoverViewControllerDidFinishAdding:(DetailPopoverViewController *)controller {
    [self.flipsidePopoverController dismissPopoverAnimated:YES];
    self.flipsidePopoverController = nil;
}

-(void)DetailPopoverViewControllerDidFinishCancel:(DetailPopoverViewController *)controller {
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
        [self performSegueWithIdentifier:@"showMore0" sender:sender];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showMore0"]||[[segue identifier] isEqualToString:@"showMore1"]||[[segue identifier] isEqualToString:@"showMore2"]||[[segue identifier] isEqualToString:@"showMore3"]||[[segue identifier] isEqualToString:@"showMore4"]||[[segue identifier] isEqualToString:@"showMore5"]||[[segue identifier] isEqualToString:@"showMore6"]||[[segue identifier] isEqualToString:@"showMore7"]||[[segue identifier] isEqualToString:@"showMore8"]) {
        [[segue destinationViewController] setDelegate:self];
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *uipopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = uipopoverController;
            NSInteger tagIndex = [(UIButton *)sender tag];
            DetailPopoverViewController *vc = [segue destinationViewController];
            vc.type = tagIndex;
        }
    }
}
@end
