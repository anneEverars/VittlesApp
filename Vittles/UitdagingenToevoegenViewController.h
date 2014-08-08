//
//  UitdagingenToevoegenViewController.h
//  Vittles
//
//  Created by Anne Everars on 15/05/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UitdagingenToevoegenViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UITableView *uitdagingenTabel;

- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
