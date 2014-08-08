//
//  UitdagingenViewController.h
//  Vittles
//
//  Created by Anne Everars on 7/04/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UitdagingenViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UITableView *actieve;
@property (strong, nonatomic) IBOutlet UITableView *voltooide;

@end
