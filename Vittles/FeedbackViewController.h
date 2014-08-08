//
//  FeedbackViewController.h
//  Vittles
//
//  Created by Anne Everars on 7/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface FeedbackViewController : DetailViewController

@property (weak, nonatomic) IBOutlet UILabel *question0;
@property (weak, nonatomic) IBOutlet UILabel *question1;
@property (weak, nonatomic) IBOutlet UILabel *question2;

@property (weak, nonatomic) IBOutlet UILabel *score0;
@property (weak, nonatomic) IBOutlet UILabel *score1;
@property (weak, nonatomic) IBOutlet UILabel *score2;

@property (weak, nonatomic) IBOutlet UISlider *slider0;
@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *next;

@end
