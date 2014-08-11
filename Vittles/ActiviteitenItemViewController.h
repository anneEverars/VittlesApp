//
//  ActiviteitenItemViewController.h
//  Vittles
//
//  Created by Anne Everars on 2/08/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"

@interface ActiviteitenItemViewController : UIViewController

@property float calorien;
@property float duur;

@property (strong, nonatomic) IBOutlet UILabel *hoeveelheid;

@property (retain, nonatomic) IBOutlet CERoundProgressView *progressViewtje;
@property (strong, nonatomic) IBOutlet UIImageView *ItemImage;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSString *soort;
@property (strong, nonatomic) IBOutlet UILabel *energie;
@property (strong, nonatomic) IBOutlet UILabel *percentage;

@property (strong, nonatomic) IBOutlet UINavigationBar *bar;

@end
