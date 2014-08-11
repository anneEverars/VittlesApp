//
//  CustomCollectionCell.h
//  Vittles
//
//  Created by Anne Everars on 14/04/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCollectionCell;
@protocol CustomCollectionCellDelegate
-(void)didPopOverClickInCell:(CustomCollectionCell *)cell;
@end

@interface CustomCollectionCell : UICollectionViewCell
@property (weak , nonatomic) id<CustomCollectionCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *badgeName;
@property (strong, nonatomic) IBOutlet UIButton *badgeImage;

@end
