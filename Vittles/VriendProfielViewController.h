//
//  VriendProfielViewController.h
//  Vittles
//
//  Created by Anne Everars on 23/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewButtonHandler.h"

@interface VriendProfielViewController : UIViewController<SplitViewButtonHandler>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (IBAction)terug:(id)sender;

@end
