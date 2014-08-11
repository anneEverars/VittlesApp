//
//  UitdagingInfoViewController.h
//  Vittles
//
//  Created by Anne Everars on 15/05/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UitdagingInfoViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *naamLabel;
@property (strong, nonatomic) IBOutlet UITextView *beschrijvingTekst;
@property (strong, nonatomic) IBOutlet UITextView *beloningTekst;

@property (strong, nonatomic) IBOutlet UITableView *Vriendenlijst;

@property (strong, nonatomic) IBOutlet UIButton *vriendenUitdagenButton;
@property (strong, nonatomic) IBOutlet UIButton *actieKnop;

@property (strong, nonatomic) NSString *naam;

- (IBAction)daagUit:(id)sender;
- (IBAction)actieUitvoeren:(id)sender;



@end
