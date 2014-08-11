//
//  VriendToevoegenViewController.h
//  Vittles
//
//  Created by Anne Everars on 23/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VriendToevoegenViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *vriendenTable;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
