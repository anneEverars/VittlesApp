//
//  DetailPopoverViewController.h
//  Vittles
//
//  Created by Anne Everars on 16/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailPopoverViewController;

@protocol DetailPopoverViewControllerDelegate

- (void)DetailPopoverViewControllerDidFinishAdding:(DetailPopoverViewController *) controller;
- (void)DetailPopoverViewControllerDidFinishCancel:(DetailPopoverViewController *) controller;

@end

@interface DetailPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) id <DetailPopoverViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UINavigationBar *NavigationBar;
@property (strong, nonatomic) IBOutlet UITableView *lijstje;
@property (nonatomic,assign) NSInteger type;
@property (strong, nonatomic) NSMutableArray
*elementen;
@property (strong, nonatomic) NSMutableArray
*aantallen;
@property (strong, nonatomic) IBOutlet UITextView *label;


- (IBAction)done:(id)sender;

@end
