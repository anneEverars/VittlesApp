//
//  ExtraInfoActivitieitViewController.h
//  Vittles
//
//  Created by Anne Everars on 17/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtraInfoActivitieitViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *ItemImage;
@property (strong, nonatomic) IBOutlet UILabel *ItemLabel;

@property (strong, nonatomic) NSMutableArray *soorten;
@property (strong, nonatomic) NSString *type;
@property (nonatomic, retain) NSMutableArray *aantallen;

@property (strong, nonatomic) IBOutlet UILabel *energie;
@property (strong, nonatomic) IBOutlet UILabel *percentage;
@property (strong, nonatomic) IBOutlet UIPickerView *aantal;

@property (strong, nonatomic) IBOutlet UIButton *voegToe;
@property (strong, nonatomic) IBOutlet UITableView *types;
@property (strong, nonatomic) IBOutlet UIButton *slapenCheckbox;
@property (strong, nonatomic) IBOutlet UIButton *rustenCheckbox;
@property (strong, nonatomic) IBOutlet UILabel *kiesEenSoort;

- (IBAction)VoegToe:(id)sender;
- (IBAction)SlapenCheckbox:(id)sender;
- (IBAction)RustenCheckbox:(id)sender;


@end
