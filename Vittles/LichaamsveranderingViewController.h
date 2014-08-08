//
//  LichaamsveranderingViewController.h
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "CERoundProgressView.h"

@interface LichaamsveranderingViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,CPTPlotDataSource>

@property(strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet UIButton *registratieKnop;
@property (strong, nonatomic) IBOutlet UIToolbar *tailleOfHeupen;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *tailleButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *heupenButton;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerCm;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerMm;

@property (nonatomic, retain) NSMutableArray *arrayNo;
@property (nonatomic, retain) NSMutableArray *arrayNo2;

- (IBAction)heupenKlik:(id)sender;
- (IBAction)tailleKlik:(id)sender;
- (IBAction)registreer:(id)sender;

//graph
@property (nonatomic, strong) CPTGraphHostingView *hostView;
-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;

@property (strong, nonatomic) IBOutlet UILabel *absiLabel;
@property (retain, nonatomic) IBOutlet CERoundProgressView *progressView;


@end
