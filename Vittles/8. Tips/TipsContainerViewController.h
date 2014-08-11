//
//  TipsContainerViewController.h
//  Vittles
//
//  Created by Anne Everars on 14/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsContainerViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *BeschrijvingText;
@property (strong, nonatomic) IBOutlet UITextView *RichtlijnenText;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
-(void)reloadView;
@end
