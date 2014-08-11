//
//  InitViewController.m
//  Vittles
//
//  Created by Anne Everars on 26/02/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "InitViewController.h"

@interface InitViewController ()

@end

@implementation InitViewController

@synthesize location;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([location length] == 0){location = @"Hoofdpagina";}
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:location];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
