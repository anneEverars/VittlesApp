//
//  FlipsideViewController.h
//  Vittles
//
//  Created by Anne Everars on 27/05/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinishAdding:(FlipsideViewController *) controller;
- (void)flipsideViewControllerDidFinishCancel:(FlipsideViewController *) controller;
@end

@interface FlipsideViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *naam;


//Picker
@property (strong, nonatomic) IBOutlet UILabel *energielabel;
@property (strong, nonatomic) IBOutlet UIPickerView *geheelgetalEnergie;
@property (strong, nonatomic) IBOutlet UIPickerView *kommagetalEnergie;

@property (strong, nonatomic) IBOutlet UILabel *eiwitlabel;
@property (strong, nonatomic) IBOutlet UIPickerView *geheelgetalEiwit;
@property (strong, nonatomic) IBOutlet UIPickerView *kommagetalEiwit;

@property (strong, nonatomic) IBOutlet UILabel *vetlabel;
@property (strong, nonatomic) IBOutlet UIPickerView *geheelgetalVet;
@property (strong, nonatomic) IBOutlet UIPickerView *kommagetalVet;

@property (strong, nonatomic) IBOutlet UILabel *koolhydraatlabel;
@property (strong, nonatomic) IBOutlet UIPickerView *geheelgetalKoolh;
@property (strong, nonatomic) IBOutlet UIPickerView *kommagetalKoolh;
@property (nonatomic, retain) NSMutableArray *aantallen;

-(IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
