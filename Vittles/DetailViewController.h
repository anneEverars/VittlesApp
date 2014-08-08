//
//  DetailViewController.h
//  Vittles
//
//  Created by Anne Everars on 4/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewButtonHandler.h"

@interface DetailViewController : UIViewController<SplitViewButtonHandler>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end
