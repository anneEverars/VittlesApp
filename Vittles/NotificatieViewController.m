//
//  NotificatieViewController.m
//  Vittles
//
//  Created by Anne Everars on 4/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "NotificatieViewController.h"
#import <Parse/Parse.h>

@interface NotificatieViewController (){
    BOOL voedingChecked;
    BOOL activiteitenChecked;
    BOOL vooruitgangChecked;
    NSString *login;
}

@end

@implementation NotificatieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    //****Gebruiker****
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    
    voedingChecked = YES;
    activiteitenChecked = YES;
    vooruitgangChecked = YES;
    //****DATABANK****
    PFQuery *queryUser = [PFQuery queryWithClassName:login];
    [queryUser whereKey:@"type" equalTo:@"profiel"];
    [queryUser whereKey:@"Naam" equalTo:@"notificatie"];
    NSArray *results = [queryUser findObjects];
    if(results.count > 0) {
        PFObject *object = [results objectAtIndex:0];
        //1. staat schakelaar aan?
        NSString *aan = [object objectForKey:@"aan"];
        if([aan isEqualToString:@"Ja"]) {
            [self.schakelaar setOn:TRUE];
            //2. voeding?
            NSNumber *voeding = [object objectForKey:@"voedingChecked"];
            if([voeding isEqualToNumber:[NSNumber numberWithInt:1]]) {
                NSDate *datum = [object objectForKey:@"voeding"];
                [self.voedingsuur setDate:datum];
            }
            else {
                voedingChecked = NO;
            }
            [self checkVoeding];
            //3. activiteiten?
            NSNumber *activiteiten = [object objectForKey:@"activiteitenChecked"];
            if([activiteiten isEqualToNumber:[NSNumber numberWithInt:1]]) {
                NSDate *datum = [object objectForKey:@"activiteiten"];
                [self.activiteitenuur setDate:datum];
            }
            else {
                activiteitenChecked = NO;
            }
            [self checkActiviteiten];
            //4. vooruitgang?
            NSNumber *vooruitgang = [object objectForKey:@"vooruitgangChecked"];
            if([vooruitgang isEqualToNumber:[NSNumber numberWithInt:1]]) {
                NSDate *datum = [object objectForKey:@"vooruitgangUUR"];
                [self.vooruitganguur setDate:datum];
            }
            else {
                vooruitgangChecked = NO;
            }
            [self checkVooruitgang];
        }
        else {
            [self.schakelaar setOn:FALSE];
        }
    }
    //****INVULLEN****
    [self.schakelaar addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    if([self.schakelaar isOn]) {
        self.uitLabel.textColor = [UIColor lightGrayColor];
        self.aanLabel.textColor = [UIColor blackColor];
        //1. voeding aan?
        [self checkVoeding];
        //2. activiteiten aan?
        [self checkActiviteiten];
        //3. vooruitgang aan?
        [self checkVooruitgang];
    }
    else {
        self.uitLabel.textColor = [UIColor blackColor];
        self.aanLabel.textColor = [UIColor lightGrayColor];
        //1. voeding
        [self.voedingInvullen setHidden:TRUE];
        [self.VoedingCheckbox setHidden:TRUE];
        [self.voedingsdagboekDagelijks setHidden:TRUE];
        [self.voedingsuur setHidden:TRUE];
        [self.voedingUurLabel setHidden:TRUE];
        //2. activiteiten
        [self.activiteitenInvullen setHidden:TRUE];
        [self.AchtiviteitenCheckbox setHidden:TRUE];
        [self.activiteitenlogboekDagelijks setHidden:TRUE];
        [self.activiteitenuur setHidden:TRUE];
        [self.activiteitenUurLabel setHidden:TRUE];
        //3. vooruitgang
        [self.vooruitgangInvullen setHidden:TRUE];
        [self.VooruitgangCheckbox setHidden:TRUE];
        [self.vooruitgangDagelijks setHidden:TRUE];
        [self.vooruitganguur setHidden:TRUE];
        [self.vooruitgangUurLabel setHidden:TRUE];
    }
}

-(void)changeSwitch:(id)sender {
    if([self.schakelaar isOn]) {
        self.uitLabel.textColor = [UIColor lightGrayColor];
        self.aanLabel.textColor = [UIColor blackColor];
        //1. voeding
        [self.voedingInvullen setHidden:FALSE];
        [self.VoedingCheckbox setHidden:FALSE];
        [self checkVoeding];
        //2. activiteiten
        [self.activiteitenInvullen setHidden:FALSE];
        [self.AchtiviteitenCheckbox setHidden:FALSE];
        [self checkActiviteiten];
        //3. vooruitgang
        [self.vooruitgangInvullen setHidden:FALSE];
        [self.VooruitgangCheckbox setHidden:FALSE];
        [self checkVooruitgang];
    }
    else {
        self.uitLabel.textColor = [UIColor blackColor];
        self.aanLabel.textColor = [UIColor lightGrayColor];
        //1. voeding
        [self.voedingInvullen setHidden:TRUE];
        [self.VoedingCheckbox setHidden:TRUE];
        [self.voedingsdagboekDagelijks setHidden:TRUE];
        [self.voedingsuur setHidden:TRUE];
        [self.voedingUurLabel setHidden:TRUE];
        //2. activiteiten
        [self.activiteitenInvullen setHidden:TRUE];
        [self.AchtiviteitenCheckbox setHidden:TRUE];
        [self.activiteitenlogboekDagelijks setHidden:TRUE];
        [self.activiteitenuur setHidden:TRUE];
        [self.activiteitenUurLabel setHidden:TRUE];
        //3. vooruitgang
        [self.vooruitgangInvullen setHidden:TRUE];
        [self.VooruitgangCheckbox setHidden:TRUE];
        [self.vooruitgangDagelijks setHidden:TRUE];
        [self.vooruitganguur setHidden:TRUE];
        [self.vooruitgangUurLabel setHidden:TRUE];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)voedingClick:(id)sender {
    if(voedingChecked) {
        voedingChecked = NO;
    }
    else {
        voedingChecked = YES;
    }
    [self checkVoeding];
}

- (IBAction)activiteitenClick:(id)sender {
    if(activiteitenChecked) {
        activiteitenChecked = NO;
    }
    else {
        activiteitenChecked = YES;
    }
    [self checkActiviteiten];
}

- (IBAction)vooruitgangClick:(id)sender {
    if(vooruitgangChecked) {
        vooruitgangChecked = NO;
    }
    else {
        vooruitgangChecked = YES;
    }
    [self checkVooruitgang];
}

-(void) checkVoeding {
    if(voedingChecked) {
        [self.VoedingCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [self.voedingInvullen setHidden:FALSE];
        [self.voedingsdagboekDagelijks setHidden:FALSE];
        [self.voedingsuur setHidden:FALSE];
        [self.voedingUurLabel setHidden:FALSE];
    }
    else {
        [self.VoedingCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        [self.voedingInvullen setHidden:FALSE];
        [self.voedingsdagboekDagelijks setHidden:TRUE];
        [self.voedingsuur setHidden:TRUE];
        [self.voedingUurLabel setHidden:TRUE];
    }
}

-(void) checkActiviteiten {
    if(activiteitenChecked) {
        [self.AchtiviteitenCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [self.activiteitenInvullen setHidden:FALSE];
        [self.activiteitenlogboekDagelijks setHidden:FALSE];
        [self.activiteitenuur setHidden:FALSE];
        [self.activiteitenUurLabel setHidden:FALSE];
    }
    else {
        [self.AchtiviteitenCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        [self.activiteitenInvullen setHidden:FALSE];
        [self.activiteitenlogboekDagelijks setHidden:TRUE];
        [self.activiteitenuur setHidden:TRUE];
        [self.activiteitenUurLabel setHidden:TRUE];
    }
}

-(void) checkVooruitgang {
    if(vooruitgangChecked) {
        [self.VooruitgangCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [self.vooruitgangInvullen setHidden:FALSE];
        [self.vooruitgangDagelijks setHidden:FALSE];
        [self.vooruitganguur setHidden:FALSE];
        [self.vooruitgangUurLabel setHidden:FALSE];
    }
    else {
        [self.VooruitgangCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        [self.vooruitgangInvullen setHidden:FALSE];
        [self.vooruitgangDagelijks setHidden:TRUE];
        [self.vooruitganguur setHidden:TRUE];
        [self.vooruitgangUurLabel setHidden:TRUE];
    }
}

- (IBAction)save:(id)sender {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if([self.schakelaar isOn]) {
        if(voedingChecked) {
            NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
            [datePickerFormat setDateFormat:@"HH"];
            int uur = [[datePickerFormat stringFromDate:self.voedingsuur.date] intValue];
            datePickerFormat = [[NSDateFormatter alloc] init];
            [datePickerFormat setDateFormat:@"MM"];
            int minuten = [[datePickerFormat stringFromDate:self.voedingsuur.date] intValue];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
            [components setHour:uur];
            [components setMinute:minuten];
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            if (!localNotification) {
                return;
            }
            localNotification.fireDate = [calendar dateFromComponents:components];
            [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
            [localNotification setAlertAction:@"openen"];
            [localNotification setAlertBody:@"Heb je je maaltijd al ingegeven?"];
            [localNotification setSoundName:UILocalNotificationDefaultSoundName];
            [localNotification setRepeatInterval:NSDayCalendarUnit];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        if(activiteitenChecked) {
            NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
            [datePickerFormat setDateFormat:@"HH"];
            int uur = [[datePickerFormat stringFromDate:self.activiteitenuur.date] intValue];
            datePickerFormat = [[NSDateFormatter alloc] init];
            [datePickerFormat setDateFormat:@"MM"];
            int minuten = [[datePickerFormat stringFromDate:self.activiteitenuur.date] intValue];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
            [components setHour:uur];
            [components setMinute:minuten];
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            if (!localNotification) {
                return;
            }
            localNotification.fireDate = [calendar dateFromComponents:components];
            [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
            [localNotification setAlertAction:@"openen"];
            [localNotification setAlertBody:@"Heb je je uitgevoerde activiteiten al ingegeven?"];
            [localNotification setSoundName:UILocalNotificationDefaultSoundName];
            [localNotification setRepeatInterval:NSDayCalendarUnit];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        if(vooruitgangChecked) {
            NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
            [datePickerFormat setDateFormat:@"HH"];
            int uur = [[datePickerFormat stringFromDate:self.vooruitganguur.date] intValue];
            datePickerFormat = [[NSDateFormatter alloc] init];
            [datePickerFormat setDateFormat:@"MM"];
            int minuten = [[datePickerFormat stringFromDate:self.vooruitganguur.date] intValue];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
            [components setHour:uur];
            [components setMinute:minuten];
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            if (!localNotification) {
                return;
            }
            localNotification.fireDate = [calendar dateFromComponents:components];
            [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
            [localNotification setAlertAction:@"openen"];
            [localNotification setAlertBody:@"Heb je je vooruitgang al aangegeven?"];
            [localNotification setSoundName:UILocalNotificationDefaultSoundName];
            [localNotification setRepeatInterval:NSDayCalendarUnit];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
    //opslaan op databank
    PFQuery *queryNotificatie = [PFQuery queryWithClassName:login];
    NSArray *results = [queryNotificatie findObjects];
    if(results.count > 0) {
        PFObject *update = [results objectAtIndex:0];
        if([self.schakelaar isOn]) {
            update[@"aan"] = @"Ja";
            update[@"voedingChecked"] = [NSNumber numberWithBool:voedingChecked];
            update[@"activiteitenChecked"] = [NSNumber numberWithBool:activiteitenChecked];
            update[@"vooruitgangChecked"] = [NSNumber numberWithBool:vooruitgangChecked];
            if(voedingChecked) {
                update[@"voeding"] = [self.voedingsuur date];
            }
            if(activiteitenChecked) {
                update[@"activiteiten"] = [self.activiteitenuur date];
            }
            if(vooruitgangChecked) {
                update[@"vooruitgangUUR"] = [self.vooruitganguur date];
            }
        }
        else {
            update[@"aan"] = @"Nee";
        }
        [update saveInBackground];
    }
    else {
        PFObject *update = [PFObject objectWithClassName:login];
        update[@"type"] = @"profiel";
        update[@"Naam"] = @"notificatie";
        update[@"voedingChecked"] = [NSNumber numberWithBool:voedingChecked];
        update[@"activiteitenChecked"] = [NSNumber numberWithBool:activiteitenChecked];
        update[@"vooruitgangChecked"] = [NSNumber numberWithBool:vooruitgangChecked];
        if([self.schakelaar isOn]) {
            update[@"aan"] = @"Ja";
            if(voedingChecked) {
                update[@"voeding"] = [self.voedingsuur date];
            }
            if(activiteitenChecked) {
                update[@"activiteiten"] = [self.activiteitenuur date];
            }
            if(vooruitgangChecked) {
                update[@"vooruitgangUUR"] = [self.vooruitganguur date];
            }
        }
        else {
            update[@"aan"] = @"Nee";
        }
        [update saveInBackground];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succes!"
                                                    message:@"Wijzigingen opgeslagen"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
