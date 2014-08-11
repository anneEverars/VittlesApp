//
//  WeegschaalViewController.h
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "CERoundProgressView.h"

@interface WeegschaalViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource,CPTPlotDataSource>

@property (strong, nonatomic) IBOutlet UIButton *registratieKnop;
@property (strong, nonatomic) IBOutlet UIPickerView *kgGewicht;
@property (strong, nonatomic) IBOutlet UIPickerView *kommaGewicht;

@property(strong, nonatomic) UIButton *menuBtn;
@property (nonatomic, retain) NSMutableArray *arrayNo;
@property (nonatomic, retain) NSMutableArray *arrayNo2;

- (IBAction)registreerGewicht:(id)sender;

//graph
@property (nonatomic, strong) CPTGraphHostingView *hostView;
-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;

@property (strong, nonatomic) IBOutlet UILabel *bmiLabel;
@property (strong, nonatomic) IBOutlet UILabel *categorie;
//@property (retain, nonatomic) IBOutlet CERoundProgressView *progressView;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end
