//
//  BadgeDetailViewController.h
//  Vittles
//
//  Created by Anne Everars on 24/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BadgeDetailViewController;

@protocol BadgeDetailViewControllerDelegate

- (void)PopoverViewControllerDidFinishAdding:(BadgeDetailViewController *) controller;
- (void)PopoverViewControllerDidFinishCancel:(BadgeDetailViewController *) controller;

@end

@interface BadgeDetailViewController : UIViewController

@property (weak, nonatomic) id <BadgeDetailViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UITextView *beschrijving;
@property (strong, nonatomic) IBOutlet UILabel *behaald;
@property (strong, nonatomic) IBOutlet UILabel *datum;

@property (strong, nonatomic) NSString *naam;

-(IBAction)done:(id)sender;

@end
