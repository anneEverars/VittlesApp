//
//  LoginViewController.h
//  Vittles
//
//  Created by Anne Everars on 17/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *naam;
@property (strong, nonatomic) IBOutlet UITextField *emailaddress;
@property (strong, nonatomic) IBOutlet UITextField *wachtwoord1;
@property (strong, nonatomic) IBOutlet UITextField *wachtwoord2;
@property (strong, nonatomic) IBOutlet UISwitch *geslacht;
@property (strong, nonatomic) IBOutlet UILabel *vrouw;
@property (strong, nonatomic) IBOutlet UILabel *man;
@property (strong, nonatomic) IBOutlet UIDatePicker *geboortedatum;
@property (strong, nonatomic) IBOutlet UIPickerView *geheelGewicht;
@property (strong, nonatomic) IBOutlet UIPickerView *kommaGewicht;
@property (strong, nonatomic) IBOutlet UIPickerView *geheelLengte;
@property (strong, nonatomic) IBOutlet UIPickerView *kommaLengte;
@property (strong, nonatomic) NSArray *aantallen;
@property (strong, nonatomic) NSArray *aantallenGewicht;
@property (strong, nonatomic) NSArray *aantalMeter;

- (IBAction)Volgende:(id)sender;
- (IBAction)annuleren:(id)sender;

@end
