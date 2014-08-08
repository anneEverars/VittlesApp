//
//  FlipsideActiviteitenViewController.m
//  Vittles
//
//  Created by Anne Everars on 28/05/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "FlipsideActiviteitenViewController.h"
#import "ActivityAddViewController.h"
#import <Parse/Parse.h>

@interface FlipsideActiviteitenViewController ()

@end

@implementation FlipsideActiviteitenViewController {
    NSArray *categorien;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) awakeFromNib {
    self.preferredContentSize = CGSizeMake(540.0, 420.0);
    [super awakeFromNib];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    //Soorten activiteiten
    categorien = [[NSArray alloc] initWithObjects:@"Kies een soort...", @"Sporten", @"Vrijetijd", @"Andere", nil];
    self.soortenPicker.delegate = self;
    self.soortenPicker.dataSource = self;
    

	//Energiewaarde picker
	for (int i = 0; i < 999; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[array addObject:item];
	}
	self.aantallen = array;
    self.geheelgetal.delegate = self;
    self.geheelgetal.dataSource = self;
    self.kommagetal.delegate = self;
    self.kommagetal.dataSource = self;
}


-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.geheelgetal.frame.size.width, pickerView.frame.size.height)];
    if(self.kommagetal == pickerView){
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.kommagetal.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [self.aantallen objectAtIndex:row];
    }
    else if(self.geheelgetal == pickerView) {
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallen objectAtIndex:row];
    }
    else {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.soortenPicker.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [categorien objectAtIndex:row];
    }
    return label;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(self.soortenPicker == pickerView) {
        return categorien.count;
    }
    else {
        return self.aantallen.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(self.soortenPicker == pickerView) {
        return [categorien objectAtIndex:row];
    }
    else {
        return [self.aantallen objectAtIndex:row];
    }
}

-(IBAction)done:(id)sender {
    //Kijk of alle velden ingevuld zijn
    BOOL verdergaan = FALSE;
    if(self.naamText.text && self.naamText.text.length > 0) {
        if(![self.soortenPicker selectedRowInComponent:0]==0) {
            if((![self.geheelgetal selectedRowInComponent:0]==0) || (![self.kommagetal selectedRowInComponent:0] == 0)) {
                verdergaan = true;
            }
        }
    }
    //Bewaar de opgeslagen data
    if(verdergaan){
        self.naamText.layer.cornerRadius=8.0f;
        self.naamText.layer.masksToBounds=YES;
        self.naamText.layer.borderWidth = 1.0f;
        self.naamText.layer.borderColor = [[UIColor clearColor]CGColor];
        NSString *naam = self.naamText.text;
        float geheelGetal = [self.geheelgetal selectedRowInComponent:0];
        float kommaGetal = [self.kommagetal selectedRowInComponent:0];
        float energie = (kommaGetal/(100.0f));
        energie = energie + geheelGetal;
        NSNumber *hoeveelheid = [NSNumber numberWithFloat:energie];
        PFObject *item = [PFObject objectWithClassName:@"ActiviteitenToAdd"];
        item[@"type"] = [categorien objectAtIndex:[self.soortenPicker selectedRowInComponent:0]];
        item[@"Naam"] = naam;
        item[@"energie"] = hoeveelheid;
        [item saveInBackground];
        //keer terug
        [self.delegate flipsideViewControllerDidFinishAdding:self];
    }
    else {
        if(!self.naamText.text || self.naamText.text.length <= 0) {
            self.naamText.layer.cornerRadius=8.0f;
            self.naamText.layer.masksToBounds=YES;
            self.naamText.layer.borderWidth = 1.0f;
            self.naamText.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else {
            self.naamText.layer.borderColor = [[UIColor clearColor]CGColor];
        }
        if([self.soortenPicker selectedRowInComponent:0]==0) {
            self.typelabel.textColor = [UIColor redColor];
        }
        else {
            self.typelabel.textColor = [UIColor blackColor];
        }
        if((![self.geheelgetal selectedRowInComponent:0]==0) || (![self.kommagetal selectedRowInComponent:0] == 0)) {
            self.energieverbruiklabel.textColor = [UIColor blackColor];
        }
        else {
            self.energieverbruiklabel.textColor = [UIColor redColor];
        }
    }
}

- (IBAction)cancel:(id)sender {
    [self.delegate flipsideViewControllerDidFinishCancel:self];
}


@end
