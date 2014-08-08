//
//  KeuzePopoverTableViewController.h
//  Vittles
//
//  Created by Anne Everars on 24/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeuzePopoverTableViewController;

@protocol KeuzePopoverTableViewControllerDelegate

- (void)KeuzePopoverTableViewControllerDidFinish:(KeuzePopoverTableViewController *) controller withType:(NSString*)type;

- (void)KeuzePopoverTableViewControllerSwitchPopover:(KeuzePopoverTableViewController *) controller;

@end

@interface KeuzePopoverTableViewController : UITableViewController

@property (weak, nonatomic) id <KeuzePopoverTableViewControllerDelegate> delegate;

@end
