//
//  CustomCollectionCell.m
//  Vittles
//
//  Created by Anne Everars on 14/04/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "CustomCollectionCell.h"

@implementation CustomCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.badgeName = [[UILabel alloc] initWithFrame:CGRectMake(3, 191, 177, 21)];
        [self.contentView addSubview:self.badgeName];
        self.badgeImage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        [self.badgeImage addTarget:self action:@selector(popOverClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.badgeImage];
    }
    return self;
}

-(void)popOverClick:(UIButton *)button{
    [[self delegate] didPopOverClickInCell:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
