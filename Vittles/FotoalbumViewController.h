//
//  FotoalbumViewController.h
//  Vittles
//
//  Created by Anne Everars on 10/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FotoalbumViewController : UIViewController

@property(strong, nonatomic) UIButton *menuBtn;

@property (strong, nonatomic) IBOutlet UIImageView *profielfoto;
@property (strong, nonatomic) IBOutlet UILabel *Gebruikersnaam;
@property (strong, nonatomic) IBOutlet UITextView *karakteristieken;

@end
