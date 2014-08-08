//
//  NotificatieViewController.h
//  Vittles
//
//  Created by Anne Everars on 4/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface NotificatieViewController : DetailViewController

//SWITCH
@property (strong, nonatomic) IBOutlet UILabel *uitLabel;
@property (strong, nonatomic) IBOutlet UILabel *aanLabel;
@property (strong, nonatomic) IBOutlet UISwitch *schakelaar;

//VOEDING
@property (strong, nonatomic) IBOutlet UILabel *voedingInvullen;
@property (strong, nonatomic) IBOutlet UIButton *VoedingCheckbox;
@property (strong, nonatomic) IBOutlet UILabel *voedingsdagboekDagelijks;
@property (strong, nonatomic) IBOutlet UIDatePicker *voedingsuur;
@property (strong, nonatomic) IBOutlet UILabel *voedingUurLabel;

//Achtiviteiten
@property (strong, nonatomic) IBOutlet UILabel *activiteitenInvullen;
@property (strong, nonatomic) IBOutlet UIButton *AchtiviteitenCheckbox;
@property (strong, nonatomic) IBOutlet UILabel *activiteitenlogboekDagelijks;
@property (strong, nonatomic) IBOutlet UIDatePicker *activiteitenuur;
@property (strong, nonatomic) IBOutlet UILabel *activiteitenUurLabel;

//Vooruitgang
@property (strong, nonatomic) IBOutlet UILabel *vooruitgangInvullen;
@property (strong, nonatomic) IBOutlet UIButton *VooruitgangCheckbox;
@property (strong, nonatomic) IBOutlet UILabel *vooruitgangDagelijks;
@property (strong, nonatomic) IBOutlet UIDatePicker *vooruitganguur;
@property (strong, nonatomic) IBOutlet UILabel *vooruitgangUurLabel;

- (IBAction)save:(id)sender;
- (IBAction)voedingClick:(id)sender;
- (IBAction)activiteitenClick:(id)sender;
- (IBAction)vooruitgangClick:(id)sender;


@end
