//
//  SecondViewController.h
//  Vittles
//
//  Created by Anne Everars on 26/02/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeuzePopoverTableViewController.h"

@interface ProfileViewController : UIViewController

@property(strong, nonatomic) UIButton *menuBtn;

@property (strong, nonatomic) IBOutlet UIButton *profielfoto;
@property (strong, nonatomic) IBOutlet UILabel *Gebruikersnaam;
@property (strong, nonatomic) IBOutlet UITextView *karakteristieken;
@property (strong, nonatomic) IBOutlet UITableView *gebeurtenissen;

//Popover
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

-(void)refreshProfilepicture:(UIImage *)image;
@end
