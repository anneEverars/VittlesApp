//
//  DetailViewController.m
//  Vittles
//
//  Created by Anne Everars on 4/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController()
@property (nonatomic, weak) IBOutlet UILabel *label;
@end


@implementation DetailViewController

@synthesize splitViewButton = _splitViewButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) turnSplitViewButtonOn: (UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *) popoverController {
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    _splitViewButton = barButtonItem;
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

-(void)turnSplitViewButtonOff {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    _splitViewButton = nil;
    self.masterPopoverController = nil;
}

-(void) setSplitViewButton:(UIBarButtonItem *)splitViewButton forPopoverController:(UIPopoverController *)popoverController {
    if (splitViewButton != _splitViewButton) {
        if (splitViewButton) {
            [self turnSplitViewButtonOn:splitViewButton forPopoverController:popoverController];
        }
        else {
            [self turnSplitViewButtonOff];
        }
    }
}

@end
