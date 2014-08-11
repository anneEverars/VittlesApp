//
//  PersoonlijkeInstellingenViewController.m
//  Vittles
//
//  Created by Anne Everars on 4/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "PersoonlijkeInstellingenViewController.h"
#import <Parse/Parse.h>

@interface PersoonlijkeInstellingenViewController () {
    NSString *login;
}

@end

@implementation PersoonlijkeInstellingenViewController

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
    //****PICKERS****
    NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i = 0; i < 100; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%02i", i];
		[array addObject:item];
	}
    self.aantallen = array;
    array = [[NSMutableArray alloc] init];
	for (int i = 0; i < 180; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[array addObject:item];
	}
    self.aantallenGewicht = array;
    array = [[NSMutableArray alloc] init];
	for (int i = 0; i < 3; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[array addObject:item];
	}
    self.aantalMeter = array;
    self.geheelgetalGewicht.dataSource = self;
    self.geheelgetalGewicht.delegate = self;
    self.kommagetalGewicht.dataSource = self;
    self.kommagetalGewicht.delegate = self;
    self.geheelgetalLengte.dataSource = self;
    self.geheelgetalLengte.delegate = self;
    self.kommagetalLengte.dataSource = self;
    self.kommagetalLengte.delegate = self;
    //****DATABANK CONTROLEREN****
    PFQuery *queryUser = [PFQuery queryWithClassName:login];
    [queryUser whereKey:@"type" equalTo:@"profiel"];
    [queryUser whereKey:@"Naam" equalTo:@"gegevens"];
    NSArray *results = [queryUser findObjects];
    if(results.count > 0) {
        PFObject *object = [results objectAtIndex:0];
        //1. geboortedatum
        NSDate *geboortedatum = [object objectForKey:@"Datum"];
        [self.geboortedatum setDate:geboortedatum];
        //2. geslacht
        NSString *geslachtStr = [object objectForKey:@"soort"];
        if([geslachtStr isEqualToString:@"M"]) {
            [self.geslacht setOn:FALSE];
        }
        else {
            [self.geslacht setOn:TRUE];
        }
        //3. lengte
        NSNumber *lengte = [object objectForKey:@"hoeveelheid"];
        int lengtegeheelgetal = [lengte intValue];
        float komma = [lengte floatValue];
        komma = komma - lengtegeheelgetal;
        int lengtekommagetal = komma*100;
        [self.geheelgetalLengte selectRow:lengtegeheelgetal inComponent:0 animated:FALSE];
        [self.kommagetalLengte selectRow:lengtekommagetal inComponent:0 animated:FALSE];
    }
    //4. gewicht
    PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
    [queryGewicht whereKey:@"type" equalTo:@"profiel"];
    [queryGewicht whereKey:@"Naam" equalTo:@"gewicht"];
    [queryGewicht orderByDescending:@"updatedAt"];
    NSArray *resultsGewicht = [queryGewicht findObjects];
    if(resultsGewicht.count > 0) {
        PFObject *result = [resultsGewicht objectAtIndex:0];
        NSNumber *gewicht = [result objectForKey:@"hoeveelheid"];
        int gewichtgeheelgetal = [gewicht intValue];
        float komma = [gewicht floatValue];
        komma = komma - gewichtgeheelgetal;
        int gewichtkommagetal = komma*100;
        [self.geheelgetalGewicht selectRow:gewichtgeheelgetal inComponent:0 animated:FALSE];
        [self.kommagetalGewicht selectRow:gewichtkommagetal inComponent:0 animated:FALSE];
    }
    //****SWITCH****
    [self.geslacht addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    if ([self.geslacht isOn]) {
        self.man.textColor = [UIColor lightGrayColor];
        self.vrouw.textColor = [UIColor blackColor];
    }
    else {
        self.man.textColor = [UIColor blackColor];
        self.vrouw.textColor = [UIColor lightGrayColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if(self.geheelgetalGewicht==pickerView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.geheelgetalGewicht.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallenGewicht objectAtIndex:row];
        return label;
    }
    else if(self.kommagetalGewicht==pickerView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.kommagetalGewicht.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallen objectAtIndex:row];
        return label;
    }
    else if(self.geheelgetalLengte==pickerView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.geheelgetalLengte.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantalMeter objectAtIndex:row];
        return label;
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.kommagetalLengte.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallen objectAtIndex:row];
        return label;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.geheelgetalGewicht==pickerView) {
        return self.aantallenGewicht.count;
    }
    else if(self.geheelgetalLengte==pickerView) {
        return self.aantalMeter.count;
    }
    else {
        return self.aantallen.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(self.geheelgetalGewicht==pickerView) {
        return [self.aantallenGewicht objectAtIndex:row];
    }
    else if(self.geheelgetalLengte==pickerView) {
        return [self.aantalMeter objectAtIndex:row];
    }
    else {
        return [self.aantallen objectAtIndex:row];
    }
}

-(void)changeSwitch:(id)sender {
    if ([sender isOn]) {
        self.man.textColor = [UIColor lightGrayColor];
        self.vrouw.textColor = [UIColor blackColor];
    }
    else {
        self.man.textColor = [UIColor blackColor];
        self.vrouw.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)save:(id)sender {
    NSDate *geboorte = [self.geboortedatum date];
    NSString *geslachtStr = @"M";
    if([self.geslacht isOn]) {
        geslachtStr = @"V";
    }
    NSNumber *hoeveelheid = 0;
    if(([self.geheelgetalLengte selectedRowInComponent:0] >0) || ([self.kommagetalLengte selectedRowInComponent:0] >0)) {
        float geheelGetalLengte = [self.geheelgetalLengte selectedRowInComponent:0];
        float kommaGetalLengte = [self.kommagetalLengte selectedRowInComponent:0];
        float lengte = (kommaGetalLengte/(100.0f));
        lengte = lengte + geheelGetalLengte;
        hoeveelheid = [NSNumber numberWithFloat:lengte];
    }
    PFQuery *queryUser = [PFQuery queryWithClassName:login];
    [queryUser whereKey:@"type" equalTo:@"profiel"];
    [queryUser whereKey:@"Naam" equalTo:@"gegevens"];
    NSArray *results = [queryUser findObjects];
    if(results.count > 0) {
        PFObject *update = [results objectAtIndex:0];
        update[@"hoeveelheid"] = hoeveelheid;
        update[@"Datum"] = geboorte;
        update[@"soort"] = geslachtStr;
        [update saveInBackground];
    }
    else {
        PFObject *update = [PFObject objectWithClassName:login];
        update[@"type"] = @"profiel";
        update[@"Naam"] = @"gegevens";
        update[@"hoeveelheid"] = hoeveelheid;
        update[@"Datum"] = geboorte;
        update[@"soort"] = geslachtStr;
        [update saveInBackground];
    }
    //****Gewicht****
    if(([self.geheelgetalGewicht selectedRowInComponent:0] >0) || ([self.kommagetalGewicht selectedRowInComponent:0] >0)) {
        float geheelGetalGewicht = [self.geheelgetalGewicht selectedRowInComponent:0];
        float kommaGetalGewicht = [self.kommagetalGewicht selectedRowInComponent:0];
        float gewicht = (kommaGetalGewicht/(100.0f));
        gewicht = gewicht + geheelGetalGewicht;
        NSNumber *hoeveelheid = [NSNumber numberWithFloat:gewicht];
        PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
        [queryGewicht whereKey:@"type" equalTo:@"profiel"];
        [queryGewicht whereKey:@"Naam" equalTo:@"gewicht"];
        [queryGewicht orderByAscending:@"updatedAt"];
        NSArray *resultsGewicht = [queryGewicht findObjects];
        if(resultsGewicht.count > 0) {
            PFObject *gewichtUpdate = [resultsGewicht objectAtIndex:0];
            gewichtUpdate[@"hoeveelheid"] = hoeveelheid;
            [gewichtUpdate saveInBackground];
        }
        else {
            PFObject *gewichtUpdate = [PFObject objectWithClassName:login];
            gewichtUpdate[@"type"] = @"profiel";
            gewichtUpdate[@"Naam"] = @"gewicht";
            gewichtUpdate[@"hoeveelheid"] = hoeveelheid;
            [gewichtUpdate saveInBackground];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succes!"
                                                    message:@"Wijzigingen opgeslagen"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
