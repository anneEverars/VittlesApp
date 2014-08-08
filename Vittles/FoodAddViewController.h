//
//  FoodViewController.h
//  Vittles
//
//  Created by Anne Everars on 26/02/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"

@class FoodAddViewController;


@interface FoodAddViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *Momenten;
@property (strong, nonatomic) IBOutlet UITableView *Categorien;
@property (strong, nonatomic) IBOutlet UITableView *Invulling;
@property (strong, nonatomic) IBOutlet UIView *Container;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//Add popover
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;


- (IBAction)cancel:(id)sender;

@end