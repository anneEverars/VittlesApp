//
//  CaloriemonitorViewController.m
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "CaloriemonitorViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import <Parse/Parse.h>

@interface CaloriemonitorViewController () {
    CPTGraph *graph;
    NSMutableArray *calorieOpname;
    NSMutableArray *calorieverbranding;
    NSMutableArray *verschil;
    int period;
    NSString *login;
}

@end

@implementation CaloriemonitorViewController

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 0.25f;
CGFloat yMax = 2.5f;
CGFloat yMin = -2.5f;
@synthesize hostView = hostView_;
@synthesize menuBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //******Gebruiker en initialisatie******
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    period = 7;
    //****MENU****
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuUitklapbaarViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(20, 24, 44, 34);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //****PLOTINITIALISATIE****
    [self laadGrafiek];
    [self initPlot];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight];
}

-(void) laadGrafiek {
    calorieOpname = nil;
    calorieverbranding = nil;
    if (!calorieOpname && !calorieverbranding) {
        calorieOpname = [[NSMutableArray alloc]initWithCapacity:period-1];
        calorieverbranding = [[NSMutableArray alloc]initWithCapacity:period-1];
        for (NSInteger i = 0; i < period; i++) {
            [calorieOpname addObject:[NSNull null]];
            [calorieverbranding addObject:[NSNull null]];
        }
    }
    //1. calorieconsumptie
    PFQuery *queryUser = [PFQuery queryWithClassName:login];
    [queryUser whereKey:@"type" equalTo:@"consumptie"];
    [queryUser whereKey:@"Naam" equalTo:@"opname"];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-(period-1)];
    NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    [queryUser whereKey:@"updatedAt" greaterThan:sinds];
    [queryUser orderByAscending:@"updatedAt"];
    NSArray *results = [queryUser findObjects];
    for(PFObject *opname in results) {
        NSDate *updated = [opname updatedAt];
        NSDate *today = [NSDate date];
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        NSString *start = [f stringFromDate:updated];
        NSString *einde = [f stringFromDate:today];
        NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:einde];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        NSInteger dagenVerschil = components.day;
        long index = period - 1 - dagenVerschil;
        NSNumber *opnameGetal = [opname objectForKey:@"hoeveelheid"];
        if([calorieOpname objectAtIndex:index]) {
            [calorieOpname replaceObjectAtIndex:index withObject:opnameGetal];
        }
        else {
            [calorieOpname insertObject:opnameGetal atIndex:index];
        }
    }
    //2. calorieverbranding
    PFQuery *queryUser2 = [PFQuery queryWithClassName:login];
    [queryUser2 whereKey:@"type" equalTo:@"consumptie"];
    [queryUser2 whereKey:@"Naam" equalTo:@"verbruik"];
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-(period-1)];
    sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    [queryUser2 whereKey:@"updatedAt" greaterThan:sinds];
    [queryUser2 orderByAscending:@"updatedAt"];
    NSArray *results2 = [queryUser2 findObjects];
    for(PFObject *verbruik in results2) {
        NSDate *updated = [verbruik updatedAt];
        NSDate *today = [NSDate date];
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        [f setDateFormat:@"yyyy-MM-dd"];
        NSString *start = [f stringFromDate:updated];
        NSString *einde = [f stringFromDate:today];
        NSDate *startDate = [f dateFromString:start];
        NSDate *endDate = [f dateFromString:einde];
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                            fromDate:startDate
                                                              toDate:endDate
                                                             options:0];
        NSInteger dagenVerschil = components.day;
        long index = period - 1 - dagenVerschil;
        float verbruikFloat = -[[verbruik objectForKey:@"hoeveelheid"]floatValue];
        NSNumber *verbruikGetal = [NSNumber numberWithFloat:verbruikFloat];
        if([calorieverbranding objectAtIndex:index]) {
            [calorieverbranding replaceObjectAtIndex:index withObject:verbruikGetal];
        }
        else {
            [calorieverbranding insertObject:verbruikGetal atIndex:index];
        }
    }
    verschil = [[NSMutableArray alloc]init];
    for (int i=0; i<7; i=i+1) {
        float opname = 0.0f;
        float verbruik = 0.0f;
        if(!([calorieOpname objectAtIndex:i] == (id)[NSNull null])) {
            opname = [[calorieOpname objectAtIndex:i]floatValue];
        }
        else {
            [calorieOpname replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:0.0f]];
        }
        if(!([calorieverbranding objectAtIndex:i]== (id)[NSNull null])) {
            verbruik = [[calorieverbranding objectAtIndex:i]floatValue];
        }
        else {
            [calorieverbranding replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:0.0f]];
        }
        float verschilVerbruik = opname + verbruik;
        [verschil addObject:[NSNumber numberWithFloat:verschilVerbruik]];
    }
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    NSUInteger aantal = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    return aantal;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    NSInteger valueCount = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            if (index < valueCount) {
                return [NSNumber numberWithUnsignedInteger:index];
            }
            break;
        case CPTScatterPlotFieldY:
            if ([plot.identifier isEqual:@"Calorie-opname"] == YES) {
                return [calorieOpname objectAtIndex:index];
            } else if ([plot.identifier isEqual:@"Calorieverbruik"] == YES) {
                return [calorieverbranding objectAtIndex:index];
            } else if ([plot.identifier isEqual:@"Verschil"] == YES) {
                return [verschil objectAtIndex:index];
            }
            break;
    }
    return [NSDecimalNumber zero];
}

-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
    [self configureLegend];
}

-(void)configureHost {
    CGRect parentRect = self.view.bounds;
    parentRect = CGRectMake(parentRect.origin.x + 50.0,
                            (parentRect.origin.y + 150.0),
                            parentRect.size.width - 90.0,
                            (parentRect.size.height - 250.0));
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
    CGFloat xMin = 0.0f;
    CGFloat xMax = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    int yMin = 4000;
    for(NSString *string in calorieOpname){
        int tmp = [string intValue];
        if(tmp < yMin){
            yMin = tmp;
        }
    }
    int yMax = 0;
    for(NSString *string in calorieOpname){
        int tmp = [string intValue];
        if(tmp > yMax){
            yMax = tmp;
        }
    }
    for(NSString *string in calorieverbranding){
        int tmp = [string intValue];
        if(tmp < yMin){
            yMin = tmp;
        }
    }
    for(NSString *string in calorieverbranding){
        int tmp = [string intValue];
        if(tmp > yMax){
            yMax = tmp;
        }
    }
    float length = abs(yMax)+abs(yMin);
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(length)];
}

-(void)configurePlots {
    graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    CPTBarPlot *calorieOpnamePlot = [[CPTBarPlot alloc]init];
    calorieOpnamePlot.fill = [CPTFill fillWithColor:[CPTColor redColor]];
    calorieOpnamePlot.identifier = @"Calorie-opname";
    CPTBarPlot *calorieVerbruikPlot = [[CPTBarPlot alloc]init];
    calorieVerbruikPlot.fill = [CPTFill fillWithColor:[CPTColor blueColor]];
    calorieVerbruikPlot.identifier = @"Calorieverbruik";
    CPTScatterPlot *verschilPlot = [[CPTScatterPlot alloc] init];
    verschilPlot.dataSource = self;
    verschilPlot.identifier = @"Verschil";
    CPTColor *verschilColor = [CPTColor greenColor];
    [graph addPlot:verschilPlot toPlotSpace:plotSpace];
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5;
    CGFloat barX = CPDBarInitialX;
    NSArray *plots = [NSArray arrayWithObjects:calorieOpnamePlot, calorieVerbruikPlot, nil];
    for (CPTBarPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        plot.barOffset = CPTDecimalFromDouble(barX);
        plot.lineStyle = barLineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        barX += CPDBarWidth;
    }
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;
    CPTMutableLineStyle *verschilLineStyle = [verschilPlot.dataLineStyle mutableCopy];
    verschilLineStyle.lineWidth = 1.0;
    verschilLineStyle.lineColor = verschilColor;
    verschilPlot.dataLineStyle = verschilLineStyle;
    CPTMutableLineStyle *verschilSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    verschilSymbolLineStyle.lineColor = verschilColor;
    CPTPlotSymbol *verschilSymbol = [CPTPlotSymbol starPlotSymbol];
    verschilSymbol.fill = [CPTFill fillWithColor:verschilColor];
    verschilSymbol.lineStyle = verschilLineStyle;
    verschilSymbol.size = CGSizeMake(6.0f, 6.0f);
    verschilPlot.plotSymbol = verschilSymbol;
}

-(void)configureAxes {
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor blackColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor blackColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor blackColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Tijd";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    CGFloat dateCount = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    for (NSString *date in [[CPDStockPriceStore sharedInstance] datesInWeek]) {
        CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:date  textStyle:x.labelTextStyle];
        CGFloat location = i++;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if (label) {
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = xLocations;
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Caloriën";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -40.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = 100;
    NSInteger minorIncrement = 50;
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

-(void)configureLegend {
    graph = self.hostView.hostedGraph;
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorTopRight;
    graph.legendDisplacement = CGPointMake(-20.0, -20.0);
}

@end
