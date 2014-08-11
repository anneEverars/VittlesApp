//
//  ActivityAddViewController.h
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideActiviteitenViewController.h"

@interface ActivityAddViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, FlipsideActiviteitenViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *SoortenActiviteiten;
@property (strong, nonatomic) IBOutlet UITableView *activiteiten;
@property (strong, nonatomic) IBOutlet UIView *Container;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

//Add popover
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)cancel:(id)sender;


@end