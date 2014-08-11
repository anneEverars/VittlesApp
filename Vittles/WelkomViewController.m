//
//  WelkomViewController.m
//  Vittles
//
//  Created by Anne Everars on 18/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "WelkomViewController.h"
#import <Parse/Parse.h>

@interface WelkomViewController () {
    BOOL verder;
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
}

@end

@implementation WelkomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    loadingView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2.0)-160.0,(self.view.frame.size.height/2.0)-85.0, 170, 170)];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(65, 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [loadingView addSubview:activityView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"Laden...";
    [loadingView addSubview:loadingLabel];
    [self.view addSubview:loadingView];
    [activityView startAnimating];
    
    PFUser *user = [PFUser currentUser];
    if(user.username != nil) {
        [self.aanmeldknop setHidden:TRUE];
        [self.hebalaccount setHidden:TRUE];
        [self.hebgeenaccount setHidden:TRUE];
        [self.registreerknop setHidden:TRUE];
        verder = true;
    }
    else {
        [self.aanmeldknop setHidden:FALSE];
        [self.hebalaccount setHidden:FALSE];
        [self.hebgeenaccount setHidden:FALSE];
        [self.registreerknop setHidden:FALSE];
        verder = false;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    if(verder) {
        [self performSegueWithIdentifier:@"geenLogin" sender:self];
    }
    [activityView stopAnimating];
    [loadingLabel setHidden:TRUE];
    [loadingView setHidden:TRUE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
