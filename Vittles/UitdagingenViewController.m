//
//  UitdagingenViewController.m
//  Vittles
//
//  Created by Anne Everars on 7/04/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "UitdagingenViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import <Parse/Parse.h>
#import "ExtraInfoUitdagingViewController.h"

@interface UitdagingenViewController ()

@end

@implementation UitdagingenViewController {
    NSMutableArray *actieveUitdagingen;
    NSMutableArray *voltooideUitdagingen;
    NSString *login;
}

@synthesize menuBtn;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
}

- (void)viewWillAppear:(BOOL)animated {
    self.actieve.delegate = self;
    self.actieve.dataSource = self;
    self.voltooide.delegate = self;
    self.voltooide.dataSource = self;
    actieveUitdagingen = [[NSMutableArray alloc] init];
    voltooideUitdagingen = [[NSMutableArray alloc] init];
    [self checkActive];
    PFQuery *uitdagingenActief = [PFQuery queryWithClassName:login];
    [uitdagingenActief whereKey:@"type" equalTo:@"Uitdaging"];
    [uitdagingenActief whereKey:@"moment" equalTo:@"Actief"];
    NSArray *results = [uitdagingenActief findObjects];
    for(PFObject *result in results) {
        NSString *naam = [result objectForKey:@"Naam"];
        [actieveUitdagingen addObject:naam];
    }
    PFQuery *uitdagingenVoltooid = [PFQuery queryWithClassName:login];
    [uitdagingenVoltooid whereKey:@"type" equalTo:@"Uitdaging"];
    [uitdagingenVoltooid whereKey:@"moment" equalTo:@"Voltooid"];
    NSArray *resultsVoltooid = [uitdagingenVoltooid findObjects];
    for(PFObject *result in resultsVoltooid) {
        NSString *naam = [result objectForKey:@"Naam"];
        [voltooideUitdagingen addObject:naam];
    }
    [self.actieve reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.actieve==tableView) {
        return actieveUitdagingen.count;
    }
    return voltooideUitdagingen.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.actieve==tableView) {
        static NSString *CellIdentifier = @"actieveCell";
        UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier: CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [actieveUitdagingen objectAtIndex:indexPath.row];
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"voltooideCell";
        UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier: CellIdentifier];
        if(cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle
                    reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [voltooideUitdagingen objectAtIndex:indexPath.row];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExtraInfoUitdagingViewController *controller = (ExtraInfoUitdagingViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"ExtraInfoUitdaging"];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *naam = selectedCell.textLabel.text;
    controller.naam = naam;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    ExtraInfoUitdagingViewController *controller = (ExtraInfoUitdagingViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"ExtraInfoUitdaging"];
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *naam = selectedCell.textLabel.text;
    controller.naam = naam;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) checkActive {
    NSString *badge;
    float extraEnergie = 0.0f;
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    //Pas de vooruitgang aan van de active uitdagingen...
    PFQuery *uitdagingenActief = [PFQuery queryWithClassName:login];
    [uitdagingenActief whereKey:@"type" equalTo:@"Uitdaging"];
    [uitdagingenActief whereKey:@"moment" equalTo:@"Actief"];
    NSArray *results = [uitdagingenActief findObjects];
    for(PFObject *result in results){
        float vooruitgang = 0.0f;
        NSString *naam = [result objectForKey:@"Naam"];
        if([naam isEqualToString:@"Als een dolfijn in het water"]) {
            //minstens 3 keer per week gaan zwemmen.
            PFQuery *query = [PFQuery queryWithClassName:login];
            [query whereKey:@"type" equalTo:@"activity"];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            [offsetComponents setDay:-7];
            NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
            [query whereKey:@"updatedAt" greaterThanOrEqualTo:sinds];
            [query whereKey:@"Naam" equalTo:@"Zwemmen"];
            NSArray *resultaten = [query findObjects];
            NSInteger aantal = [resultaten count];
            vooruitgang = aantal/3;
            if(vooruitgang>1) {
                vooruitgang = 1;
            }
            //Beloning
            badge = @"Like a dolphin";
            extraEnergie = 500.0f;
            
        }
        else if([naam isEqualToString:@"Dancing queen"]) {
            //Gedurende een maand minstens één keer per week gaan dansen.
            PFQuery *query = [PFQuery queryWithClassName:login];
            [query whereKey:@"type" equalTo:@"activity"];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSInteger vorige = 0;
            bool gefaald = false;
            while (!gefaald) {
                for(int i=1; i<5; i++) {
                    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                    [offsetComponents setDay:-(7*i)];
                    NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                    [query whereKey:@"updatedAt" greaterThanOrEqualTo:sinds];
                    [query whereKey:@"Naam" equalTo:@"Dansen"];
                    NSArray *resultaten = [query findObjects];
                    NSInteger aantal = [resultaten count];
                    if(aantal > vorige) {
                        vooruitgang += 0.25f;
                    }
                    else {
                        vooruitgang = 0.0f;
                        gefaald = true;
                    }
                    vorige = aantal;
                }

            }
            if(vooruitgang>1) {
                vooruitgang = 1;
            }
            //Beloning
            badge = @"Dancing queen";
            extraEnergie = 250.0f;
        }
        //else if([naam isEqualToString:@"Schone slaapster"]) {
            //Elke dag minstens 8u slapen.
            
            //Beloning
            //badge = @"Schone slaapster";
            //extraEnergie = 250.0f;
        //}
        else if([naam isEqualToString:@"The breakfast club"]) {
            //Gedurende een week elke dag ontbijten.
            PFQuery *query = [PFQuery queryWithClassName:login];
            [query whereKey:@"type" equalTo:@"food"];
            [query whereKey:@"moment" equalTo:@"Ontbijt"];
            BOOL stop = false;
            NSInteger vorige = 0;
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            while(!stop) {
                for(int i=0; i<8;i++) {
                    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                    [offsetComponents setDay:-i];
                    NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                    [query whereKey:@"updatedAt" greaterThanOrEqualTo:sinds];
                    NSArray *resultaten = [query findObjects];
                    NSInteger aantal = [resultaten count];
                    if(vorige > aantal) {
                        vooruitgang += 1.0f/7.0f;
                    }
                    else {
                        stop = true;
                        vooruitgang = 0.0f;
                    }
                    vorige = aantal;
                }
            }
            if(vooruitgang>1) {
                vooruitgang = 1;
            }
            //Beloning
            badge = @"The breakfast club";
            extraEnergie = 500.0f;
        }
        else if([naam isEqualToString:@"Veggie III"]) {
            //Een maand zonder vlees.
            PFQuery *query = [PFQuery queryWithClassName:login];
            [query whereKey:@"type" equalTo:@"food"];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            bool stop = false;
            while (!stop) {
                for(int i = 0; i<31; i++) {
                    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                    [offsetComponents setDay:-i];
                    NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                    [query whereKey:@"updatedAt" greaterThanOrEqualTo:sinds];
                    if([[query findObjects]count] > 0) {
                        [query whereKey:@"soort" equalTo:@"Vleesproducten"];
                        if([[query findObjects]count] <= 0) {
                            vooruitgang += 1.0f/30.0f;
                        }
                        else {
                            stop = true;
                            vooruitgang = 0.0f;
                        }
                    }
                }
            }
            //Beloning
            badge = @"Veggie addict";
            extraEnergie = 700.0f;
        }
        else if([naam isEqualToString:@"Veggie II"]) {
            //Een week zonder vlees.
            PFQuery *query = [PFQuery queryWithClassName:login];
            [query whereKey:@"type" equalTo:@"food"];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            bool stop = false;
            while (!stop) {
                for(int i = 0; i<8; i++) {
                    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                    [offsetComponents setDay:-i];
                    NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                    [query whereKey:@"updatedAt" greaterThanOrEqualTo:sinds];
                    if([[query findObjects]count] > 0) {
                        [query whereKey:@"soort" equalTo:@"Vleesproducten"];
                        if([[query findObjects]count] <= 0) {
                            vooruitgang += 1.0f/7.0f;
                        }
                        else {
                            stop = true;
                            vooruitgang = 0.0f;
                        }
                    }
                }
            }
            //Beloning
            badge = @"Veggie lover";
            extraEnergie = 250.0f;
        }
        else if([naam isEqualToString:@"Veggie I"]) {
            //Een dag zonder vlees.
            PFQuery *query = [PFQuery queryWithClassName:login];
            [query whereKey:@"type" equalTo:@"food"];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            [offsetComponents setDay:-1];
            NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
            [query whereKey:@"updatedAt" greaterThanOrEqualTo:sinds];
            if([[query findObjects]count] > 0) {
                [query whereKey:@"soort" equalTo:@"Vleesproducten"];
                if([[query findObjects]count] <= 0) {
                    vooruitgang = 1.0f;
                }
                else {
                    vooruitgang = 0.0f;
                }
            }
            //Beloning
            badge = @"Veggie fan";
            extraEnergie = 100.0f;
        }
        else if([naam isEqualToString:@"Fitness away"]) {
            //Ga drie keer per week naar de fitness.
            PFQuery *query = [PFQuery queryWithClassName:login];
            [query whereKey:@"type" equalTo:@"activity"];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            [offsetComponents setDay:-7];
            NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
            [query whereKey:@"updatedAt" greaterThanOrEqualTo:sinds];
            [query whereKey:@"Naam" equalTo:@"Fitnessen"];
            NSArray *resultaten = [query findObjects];
            NSInteger aantal = [resultaten count];
            vooruitgang = aantal/3;
            if(vooruitgang>1) {
                vooruitgang = 1;
            }
            //Beloning
            badge = @"Fitness addict";
            extraEnergie = 700.0f;
        }
        //else if([naam isEqualToString:@"McHealthy"]) {
            //Eet gedurdende één week geen snacks of fast food.
            
            //Beloning
            //badge = @"McHealthy";
            //extraEnergie = 500.0f;
        //}
        else if([naam isEqualToString:@"Ren voor je leven!"]) {
            //Ga drie keer per week gedurende minimaal 30 minuten joggen.
            PFQuery *query = [PFQuery queryWithClassName:login];
            [query whereKey:@"type" equalTo:@"activity"];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
            [offsetComponents setDay:-7];
            NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
            [query whereKey:@"updatedAt" greaterThanOrEqualTo:sinds];
            [query whereKey:@"Naam" equalTo:@"Lopen"];
            [query whereKey:@"hoeveelheid" greaterThanOrEqualTo:[NSNumber numberWithInt:30.0]];
            NSArray *resultaten = [query findObjects];
            NSInteger aantal = [resultaten count];
            vooruitgang = aantal/3;
            if(vooruitgang>1) {
                vooruitgang = 1;
            }
            //Beloning
            badge = @"Forrest gump";
            extraEnergie = 700.0f;
        }
        else if([naam isEqualToString:@"Eerst water, de rest komt later"]) {
            //Laat de koffie, frisdrank en het bier voor een week achterwege en drink enkel water. Drink minimaal 1,5l per dag.
            PFQuery *query = [PFQuery queryWithClassName:login];
            [query whereKey:@"type" equalTo:@"food"];
            [query whereKey:@"soort" equalTo:@"Dranken"];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            bool stop = 0;
            while(!stop) {
                for(int i = 0; i<8; i++) {
                    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                    [offsetComponents setDay:-i];
                    NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                    [query whereKey:@"updatedAt" greaterThanOrEqualTo:sinds];
                    [query whereKey:@"Naam" notEqualTo:@"Water"];
                    NSArray *resultaten = [query findObjects];
                    if([resultaten count] > 0) {
                        stop = true;
                        vooruitgang = 0.0f;
                    }
                    else {
                        vooruitgang += 1.0f/7.0f;
                    }
                }
                stop = true;
            }
            if(vooruitgang>1) {
                vooruitgang = 1;
            }
            //Beloning
            badge = @"Zuipschuit";
            extraEnergie = 120.0f;
        }
        
        if(vooruitgang==1) {
            result[@"moment"] = @"Voltooid";
            [result saveInBackground];
            PFQuery *queryBadges = [PFQuery queryWithClassName:login];
            [queryBadges whereKey:@"type" equalTo:@"badge"];
            NSArray *resultsBadges = [queryBadges findObjects];
            NSMutableArray *names = [[NSMutableArray alloc]init];
            for (PFObject *badge in resultsBadges) {
                [names addObject:[badge objectForKey:@"Naam"]];
            }
            if(![names containsObject:badge]) {
                PFObject *gebruiker = [PFObject objectWithClassName:login];
                gebruiker[@"type"] = @"badge";
                gebruiker[@"Naam"] = badge;
                [gebruiker saveInBackground];
                PFQuery *queryUser = [PFQuery queryWithClassName:login];
                [queryUser whereKey:@"type" equalTo:@"consumptie"];
                [queryUser whereKey:@"Naam" equalTo:@"verbruik"];
                [queryUser whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
                NSArray *resultaat = [queryUser findObjects];
                PFObject *resultaatEnergie =[resultaat objectAtIndex:0];
                NSNumber *energieTotaal = [resultaatEnergie objectForKey:@"hoeveelheid"];
                float energieWaarde = [energieTotaal floatValue] + extraEnergie;
                resultaatEnergie[@"hoeveelheid"] = [NSNumber numberWithFloat:   energieWaarde];
                [resultaatEnergie saveInBackground];
            }
        }
        else{
            result[@"vooruitgang"] = [NSNumber numberWithFloat:vooruitgang];
            [result saveInBackground];
        }
    }
}

@end
