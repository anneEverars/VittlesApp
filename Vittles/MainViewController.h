//
//  MainViewController.h
//  Vittles
//
//  Created by Anne Everars on 26/02/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"
#import "DetailPopoverViewController.h"

@interface MainViewController : UIViewController<DetailPopoverViewControllerDelegate, UIPopoverControllerDelegate>

@property(strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UILabel *energiemeter;
@property (strong, nonatomic) IBOutlet UIProgressView *calorieBar;
@property (strong, nonatomic) IBOutlet UIButton *actieknop;
@property (strong, nonatomic) IBOutlet UILabel *uitlegLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *waterView;
@property (strong, nonatomic) IBOutlet UIButton *water;
@property (strong, nonatomic) IBOutlet UILabel *waterLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *fruitView;
@property (strong, nonatomic) IBOutlet UIButton *fruit;
@property (strong, nonatomic) IBOutlet UILabel *fruitLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *wheatView;
@property (strong, nonatomic) IBOutlet UIButton *wheat;
@property (strong, nonatomic) IBOutlet UILabel *wheatLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *meatView;
@property (strong, nonatomic) IBOutlet UIButton *meat;
@property (strong, nonatomic) IBOutlet UILabel *meatLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *oilView;
@property (strong, nonatomic) IBOutlet UIButton *oil;
@property (strong, nonatomic) IBOutlet UILabel *oilLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *milkView;
@property (strong, nonatomic) IBOutlet UIButton *milk;
@property (strong, nonatomic) IBOutlet UILabel *milkLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *sugarView;
@property (strong, nonatomic) IBOutlet UIButton *sugar;
@property (strong, nonatomic) IBOutlet UILabel *sugarLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *restView;
@property (strong, nonatomic) IBOutlet UIButton *rest;
@property (strong, nonatomic) IBOutlet UILabel *restLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *activityView;
@property (strong, nonatomic) IBOutlet UIButton *activity;
@property (strong, nonatomic) IBOutlet UILabel *activityLabel;

//Popover
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)start:(id)sender;

@end
