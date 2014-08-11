//
//  TipsContainerViewController.m
//  Vittles
//
//  Created by Anne Everars on 14/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "TipsContainerViewController.h"
#import <Parse/Parse.h>

@interface TipsContainerViewController ()

@end

@implementation TipsContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)reloadView {
    PFQuery *query = [PFQuery queryWithClassName:@"Tips"];
    NSString *naam = [self.navBar.topItem title];
    if(naam && ![naam isEqualToString:@"Title"]) {
        [query whereKey:@"Naam" equalTo:naam];
        NSArray *result = [query findObjects];
        PFObject *object = [result objectAtIndex:0];
        NSString *beschrijving = [object objectForKey:@"Beschrijving"];
        NSArray *items = [object objectForKey:@"Concreet"];
        self.BeschrijvingText.text = beschrijving;
        NSMutableString * bulletList = [NSMutableString stringWithCapacity:items.count*30];
        for (NSString * s in items){
            [bulletList appendFormat:@"\u2713 %@\n", s];
        }
        self.RichtlijnenText.text = bulletList;
    }
}
@end
