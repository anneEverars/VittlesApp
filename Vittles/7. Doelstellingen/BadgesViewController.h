//
//  BadgesViewController.h
//  Vittles
//
//  Created by Anne Everars on 4/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "BadgeDetailViewController.h"
#import "CustomCollectionCell.h"
#import <UIKit/UIKit.h>

@interface BadgesViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource,CustomCollectionCellDelegate,BadgeDetailViewControllerDelegate>

@property(strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@end
