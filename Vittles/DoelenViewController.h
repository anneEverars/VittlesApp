//
//  DoelenViewController.h
//  Vittles
//
//  Created by Anne Everars on 4/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"

@interface DoelenViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *DoelLabel;
@property (strong, nonatomic) IBOutlet UILabel *VooruitgangLabel;
@property (strong, nonatomic) IBOutlet UILabel *TijdLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *Statusbalk;
@property (strong, nonatomic) IBOutlet UILabel *volgens;
@property(strong, nonatomic) UIButton *menuBtn;
@property (retain, nonatomic) IBOutlet CERoundProgressView *progressView;

@end
