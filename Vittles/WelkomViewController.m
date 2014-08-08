//
//  WelkomViewController.m
//  Vittles
//
//  Created by Anne Everars on 18/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "WelkomViewController.h"
#import <Parse/Parse.h>

@interface WelkomViewController ()

@end

@implementation WelkomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    PFUser *user = [PFUser currentUser];
    if(user.username != nil) {
        [self performSegueWithIdentifier:@"geenLogin" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
