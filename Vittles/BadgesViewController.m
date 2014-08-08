//
//  BadgesViewController.m
//  Vittles
//
//  Created by Anne Everars on 4/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "BadgesViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import <Parse/Parse.h>
#import "CustomCollectionCell.h"

@interface BadgesViewController () {
    NSMutableArray *arrayOfImages;
    NSMutableArray *arrayOfNames;
    NSString *login;
}

@end

@implementation BadgesViewController

@synthesize menuBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"MYCELL"];
}

-(void)viewWillAppear:(BOOL)animated {
    //****GEBRUIKER****
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    //****MENU****
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuUitklapbaarViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(20, 24, 44, 34);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    //****Collection view****
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    arrayOfImages = [[NSMutableArray alloc]init];
    arrayOfNames = [[NSMutableArray alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Badges"];
    [query orderByAscending:@"type"];
    NSArray *results = [query findObjects];
    for (PFObject *object in results) {
        NSString *naam = [object objectForKey:@"Naam"];
        PFQuery *queryBadges = [PFQuery queryWithClassName:login];
        [queryBadges whereKey:@"type" equalTo:@"badge"];
        [queryBadges whereKey:@"Naam" equalTo:naam];
        NSArray *resultsBadges = [queryBadges findObjects];
        NSString *img = [object objectForKey:@"Afbeelding"];
        UIImage *image = [UIImage imageNamed:img];
        if([resultsBadges count]==0){
            image = [UIImage imageNamed:@"leeg.jpg"];
        }
        [arrayOfImages addObject:image];
        [arrayOfNames addObject:naam];
    }
}

- (void)PopoverViewControllerDidFinishAdding:(BadgeDetailViewController *)controller {
    [self.flipsidePopoverController dismissPopoverAnimated:YES];
}

-(void)PopoverViewControllerDidFinishCancel:(BadgeDetailViewController *)controller {
    [self.flipsidePopoverController dismissPopoverAnimated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [arrayOfNames count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MYCELL" forIndexPath:indexPath];
    [cell.badgeName setTextAlignment:NSTextAlignmentCenter];
    [cell.badgeName setText:[arrayOfNames objectAtIndex:indexPath.item]];
    cell.delegate = self;
    [cell.badgeImage setContentMode:UIViewContentModeScaleAspectFit];
    [cell.badgeImage setClipsToBounds:YES];
    [cell.badgeImage setBackgroundImage:[arrayOfImages objectAtIndex:indexPath.item] forState:UIControlStateNormal];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight];
}

-(void)didPopOverClickInCell:(CustomCollectionCell *)cell{
    if ([self.flipsidePopoverController isPopoverVisible]) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    } else {
        BadgeDetailViewController *controller = (BadgeDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"BadgePopover"];
        controller.delegate = self;
        NSString *naam = cell.badgeName.text;
        controller.naam = naam;
        self.flipsidePopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.flipsidePopoverController presentPopoverFromRect:cell.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

@end
