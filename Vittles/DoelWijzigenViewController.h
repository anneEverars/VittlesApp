//
//  DoelWijzigenViewController.h
//  Vittles
//
//  Created by Anne Everars on 8/04/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CERoundProgressView.h"
#import "CEPlayer.h"

@interface DoelWijzigenViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIButton *gewichtCheckbox;
@property (strong, nonatomic) IBOutlet UIButton *heupenCheckbox;
@property (strong, nonatomic) IBOutlet UIButton *tailleCheckbox;
@property (strong, nonatomic) IBOutlet UIButton *geenTijdCheckbox;
@property (strong, nonatomic) IBOutlet UIButton *tijdCheckbox;
@property (strong, nonatomic) IBOutlet UIPickerView *aantal;
@property (strong, nonatomic) IBOutlet UIPickerView *aantalKomma;

@property (nonatomic, retain) NSMutableArray *aantallen;
@property (strong, nonatomic) IBOutlet UIPickerView *tijdWeken;
@property (strong, nonatomic) IBOutlet UIPickerView *tijdDagen;
@property (nonatomic, retain) NSMutableArray *dagen;
@property (nonatomic, retain) NSMutableArray *weken;


- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

- (IBAction)GewichtCheckbox:(id)sender;
- (IBAction)HeupenCheckbox:(id)sender;
- (IBAction)TailleCheckbox:(id)sender;

- (IBAction)GeenTijdCheckbox:(id)sender;
- (IBAction)TijdCheckbox:(id)sender;

//MOEILIJKHEID
@property (retain, nonatomic) IBOutlet CERoundProgressView *progressView;

//REST
@property (strong, nonatomic) IBOutlet UILabel *huidigeGewicht;
@property (strong, nonatomic) IBOutlet UILabel *eenheid;
@property (strong, nonatomic) IBOutlet UILabel *resultaat;
@property (strong, nonatomic) IBOutlet UILabel *ditBetekent;
@property (strong, nonatomic) IBOutlet UILabel *huidigeStatus;


@end
