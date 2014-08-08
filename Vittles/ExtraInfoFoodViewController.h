//
//  ExtraInfoViewController.h
//  Vittles
//
//  Created by Anne Everars on 15/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtraInfoFoodViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *ItemImage;
@property (strong, nonatomic) IBOutlet UILabel *ItemLabel;
@property (strong, nonatomic) IBOutlet UITableView *types;
@property (strong, nonatomic) NSMutableArray *soortenProduct;

@property (strong, nonatomic) NSMutableArray *soorten;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *moment;
@property (nonatomic, retain) NSMutableArray *aantallen;

@property (strong, nonatomic) IBOutlet UILabel *energie;
@property (strong, nonatomic) IBOutlet UILabel *eiwitten;
@property (strong, nonatomic) IBOutlet UILabel *vetten;
@property (strong, nonatomic) IBOutlet UILabel *koolhydraten;
@property (strong, nonatomic) IBOutlet UILabel *percentage;
@property (strong, nonatomic) IBOutlet UIPickerView *soortenPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *aantal;

@property (strong, nonatomic) IBOutlet UILabel *kiesEenSoort;

@property (strong, nonatomic) IBOutlet UIButton *voegToe;

- (IBAction)VoegToe:(id)sender;

@end
