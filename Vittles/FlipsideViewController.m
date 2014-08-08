//
//  FlipsideViewController.m
//  Vittles
//
//  Created by Anne Everars on 27/05/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "FoodAddViewController.h"
#import "FlipsideViewController.h"
#import <Parse/Parse.h>

@interface FlipsideViewController ()

@end
@implementation FlipsideViewController

-(void) awakeFromNib {
    self.preferredContentSize = CGSizeMake(560.0,470.0);
    [super awakeFromNib];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 999; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[array addObject:item];
	}
    self.aantallen = array;
    self.geheelgetalEnergie.dataSource = self;
    self.geheelgetalEnergie.delegate = self;
    self.geheelgetalEiwit.dataSource = self;
    self.geheelgetalEiwit.delegate = self;
    self.geheelgetalVet.dataSource = self;
    self.geheelgetalVet.delegate = self;
    self.geheelgetalKoolh.dataSource = self;
    self.geheelgetalKoolh.delegate = self;
    self.kommagetalEnergie.dataSource = self;
    self.kommagetalEnergie.delegate = self;
    self.kommagetalEiwit.dataSource = self;
    self.kommagetalEiwit.delegate = self;
    self.kommagetalVet.dataSource = self;
    self.kommagetalVet.delegate = self;
    self.kommagetalKoolh.dataSource = self;
    self.kommagetalKoolh.delegate = self;
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, pickerView.frame.size.height)];
    label.font = [UIFont fontWithName:@"System" size:19];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = [self.aantallen objectAtIndex:row];
    return label;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.aantallen.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.aantallen objectAtIndex:row];
}

-(IBAction)done:(id)sender {
    //Kijk of alle velden ingevuld zijn
    BOOL verdergaan = FALSE;
    if(self.naam.text && self.naam.text.length > 0) {
        if((![self.geheelgetalEnergie selectedRowInComponent:0]==0) || (![self.kommagetalEnergie selectedRowInComponent:0] == 0)) {
            if((![self.geheelgetalEiwit selectedRowInComponent:0]==0) || (![self.kommagetalEiwit selectedRowInComponent:0] == 0)) {
                if((![self.geheelgetalVet selectedRowInComponent:0]==0) || (![self.kommagetalVet selectedRowInComponent:0] == 0)) {
                    if((![self.geheelgetalKoolh selectedRowInComponent:0]==0) || (![self.kommagetalKoolh selectedRowInComponent:0] == 0)) {
                        verdergaan = true;
                    }
                }
            }
        }
    }
    //Bewaar de opgeslagen data
    if(verdergaan){
        self.naam.layer.cornerRadius=8.0f;
        self.naam.layer.masksToBounds=YES;
        self.naam.layer.borderWidth = 1.0f;
        self.naam.layer.borderColor = [[UIColor clearColor]CGColor];
        NSString *naamString = self.naam.text;
        //ENERGIE
        float geheelGetalEnergie = [self.geheelgetalEnergie selectedRowInComponent:0];
        float kommaGetalEnergie = [self.kommagetalEnergie selectedRowInComponent:0];
        float energie = (kommaGetalEnergie/(100.0f));
        energie = energie + geheelGetalEnergie;
        NSNumber *kcal = [NSNumber numberWithFloat:energie];
        //EIWITTEN
        float geheelgetalEiwit = [self.geheelgetalEiwit selectedRowInComponent:0];
        float kommagetalEiwit = [self.kommagetalEiwit selectedRowInComponent:0];
        float eiwit = (kommagetalEiwit/(100.0f));
        eiwit = eiwit + geheelgetalEiwit;
        NSNumber *eiwitten = [NSNumber numberWithFloat:eiwit];
        //VETTEN
        float geheelGetalVetten = [self.geheelgetalVet selectedRowInComponent:0];
        float kommaGetalVetten = [self.kommagetalVet selectedRowInComponent:0];
        float vet = (kommaGetalVetten/(100.0f));
        vet = vet + geheelGetalVetten;
        NSNumber *vetten = [NSNumber numberWithFloat:vet];
        //KOOLHYDRATEN
        float geheelGetalKoolh = [self.geheelgetalKoolh selectedRowInComponent:0];
        float kommaGetalKoolh = [self.kommagetalKoolh selectedRowInComponent:0];
        float koolh = (kommaGetalKoolh/(100.0f));
        koolh = koolh + geheelGetalKoolh;
        NSNumber *koolhydraten = [NSNumber numberWithFloat:koolh];
        
        PFObject *item = [PFObject objectWithClassName:@"VoedingToAdd"];
        item[@"Naam"] = naamString;
        item[@"energie"] = kcal;
        item[@"koolhydraten"] = koolhydraten;
        item[@"vet"] = vetten;
        item[@"eiwitten"] = eiwitten;
        [item saveInBackground];
        //keer terug
        [self.delegate flipsideViewControllerDidFinishAdding:self];
    }
    else {
        if(!self.naam.text || self.naam.text.length <= 0) {
            self.naam.layer.cornerRadius=8.0f;
            self.naam.layer.masksToBounds=YES;
            self.naam.layer.borderWidth = 1.0f;
            self.naam.layer.borderColor = [[UIColor redColor] CGColor];
        }
        else {
            self.naam.layer.borderColor = [[UIColor clearColor]CGColor];
        }
        //ENERGIE
        if((![self.geheelgetalEnergie selectedRowInComponent:0]==0) || (![self.kommagetalEnergie selectedRowInComponent:0] == 0)) {
            self.energielabel.textColor = [UIColor blackColor];
        }
        else {
            self.energielabel.textColor = [UIColor redColor];
        }
        //VETTEN
        if((![self.geheelgetalVet selectedRowInComponent:0]==0) || (![self.kommagetalVet selectedRowInComponent:0] == 0)) {
            self.vetlabel.textColor = [UIColor blackColor];
        }
        else {
            self.vetlabel.textColor = [UIColor redColor];
        }
        //EIWITTEN
        if((![self.geheelgetalEiwit selectedRowInComponent:0]==0) || (![self.kommagetalEiwit selectedRowInComponent:0] == 0)) {
            self.eiwitlabel.textColor = [UIColor blackColor];
        }
        else {
            self.eiwitlabel.textColor = [UIColor redColor];
        }
        //KOOLHYDRATEN
        if((![self.geheelgetalKoolh selectedRowInComponent:0]==0) || (![self.kommagetalKoolh selectedRowInComponent:0] == 0)) {
            self.koolhydraatlabel.textColor = [UIColor blackColor];
        }
        else {
            self.koolhydraatlabel.textColor = [UIColor redColor];
        }
    }

}

- (IBAction)cancel:(id)sender {
    [self.delegate flipsideViewControllerDidFinishCancel:self];
}

@end
