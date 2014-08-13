//
//  ExtraInfoViewController.m
//  Vittles
//
//  Created by Anne Everars on 15/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "ExtraInfoFoodViewController.h"
#import "FoodViewController.h"
#import <Parse/Parse.h>
#import "ECSlidingViewController.h"
#import "CustomCell.h"

@interface ExtraInfoFoodViewController () {
    NSString *login;
    NSDate* dateOnly;
    NSString *geselecteerdeSoort;
}

@end

@implementation ExtraInfoFoodViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    //****Datum****
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    dateOnly = [calendar dateFromComponents:components];
    
    self.soorten = [[NSMutableArray alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < 999; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[array addObject:item];
	}
	self.aantallen = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.aantal.frame.size.width, pickerView.frame.size.height)];
    if(self.soortenPicker == pickerView){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.soortenPicker.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self.soorten objectAtIndex:row];
    }
    else {
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallen objectAtIndex:row];
    }
    return label;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.soortenPicker == pickerView){
        return self.soorten.count;
    }
    else {
        return self.aantallen.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(self.soortenPicker == pickerView){
        return [self.soorten objectAtIndex:row];
    }
    else {
        return [self.aantallen objectAtIndex:row];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.soortenProduct.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"typeCell";
    CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!Cell) {
        Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Cell.textLabel.text = [self.soortenProduct objectAtIndex:indexPath.row];
    return Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    geselecteerdeSoort = cellText;
    NSString *naam = self.ItemLabel.text;
    NSString *cat = [self.type stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    cat = [cat stringByReplacingOccurrencesOfString: @"ë" withString:@"_"];
    PFQuery *query = [PFQuery queryWithClassName:cat];
    [query whereKey:@"Naam" equalTo:naam];
    [query whereKey:@"Soort" equalTo:cellText];
    NSArray *result = [query findObjects];
    self.soorten = [[NSMutableArray alloc]init];
    for (PFObject *object in result) {
        NSString *inhoud = object[@"Inhoud"];
        if(![self.soorten containsObject:inhoud]) {
            [self.soorten addObject:inhoud];
        }
    }
    [self.soorten addObject:@"g"];
    [self.soortenPicker reloadAllComponents];
    PFObject *object = [result objectAtIndex:0];
    NSNumber *calorien = [object objectForKey:@"energie"];
    NSNumber *eiwitten = [object objectForKey:@"eiwitten"];
    NSNumber *koolhydraten = [object objectForKey:@"koolhydraten"];
    NSNumber *vetten = [object objectForKey:@"vetten"];
    self.energie.text = [[calorien stringValue] stringByReplacingOccurrencesOfString:@"." withString:@","];
    self.eiwitten.text = [[[eiwitten stringValue] stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" g"];
    self.vetten.text = [[[vetten stringValue] stringByReplacingOccurrencesOfString:@"." withString:@","]stringByAppendingString:@" g"];
    self.koolhydraten.text = [[[koolhydraten stringValue] stringByReplacingOccurrencesOfString:@"." withString:@","]stringByAppendingString:@" g"];
}

- (IBAction)VoegToe:(id)sender {
    NSString *soort = [self.soorten objectAtIndex:[self.soortenPicker selectedRowInComponent:0]];
    NSString *cat = [self.type stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    cat = [cat stringByReplacingOccurrencesOfString: @"ë" withString:@"_"];
    PFQuery *query = [PFQuery queryWithClassName:cat];
    NSString *naamItem = self.ItemLabel.text;
    NSString *naamDB = naamItem;
    [query whereKey:@"Naam" equalTo:naamItem];
    if(geselecteerdeSoort) {
        [query whereKey:@"Soort" equalTo:geselecteerdeSoort];
        naamDB = [[naamDB stringByAppendingString:@" "] stringByAppendingString:geselecteerdeSoort];
    }
    if([soort compare:@"g"] == 0) {
        NSArray *result = [query findObjects];
        PFObject *item = [result objectAtIndex:0];
        NSNumber *calorie = [item objectForKey:@"energie"];
        double calorieD = [calorie doubleValue];
        float aantal = [self.aantal selectedRowInComponent:0];
        double verbruikD = calorieD*(aantal/100);
        NSNumber *verbruik = [[NSNumber alloc]initWithDouble:verbruikD];
        NSNumber *hoeveelheid = [[NSNumber alloc]initWithDouble:(aantal)];
        if([hoeveelheid intValue] > 0){
            PFObject *eten = [PFObject objectWithClassName:login];
            eten[@"type"] = @"food";
            eten[@"Naam"] = naamDB;
            eten[@"NaamHoofd"] = self.ItemLabel.text;
            if(geselecteerdeSoort) {
                eten[@"NaamType"] = geselecteerdeSoort;
            }
            eten[@"hoeveelheid"] = hoeveelheid;
            eten[@"energie"] = verbruik;
            eten[@"moment"] = self.moment;
            eten[@"soort"] = self.type;
            [eten saveInBackground];
            //update caloriewaarde
            PFQuery *queryUser = [PFQuery queryWithClassName:login];
            [queryUser whereKey:@"type" equalTo:@"consumptie"];
            [queryUser whereKey:@"Naam" equalTo:@"opname"];
            [queryUser whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
            NSArray *resultaat = [queryUser findObjects];
            if([resultaat count] > 0) {
                PFObject *resultaatEnergie =[resultaat objectAtIndex:0];
                NSNumber *energieTotaal = [resultaatEnergie objectForKey:@"hoeveelheid"];
                double energieWaarde = [energieTotaal doubleValue] + verbruikD;
                energieTotaal = [NSNumber numberWithDouble:energieWaarde];
                resultaatEnergie[@"hoeveelheid"] = energieTotaal;
                [resultaatEnergie saveInBackground];
            }
            else {
                PFObject *opname = [PFObject objectWithClassName:login];
                opname[@"type"] = @"consumptie";
                opname[@"Naam"] = @"opname";
                opname[@"hoeveelheid"] = verbruik;
                [opname saveInBackground];
            }
        }

    }
    else {
        [query whereKey:@"Inhoud" equalTo:soort];
        NSArray *result = [query findObjects];
        PFObject *item = [result objectAtIndex:0];
        NSNumber *grootte = [item objectForKey:@"grootte"];
        double grootteD = [grootte doubleValue];
        NSNumber *calorie = [item objectForKey:@"energie"];
        double calorieD = [calorie doubleValue];
        int aantal = (int)[self.aantal selectedRowInComponent:0];
        double verbruikD = calorieD*(grootteD/100)*aantal;
        NSNumber *verbruik = [[NSNumber alloc]initWithDouble:verbruikD];
        NSNumber *hoeveelheid = [[NSNumber alloc]initWithDouble:(grootteD*aantal)];
        if([hoeveelheid intValue] > 0){
            PFObject *eten = [PFObject objectWithClassName:login];
            eten[@"type"] = @"food";
            eten[@"Naam"] = naamDB;
            eten[@"NaamHoofd"] = self.ItemLabel.text;
            if(geselecteerdeSoort) {
                eten[@"NaamType"] = geselecteerdeSoort;
            }
            eten[@"hoeveelheid"] = hoeveelheid;
            eten[@"energie"] = verbruik;
            eten[@"moment"] = self.moment;
            eten[@"soort"] = self.type;
            [eten saveInBackground];
            //update caloriewaarde
            PFQuery *queryUser = [PFQuery queryWithClassName:login];
            [queryUser whereKey:@"type" equalTo:@"consumptie"];
            [queryUser whereKey:@"Naam" equalTo:@"opname"];
            [queryUser whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
            NSArray *resultaat = [queryUser findObjects];
            if([resultaat count] > 0) {
                PFObject *resultaatEnergie =[resultaat objectAtIndex:0];
                NSNumber *energieTotaal = [resultaatEnergie objectForKey:@"hoeveelheid"];
                double energieWaarde = [energieTotaal doubleValue] + verbruikD;
                energieTotaal = [NSNumber numberWithDouble:energieWaarde];
                resultaatEnergie[@"hoeveelheid"] = energieTotaal;
                [resultaatEnergie saveInBackground];
            }
            else {
                PFObject *opname = [PFObject objectWithClassName:login];
                opname[@"type"] = @"consumptie";
                opname[@"Naam"] = @"opname";
                opname[@"hoeveelheid"] = verbruik;
                [opname save];
            }
        }
    }
    //Ga terug naar voedingsdagboek
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Voedingsdagboek"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
