//
//  AlleTipsViewController.h
//  Vittles
//
//  Created by Anne Everars on 4/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipsContainerViewController.h"

@interface AlleTipsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property(strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UITableView *tipsTable;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UIView *container;

@end
