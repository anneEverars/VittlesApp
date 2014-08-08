//
//  CaloriemonitorViewController.h
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface CaloriemonitorViewController : UIViewController<CPTPlotDataSource>

@property(strong, nonatomic) UIButton *menuBtn;

//graph
@property (nonatomic, strong) CPTGraphHostingView *hostView;
-(void)initPlot;
-(void)configureHost;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
-(void)configureLegend;

@end
