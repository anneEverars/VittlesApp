//
//  PersoonlijkeInstellingenViewController.h
//  Vittles
//
//  Created by Anne Everars on 4/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface PersoonlijkeInstellingenViewController : DetailViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIDatePicker *geboortedatum;
@property (strong, nonatomic) IBOutlet UIPickerView *geheelgetalGewicht;
@property (strong, nonatomic) IBOutlet UIPickerView *kommagetalGewicht;
@property (strong, nonatomic) IBOutlet UIPickerView *geheelgetalLengte;
@property (strong, nonatomic) IBOutlet UIPickerView *kommagetalLengte;
@property (strong, nonatomic) IBOutlet UISwitch *geslacht;
@property (strong, nonatomic) IBOutlet UILabel *vrouw;
@property (strong, nonatomic) IBOutlet UILabel *man;
@property (strong, nonatomic) NSArray *aantallen;
@property (strong, nonatomic) NSArray *aantallenGewicht;
@property (strong, nonatomic) NSArray *aantalMeter;

- (IBAction)save:(id)sender;

@end
