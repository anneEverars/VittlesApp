//
//  FoodViewController.h
//  Vittles
//
//  Created by Anne Everars on 1/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"

@interface FoodViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UIButton *menuBtn;

@property (strong, nonatomic) IBOutlet UITableView *dagoverzicht;

@property (strong, nonatomic) IBOutlet UIProgressView *calorieBar;
@property (strong, nonatomic) IBOutlet UILabel *energiemeter;

@property (retain, nonatomic) IBOutlet CERoundProgressView *waterView;
@property (strong, nonatomic) IBOutlet UILabel *waterLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *fruitView;
@property (strong, nonatomic) IBOutlet UILabel *fruitLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *wheatView;
@property (strong, nonatomic) IBOutlet UILabel *wheatLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *meatView;
@property (strong, nonatomic) IBOutlet UILabel *meatLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *oilView;
@property (strong, nonatomic) IBOutlet UILabel *oilLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *milkView;
@property (strong, nonatomic) IBOutlet UILabel *milkLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *sugarView;
@property (strong, nonatomic) IBOutlet UILabel *sugarLabel;

@property (retain, nonatomic) IBOutlet CERoundProgressView *restView;
@property (strong, nonatomic) IBOutlet UILabel *restLabel;

@property (strong, nonatomic) IBOutlet UIButton *voegToeKnop;
@property (strong, nonatomic) IBOutlet UIView *Container;

@end
