//
//  FoodViewController.m
//  Vittles
//
//  Created by Anne Everars on 1/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "FoodViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import "InitViewController.h"
#import "FoodAddViewController.h"
#import "CustomCell.h"
#import <Parse/Parse.h>
#import "VoedingsItemViewController.h"

@interface FoodViewController ()

@end

@implementation FoodViewController {
    NSArray *momenten;
    NSArray *voorgesteld;
    NSMutableArray *Ontbijt;
    NSMutableArray *Tussendoortje;
    NSMutableArray *Middagmaal;
    NSMutableArray *Vieruurtje;
    NSMutableArray *Avondmaal;
    NSMutableArray *OntbijtAantal;
    NSMutableArray *TussendoortjeAantal;
    NSMutableArray *MiddagmaalAantal;
    NSMutableArray *VieruurtjeAantal;
    NSMutableArray *AvondmaalAantal;
    NSMutableArray *OntbijtType;
    NSMutableArray *TussendoortjeType;
    NSMutableArray *MiddagmaalType;
    NSMutableArray *VieruurtjeType;
    NSMutableArray *AvondmaalType;
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
    //****TABEL****
    NSArray *arrTemp1 = [[NSArray alloc]
                         initWithObjects:@"Ontbijt", @"Tussendoortje", @"Middagmaal", @"Vieruurtje", @"Avondmaal", nil];
    momenten = arrTemp1;
    Ontbijt = [[NSMutableArray alloc]init];
    Tussendoortje = [[NSMutableArray alloc]init];
    Middagmaal  = [[NSMutableArray alloc]init];
    Vieruurtje = [[NSMutableArray alloc]init];
    Avondmaal = [[NSMutableArray alloc]init];
    OntbijtAantal = [[NSMutableArray alloc]init];
    TussendoortjeAantal = [[NSMutableArray alloc]init];
    MiddagmaalAantal  = [[NSMutableArray alloc]init];
    VieruurtjeAantal = [[NSMutableArray alloc]init];
    AvondmaalAantal = [[NSMutableArray alloc]init];
    OntbijtType = [[NSMutableArray alloc]init];
    TussendoortjeType = [[NSMutableArray alloc]init];
    MiddagmaalType  = [[NSMutableArray alloc]init];
    VieruurtjeType = [[NSMutableArray alloc]init];
    AvondmaalType = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:login];
    [query whereKey:@"type" equalTo:@"food"];
    [query whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
    NSArray *results = [query findObjects];
    float water = 0.0f;
    float fruit = 0.0f;
    float granen = 0.0f;
    float vlees = 0.0f;
    float vetten = 0.0f;
    float melk = 0.0f;
    float suiker = 0.0f;
    float restGroep = 0.0f;
    for(PFObject *result in results) {
        NSString *moment = [result objectForKey:@"moment"];
        NSString *naam = [result objectForKey:@"Naam"];
        NSNumber *hoeveelheidNb = [result objectForKey:@"hoeveelheid"];
        NSString *soort = [result objectForKey:@"soort"];
        float hoeveelheid = [hoeveelheidNb floatValue];
        if([moment compare:@"Ontbijt"] == 0) {
            [Ontbijt addObject:naam];
            [OntbijtAantal addObject:hoeveelheidNb];
            [OntbijtType addObject:soort];
        }
        if([moment compare:@"Tussendoortje"] == 0) {
            [Tussendoortje addObject:naam];
            [TussendoortjeAantal addObject:hoeveelheidNb];
            [TussendoortjeType addObject:soort];
        }
        if([moment compare:@"Middagmaal"] == 0) {
            [Middagmaal addObject:naam];
            [MiddagmaalAantal addObject:hoeveelheidNb];
            [MiddagmaalType addObject:soort];
        }
        if([moment compare:@"Vieruurtje"] == 0) {
            [Vieruurtje addObject:naam];
            [VieruurtjeAantal addObject:hoeveelheidNb];
            [VieruurtjeType addObject:soort];
        }
        if([moment compare:@"Avondmaal"] == 0) {
            [Avondmaal addObject:naam];
            [AvondmaalAantal addObject:hoeveelheidNb];
            [AvondmaalType addObject:soort];
        }
        NSString *type = [result objectForKey:@"soort"];
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
    //****CONTAINER****
    [self.Container setHidden:TRUE];
    //****LABELS****
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
    }
    //****BADGE VERDIEND?****
    [self checkBadges];
    [self.dagoverzicht reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return momenten.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [momenten objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.dagoverzicht==tableView) {
        if(section==0){
            return Ontbijt.count;
        }
        if(section==1){
            return Tussendoortje.count;
        }
        if(section==2){
            return Middagmaal.count;
        }
        if(section==3){
            return Vieruurtje.count;
        }
        if(section==4){
            return Avondmaal.count;
        }
    }
    return voorgesteld.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.dagoverzicht==tableView) {
        static NSString *CellIdentifier = @"momentCell";
        UITableViewCell *cell = [tableView
                                  dequeueReusableCellWithIdentifier: CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]
                     initWithStyle:UITableViewCellStyleSubtitle
                     reuseIdentifier:CellIdentifier];
        }
        if(indexPath.section==0){
            cell.textLabel.text = [Ontbijt objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[[OntbijtAantal objectAtIndex:indexPath.row] stringValue]stringByAppendingString:@"g"];
        }
        if(indexPath.section==1){
            cell.textLabel.text = [Tussendoortje objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[[TussendoortjeAantal objectAtIndex:indexPath.row]stringValue]stringByAppendingString:@"g"];
        }
        if(indexPath.section==2){
            cell.textLabel.text = [Middagmaal objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[[MiddagmaalAantal objectAtIndex:indexPath.row]stringValue]stringByAppendingString:@"g"];
        }
        if(indexPath.section==3){
            cell.textLabel.text = [Vieruurtje objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[[VieruurtjeAantal objectAtIndex:indexPath.row]stringValue]stringByAppendingString:@"g"];
        }
        if(indexPath.section==4){
            cell.textLabel.text = [Avondmaal objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [[[AvondmaalAantal objectAtIndex:indexPath.row]stringValue]stringByAppendingString:@"g"];
        }
        
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
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *naam = selectedCell.textLabel.text;
    NSString *hoeveelheid = selectedCell.detailTextLabel.text;
    VoedingsItemViewController *childViewController = ((VoedingsItemViewController *) self.childViewControllers.lastObject);
    childViewController.bar.topItem.title = naam;
    childViewController.hoeveelheid.text = hoeveelheid;
    PFQuery *query = [PFQuery queryWithClassName:login];
    [query whereKey:@"type" equalTo:@"food"];
    [query whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
    [query whereKey:@"Naam" equalTo:naam];
    [query whereKey:@"hoeveelheid" equalTo:[NSNumber numberWithFloat:[[hoeveelheid stringByReplacingOccurrencesOfString:@" g" withString:@""] floatValue]]];
    NSString *soort;
    if(indexPath.section==0){
        soort = [OntbijtType objectAtIndex:indexPath.row];
    }
    if(indexPath.section==1){
        soort = [TussendoortjeType objectAtIndex:indexPath.row];
    }
    if(indexPath.section==2){
        soort = [MiddagmaalType objectAtIndex:indexPath.row];
    }
    if(indexPath.section==3){
        soort = [VieruurtjeType objectAtIndex:indexPath.row];
    }
    if(indexPath.section==4){
        soort = [AvondmaalType objectAtIndex:indexPath.row];
    }
    childViewController.soort = soort;
    //****Naam en type****
    NSArray *results = [query findObjects];
    PFObject *result = [results objectAtIndex:0];
    childViewController.naam = [result objectForKey:@"NaamHoofd"];
    if([result objectForKey:@"NaamType"]){
        childViewController.type = [result objectForKey:@"NaamType"];
    }
    //****RESET****
    [childViewController viewWillAppear:TRUE];
    [self.Container setHidden:FALSE];
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
    //Voedingsbadge?
    if(([resultsFood count]==1) && (![names containsObject:@"Start 2 eat"])){
        PFObject *gebruiker = [PFObject objectWithClassName:login];
        gebruiker[@"type"] = @"badge";
        gebruiker[@"Naam"] = @"Start 2 eat";
        [gebruiker saveInBackground];
        newBadge = TRUE;
    }
    else if(([resultsFood count]==5)&& (![names containsObject:@"Voedsel lover"])) {
        PFObject *gebruiker = [PFObject objectWithClassName:login];
        gebruiker[@"type"] = @"badge";
        gebruiker[@"Naam"] = @"Voedsel lover";
        [gebruiker saveInBackground];
        newBadge = TRUE;
    }
    else if(([resultsFood count]==10)&& (![names containsObject:@"Voedseljunkie"])) {
        PFObject *gebruiker = [PFObject objectWithClassName:login];
        gebruiker[@"type"] = @"badge";
        gebruiker[@"Naam"] = @"Voedseljunkie";
        [gebruiker saveInBackground];
        newBadge = TRUE;
    }
    else if(([resultsFood count]==25) && (![names containsObject:@"Voedselgoeroe"])){
        PFObject *gebruiker = [PFObject objectWithClassName:login];
        gebruiker[@"type"] = @"badge";
        gebruiker[@"Naam"] = @"Voedselgoeroe";
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
