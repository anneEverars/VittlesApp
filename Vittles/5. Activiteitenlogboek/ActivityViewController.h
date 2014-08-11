//
//  ActivityViewController.h
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"

@interface ActivityViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UIButton *menuBtn;

@property (retain, nonatomic) IBOutlet CERoundProgressView *activityView;
@property (strong, nonatomic) IBOutlet UILabel *activiteitenLabel;

@property (strong, nonatomic) IBOutlet UITableView *dagoverzicht;

@property (strong, nonatomic) IBOutlet UIProgressView *calorieBar;

@property (strong, nonatomic) IBOutlet UILabel *energiemeter;
@property (strong, nonatomic) IBOutlet UIButton *voegToeKnop;
@property (strong, nonatomic) IBOutlet UIView *Container;

@end