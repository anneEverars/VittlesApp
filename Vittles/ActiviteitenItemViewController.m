//
//  ActiviteitenItemViewController.m
//  Vittles
//
//  Created by Anne Everars on 2/08/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "ActiviteitenItemViewController.h"
#import <Parse/Parse.h>

@interface ActiviteitenItemViewController () {
    NSString *login;
}

@end

@implementation ActiviteitenItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //****GEBRUIKER****
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    //****TYPEVIEW****
    PFQuery *queryADH = [PFQuery queryWithClassName:login];
    [queryADH whereKey:@"type" equalTo:@"ADH"];
    NSArray *resultsADH = [queryADH findObjects];
    PFObject *resultADH = [resultsADH objectAtIndex:0];
    float ADHActiviteiten = [[resultADH objectForKey:@"hoeveelheid"] floatValue];
    float waarde = (self.calorien/ADHActiviteiten)*100;
    NSString *gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
    if(waarde > 100) {
        gebruikt = @"100,00";
        waarde = 100.0f;
    }
    //****ENERGIEWAARDE****
    if([self.bar.topItem.title length] !=0 && ![self.bar.topItem.title isEqualToString:@"Title"]) {
        if([self.bar.topItem.title isEqualToString:@"Slapen"] || [self.bar.topItem.title isEqualToString:@"Rusten"]) {
            waarde = 0.0f;
        }
        self.energie.text = [[[NSString stringWithFormat:@"%.2f", self.calorien]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
    UIColor *tintColor = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0f];
    [[UISlider appearance] setMinimumTrackTintColor:tintColor];
    [self.progressViewtje setTintColor:tintColor];
    self.progressViewtje.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    self.progressViewtje.startAngle = (3.0*M_PI)/2.0;
    self.progressViewtje.progress = waarde/100.0f;
    self.label.text = [gebruikt stringByAppendingString:@"%"];
}

@end
