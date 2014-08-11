//
//  ExtraInfoActivitieitViewController.m
//  Vittles
//
//  Created by Anne Everars on 17/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "ExtraInfoActivitieitViewController.h"
#import "ActivityViewController.h"
#import "CustomCell.h"
#import <Parse/Parse.h>
#import "ECSlidingViewController.h"

@interface ExtraInfoActivitieitViewController () {
    BOOL slapenChecked;
    BOOL rustenChecked;
    NSString *login;
}

@end

@implementation ExtraInfoActivitieitViewController

@synthesize slapenCheckbox;
@synthesize rustenCheckbox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Gebruiker
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i = 0; i < 999; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%02i", i];
		[array addObject:item];
	}
	self.aantallen = array;
    slapenChecked = NO;
    rustenChecked = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.aantal.frame.size.width, pickerView.frame.size.height)];
    label.font = [UIFont fontWithName:@"System" size:19];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = [self.aantallen objectAtIndex:row];
    return label;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.aantallen.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.aantallen objectAtIndex:row];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.soorten.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"typeCell";
    CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!Cell) {
        Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Cell.textLabel.text = [self.soorten objectAtIndex:indexPath.row];
        
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    NSString *naam = self.ItemLabel.text;
    PFQuery *query = [PFQuery queryWithClassName:@"Activiteiten"];
    [query whereKey:@"Naam" equalTo:naam];
    [query whereKey:@"soort" equalTo:cellText];
    NSArray *result = [query findObjects];
    PFObject *object = [result objectAtIndex:0];
    double energieNumber =[[object objectForKey:@"energie"]doubleValue];
    PFQuery *query2 = [PFQuery queryWithClassName:login];
    [query2 whereKey:@"type" equalTo:@"profiel"];
    [query2 whereKey:@"Naam" equalTo:@"gewicht"];
    [query2 orderByDescending:@"updatedAt"];
    NSArray *result2 = [query2 findObjects];
    PFObject *gewichtR = [result2 objectAtIndex:0];
    double gewicht = [[gewichtR objectForKey:@"hoeveelheid"] doubleValue];
    double energieNr = energieNumber*gewicht/6;
    NSString *energie = [[NSString stringWithFormat:@"%.2f", energieNr] stringByReplacingOccurrencesOfString:@"." withString:@","];
    self.energie.text = energie;
}

- (IBAction)VoegToe:(id)sender {
    float aantalMin = [self.aantal selectedRowInComponent:0];
    if(aantalMin > 0) {
        NSString *energieS = self.energie.text;
        float energie = [energieS floatValue];
        float totaleEnergie = (energie/10)*aantalMin;
        PFObject *activiteit = [PFObject objectWithClassName:login];
        activiteit[@"type"] = @"activity";
        activiteit[@"Naam"] = self.ItemLabel.text;
        activiteit[@"hoeveelheid"] = [NSNumber numberWithFloat:aantalMin];
        activiteit[@"energie"] = [NSNumber numberWithFloat:totaleEnergie];
        float energieverlies  = 0.0f;
        PFQuery *queryUserGewicht = [PFQuery queryWithClassName:login];
        [queryUserGewicht whereKey:@"type" equalTo:@"profiel"];
        [queryUserGewicht whereKey:@"Naam" equalTo:@"gewicht"];
        [queryUserGewicht orderByDescending:@"updatedAt"];
        NSArray *results = [queryUserGewicht findObjects];
        PFObject *resultaatGewicht = [results objectAtIndex:0];
        NSNumber *gewicht = [resultaatGewicht objectForKey:@"hoeveelheid"];
        float kg = [gewicht floatValue];
        if(slapenChecked) {
            activiteit[@"moment"] = @"slapen";
            energieverlies = 0.95/60*kg*aantalMin;
        }
        else {
            activiteit[@"moment"] = @"rusten";
            energieverlies = 1.04/60*kg*aantalMin;
        }
        [activiteit saveInBackground];
        //update caloriewaarde
        PFQuery *queryUser = [PFQuery queryWithClassName:login];
        [queryUser whereKey:@"type" equalTo:@"consumptie"];
        [queryUser whereKey:@"Naam" equalTo:@"verbruik"];
        unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
        NSDate* dateOnly = [calendar dateFromComponents:components];
        [queryUser whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
        NSArray *resultaat = [queryUser findObjects];
        if([resultaat count] > 0) {
            PFObject *resultaatEnergie =[resultaat objectAtIndex:0];
            NSNumber *energieTotaal = [resultaatEnergie objectForKey:@"hoeveelheid"];
            float energieWaarde = [energieTotaal floatValue] + totaleEnergie - energieverlies;
            resultaatEnergie[@"hoeveelheid"] = [NSNumber numberWithFloat:energieWaarde];
            [resultaatEnergie saveInBackground];
        }
        else {
            PFObject *opname = [PFObject objectWithClassName:login];
            opname[@"type"] = @"consumptie";
            opname[@"Naam"] = @"verbruik";
            float standaardEnergie = (0.95/60*kg*720)+(1.04/60*kg*720);
            float energieWaarde = standaardEnergie + totaleEnergie - energieverlies;
            opname[@"hoeveelheid"] = [NSNumber numberWithFloat:energieWaarde];
            [opname saveInBackground];
        }
    }
    //Ga terug naar activiteitenlogboek
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Activiteitenlogboek"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)SlapenCheckbox:(id)sender {
    if(slapenChecked) {
        [slapenCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        [rustenCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        slapenChecked = NO;
        rustenChecked = YES;
    }
    else {
        [slapenCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [rustenCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        slapenChecked = YES;
        rustenChecked = NO;
    }
}

- (IBAction)RustenCheckbox:(id)sender {
    if(rustenChecked) {
        [slapenCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        [rustenCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        rustenChecked = NO;
        slapenChecked = YES;
    }
    else {
        [slapenCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
        [rustenCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
        rustenChecked = YES;
        slapenChecked = NO;
    }
}

@end
