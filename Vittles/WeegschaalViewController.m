//
//  WeegschaalViewController.m
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "WeegschaalViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import <Parse/Parse.h>

@interface WeegschaalViewController () {
    CPTGraph *graph;
    NSMutableArray *gewichten;
    NSArray *streefgewichten;
    int period;
    NSString *login;
}

@end

@implementation WeegschaalViewController

@synthesize hostView = hostView_;
@synthesize menuBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    //******Gebruiker en initialisatie******
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    [super viewDidLoad];
    period = 7;
	//******Menu******
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
    //******Pickers******
    NSMutableArray *dollarsArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < 151; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%02i", i];
		[dollarsArray addObject:item];
	}
	self.arrayNo = dollarsArray;
    dollarsArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < 100; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%02i", i];
		[dollarsArray addObject:item];
	}
	self.arrayNo2 = dollarsArray;
    PFQuery *queryRecent = [PFQuery queryWithClassName:login];
    [queryRecent whereKey:@"type" equalTo:@"profiel"];
    [queryRecent whereKey:@"Naam" equalTo:@"gewicht"];
    [queryRecent orderByDescending:@"updatedAt"];
    NSArray *results = [queryRecent findObjects];
    PFObject *gewichtRecent = [results objectAtIndex:0];
    NSNumber *recentGewicht = [gewichtRecent objectForKey:@"hoeveelheid"];
    int geheel = [recentGewicht intValue];
    int komma = (int) (([recentGewicht floatValue] - geheel)*100);
    self.kgGewicht.delegate = self;
    self.kgGewicht.dataSource = self;
    self.kommaGewicht.delegate = self;
    self.kommaGewicht.dataSource = self;
    [self.kgGewicht selectRow:geheel inComponent:0 animated:NO];
    [self.kommaGewicht selectRow:komma inComponent:0 animated:NO];
    //******BMI******
    [self checkBMI:recentGewicht];
    //******Grafiek******
    [self laadGrafiek];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initPlot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.kgGewicht == pickerView){
        return self.arrayNo.count;
    }
    else {
        return self.arrayNo2.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(self.kgGewicht == pickerView){
        return [self.arrayNo objectAtIndex:row];
    }
    else {
        return [self.arrayNo2 objectAtIndex:row];
    }
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    float geheelGetal = [self.kgGewicht selectedRowInComponent:0];
    float kommaGetal = [self.kommaGewicht selectedRowInComponent:0];
    float gewicht = (kommaGetal/(100.0f));
    gewicht = gewicht + geheelGetal;
    NSNumber *hoeveelheid = [NSNumber numberWithFloat:gewicht];
    [self checkBMI:hoeveelheid];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
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
            if ([plot.identifier isEqual:@"Gewicht"] == YES) {
                return [gewichten objectAtIndex:index];
            } else if ([plot.identifier isEqual:@"Streefgewicht"] == YES) {
                return [streefgewichten objectAtIndex:index];
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
    parentRect = CGRectMake(parentRect.origin.x + 10.0,
                            (parentRect.origin.y + 150.0),
                            parentRect.size.width - 400.0,
                            (parentRect.size.height - 250.0));
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = YES;
    [self.view addSubview:self.hostView];
}

-(void)configureGraph {
    graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    self.hostView.hostedGraph = graph;
    [graph.plotAreaFrame setPaddingLeft:30.0f];
    [graph.plotAreaFrame setPaddingBottom:30.0f];
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = NO;
}

-(void)configurePlots {
    int min = 4000;
    for(NSString *string in gewichten){
        int tmp = [string intValue];
        if(tmp < min){
            min = tmp;
        }
    }
    int max = 0;
    for(NSString *string in gewichten){
        int tmp = [string intValue];
        if(tmp > max){
            max = tmp;
        }
    }
    for(NSString *string in streefgewichten){
        int tmp = [string intValue];
        if(tmp < min){
            min = tmp;
        }
    }
    for(NSString *string in streefgewichten){
        int tmp = [string intValue];
        if(tmp > max){
            max = tmp;
        }
    }
    int inc = max - min;
    if(inc == 0) {
        min--;
        inc = 2;
    }
    graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(min) length:CPTDecimalFromFloat(inc)];
    
    CPTScatterPlot *gewichtPlot = [[CPTScatterPlot alloc] init];
    gewichtPlot.dataSource = self;
    gewichtPlot.identifier = @"Gewicht";
    CPTColor *gewichtColor = [CPTColor redColor];
    [graph addPlot:gewichtPlot toPlotSpace:plotSpace];
    CPTScatterPlot *streefGewichtPlot = [[CPTScatterPlot alloc] init];
    streefGewichtPlot.dataSource = self;
    streefGewichtPlot.identifier = @"Streefgewicht";
    CPTColor *streefGewichtColor = [CPTColor greenColor];
    [graph addPlot:streefGewichtPlot toPlotSpace:plotSpace];
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:gewichtPlot, streefGewichtPlot, nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.1f)];
    plotSpace.xRange = xRange;
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(1.2f)];
    plotSpace.yRange = yRange;

    CPTMutableLineStyle *gewichtLineStyle = [gewichtPlot.dataLineStyle mutableCopy];
    gewichtLineStyle.lineWidth = 2.5;
    gewichtLineStyle.lineColor = gewichtColor;
    gewichtPlot.dataLineStyle = gewichtLineStyle;
    CPTMutableLineStyle *gewichtSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    gewichtSymbolLineStyle.lineColor = gewichtColor;
    CPTPlotSymbol *gewichtSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    gewichtSymbol.fill = [CPTFill fillWithColor:gewichtColor];
    gewichtSymbol.lineStyle = gewichtSymbolLineStyle;
    gewichtSymbol.size = CGSizeMake(6.0f, 6.0f);
    gewichtPlot.plotSymbol = gewichtSymbol;
    
    CPTMutableLineStyle *streefGewichtLineStyle = [streefGewichtPlot.dataLineStyle mutableCopy];
    streefGewichtLineStyle.lineWidth = 1.0;
    streefGewichtLineStyle.lineColor = streefGewichtColor;
    streefGewichtPlot.dataLineStyle = streefGewichtLineStyle;
    CPTMutableLineStyle *streefGewichtSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    streefGewichtSymbolLineStyle.lineColor = streefGewichtColor;
    CPTPlotSymbol *streefGewichtSymbol = [CPTPlotSymbol starPlotSymbol];
    streefGewichtSymbol.fill = [CPTFill fillWithColor:streefGewichtColor];
    streefGewichtSymbol.lineStyle = streefGewichtSymbolLineStyle;
    streefGewichtSymbol.size = CGSizeMake(6.0f, 6.0f);
    streefGewichtPlot.plotSymbol = streefGewichtSymbol;
}

-(void)configureAxes {
    int min = 4000;
    for(NSString *string in gewichten){
        int tmp = [string intValue];
        if(tmp < min){
            min = tmp;
        }
    }
    int max = 0;
    for(NSString *string in gewichten){
        int tmp = [string intValue];
        if(tmp > max){
            max = tmp;
        }
    }
    for(NSString *string in streefgewichten){
        int tmp = [string intValue];
        if(tmp < min){
            min = tmp;
        }
    }
    for(NSString *string in streefgewichten){
        int tmp = [string intValue];
        if(tmp > max){
            max = tmp;
        }
    }
    NSInteger inc = (max - min)/5;
    if(inc == 0){
        inc = 1;
    }else if (inc == 1 && (max - min) % 5 >= 2){
        inc = 2;
    }
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
    axisSet.xAxis.orthogonalCoordinateDecimal = CPTDecimalFromFloat(min);
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
    y.title = @"Gewicht (kg)";
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
    NSInteger majorIncrement = 10;
    NSInteger minorIncrement = 1;
    CGFloat yMax = max+2;
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%likg", (long)j] textStyle:y.labelTextStyle];
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

- (IBAction)registreerGewicht:(id)sender {
    float geheelGetal = [self.kgGewicht selectedRowInComponent:0];
    float kommaGetal = [self.kommaGewicht selectedRowInComponent:0];
    float gewicht = (kommaGetal/(100.0f));
    gewicht = gewicht + geheelGetal;
    NSNumber *hoeveelheid = [NSNumber numberWithFloat:gewicht];
    PFObject *gewichtUpdate = [PFObject objectWithClassName:login];
    gewichtUpdate[@"type"] = @"profiel";
    gewichtUpdate[@"Naam"] = @"gewicht";
    gewichtUpdate[@"hoeveelheid"] = hoeveelheid;
    [gewichtUpdate saveInBackground];
    [self checkBMI:hoeveelheid];
    [self laadGrafiek];
    [graph reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //[self setProgressView:nil];
}

-(void)checkBMI:(NSNumber *)recentGewicht{
    //self.progressView.backgroundColor = [UIColor clearColor];
    //self.progressView.opaque = NO;
    //self.progressView.trackColor = [UIColor whiteColor];
    float gewicht = [recentGewicht floatValue];
    PFQuery *queryLengte = [PFQuery queryWithClassName:login];
    [queryLengte whereKey:@"type" equalTo:@"profiel"];
    [queryLengte whereKey:@"Naam" equalTo:@"gegevens"];
    NSArray *resultaatgegevens = [queryLengte findObjects];
    PFObject *lengteObject = [resultaatgegevens objectAtIndex:0];
    float lengte = [[lengteObject objectForKey:@"hoeveelheid"] floatValue];
    float BMI = gewicht/(lengte*lengte);
    self.bmiLabel.text = [[NSString stringWithFormat:@"%.2f", BMI]stringByReplacingOccurrencesOfString:@"." withString:@","];
    if(BMI<18.5) {
        UIColor *tintColor = [UIColor yellowColor];
        //[[UISlider appearance] setMinimumTrackTintColor:tintColor];
        //[[CERoundProgressView appearance] setTintColor:tintColor];
        //self.progressView.tintColor = tintColor;
        self.categorie.textColor = tintColor;
        self.categorie.text = @"ondergewicht";
    }
    else if(BMI<25) {
        UIColor *tintColor = [UIColor greenColor];
        //[[UISlider appearance] setMinimumTrackTintColor:tintColor];
        //[[CERoundProgressView appearance] setTintColor:tintColor];
        //self.progressView.tintColor = tintColor;
        self.categorie.textColor = tintColor;
        self.categorie.text = @"normaal gewicht";
    }
    else if(BMI<27) {
        UIColor *tintColor = [UIColor orangeColor];
        //[[UISlider appearance] setMinimumTrackTintColor:tintColor];
        //[[CERoundProgressView appearance] setTintColor:tintColor];
        //self.progressView.tintColor = tintColor;
        self.categorie.textColor = tintColor;
        self.categorie.text = @"licht overgewicht";
    }
    else if(BMI < 30) {
        UIColor *tintColor = [UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0 alpha:1.0];
        //[[UISlider appearance] setMinimumTrackTintColor:tintColor];
        //[[CERoundProgressView appearance] setTintColor:tintColor];
        //self.progressView.tintColor = tintColor;
        self.categorie.textColor = tintColor;
        self.categorie.text = @"matig overgewicht";
    }
    else if(BMI < 40) {
        UIColor *tintColor = [UIColor redColor];
        //[[UISlider appearance] setMinimumTrackTintColor:tintColor];
        //[[CERoundProgressView appearance] setTintColor:tintColor];
        //self.progressView.tintColor = tintColor;
        self.categorie.textColor = tintColor;
        self.categorie.text = @"ernstig overgewicht";
    }
    else {
        UIColor *tintColor = [UIColor colorWithRed:178.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
        //[[UISlider appearance] setMinimumTrackTintColor:tintColor];
        //[[CERoundProgressView appearance] setTintColor:tintColor];
        //self.progressView.tintColor = tintColor;
        self.categorie.textColor = tintColor;
        self.categorie.text = @"ziekelijk overgewicht";
    }
    float bmiVooruitgang = BMI;
    [self.slider setMinimumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage alloc] forState:UIControlStateNormal];
    [self.slider setThumbImage: [UIImage imageNamed:@"thumbLine"] forState:UIControlStateNormal];
    //self.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    //self.progressView.startAngle = (3.0*M_PI)/2.0;
    //self.progressView.progress = bmiVooruitgang;
    self.slider.value  = bmiVooruitgang;
}

-(void)laadGrafiek {
    gewichten = nil;
    if (!gewichten) {
        gewichten = [[NSMutableArray alloc]initWithCapacity:period-1];
        for (NSInteger i = 0; i < period; i++) {
            [gewichten addObject:[NSNull null]];
        }
        //We halen de meest recente gewichtsupdate op.
        PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
        [queryGewicht whereKey:@"type" equalTo:@"profiel"];
        [queryGewicht whereKey:@"Naam" equalTo:@"gewicht"];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:-period];
        NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
        [queryGewicht whereKey:@"updatedAt" greaterThan:sinds];
        [queryGewicht orderByAscending:@"updatedAt"];
        NSArray *results = [queryGewicht findObjects];
        for (PFObject *gewicht in results) {
            NSDate *updated = [gewicht updatedAt];
            NSDate *today = [NSDate date];
            NSInteger dagenVerschil = [self daysBetween:updated and:today];
            long index = period - 1 - dagenVerschil;
            NSNumber *gewichtGetal = [gewicht objectForKey:@"hoeveelheid"];
            if([gewichten objectAtIndex:index]) {
                [gewichten replaceObjectAtIndex:index withObject:gewichtGetal];
            }
            else {
                [gewichten insertObject:gewichtGetal atIndex:index];
            }
        }
        //Vul de ontbrekende waarden in
        for (NSInteger i = period-1; i>=0; i--) {
            if([gewichten objectAtIndex:i]== (id)[NSNull null]) {
                if(i == period-1) {
                    //Dan zitten we aan het einde van de rij
                    BOOL stop = NO;
                    while (!stop) {
                        for(NSInteger j=period-2;j>0;j--) {
                            if([gewichten objectAtIndex:j] != (id)[NSNull null]) {
                                stop = YES;
                                long aantalindices = i-j;
                                for(NSInteger k=1; k<=aantalindices; k++) {
                                    [gewichten replaceObjectAtIndex:j+k withObject:[gewichten objectAtIndex:j]];
                                }
                            }
                        }
                        if(!stop) {
                            PFQuery *queryGewicht2 = [PFQuery queryWithClassName:login];
                            [queryGewicht2 whereKey:@"type" equalTo:@"profiel"];
                            [queryGewicht2 whereKey:@"Naam" equalTo:@"gewicht"];
                            [queryGewicht2 orderByDescending:@"updatedAt"];
                            NSArray *results2 = [queryGewicht2 findObjects];
                            PFObject *meestRecent = [results2 objectAtIndex:0];
                            NSNumber *gewichtGetal = [meestRecent objectForKey:@"hoeveelheid"];
                            [gewichten replaceObjectAtIndex:i  withObject:gewichtGetal];
                            stop = YES;
                        }
                    }
                }
                else if(i==0) {
                    //Dan zitten we aan het begin van de rij
                    //Dus halen we het meest recente gewicht op
                    PFQuery *queryGewicht2 = [PFQuery queryWithClassName:login];
                    [queryGewicht2 whereKey:@"type" equalTo:@"profiel"];
                    [queryGewicht2 whereKey:@"Naam" equalTo:@"gewicht"];
                    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                    [offsetComponents setDay:-period];
                    NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                    [queryGewicht2 whereKey:@"updatedAt" lessThanOrEqualTo:sinds];
                    [queryGewicht2 orderByAscending:@"updatedAt"];
                    NSArray *results = [queryGewicht2 findObjects];
                    PFObject *laatsteGewichtUpdate = [results objectAtIndex:0];
                    NSNumber *gewichtGetal = [laatsteGewichtUpdate objectForKey:@"hoeveelheid"];
                    [gewichten replaceObjectAtIndex:0 withObject:gewichtGetal];
                }
                else {
                    //Ergens een getal tussenin
                    float gewichtRechts = [[gewichten objectAtIndex:i+1] floatValue];
                    BOOL waardeLinksGevonden = NO;
                    long indexLinks;
                    float gewichtLinks;
                    for(NSInteger j=i-1;j>=0;j--) {
                        if([gewichten objectAtIndex:j] != (id)[NSNull null]) {
                            waardeLinksGevonden = YES;
                            indexLinks = j;
                            gewichtLinks = [[gewichten objectAtIndex:j] floatValue];
                            break;
                        }
                    }
                    if(waardeLinksGevonden) {
                        float verschilInGewicht = gewichtRechts - gewichtLinks;
                        float extra = indexLinks/(indexLinks+1);
                        float waarde = verschilInGewicht*extra;
                        NSNumber *gewichtwaarde = [NSNumber numberWithFloat:(gewichtLinks+waarde)];
                        [gewichten replaceObjectAtIndex:i withObject:gewichtwaarde];
                    }
                    else {
                        PFQuery *queryGewicht2 = [PFQuery queryWithClassName:login];
                        [queryGewicht2 whereKey:@"type" equalTo:@"profiel"];
                        [queryGewicht2 whereKey:@"Naam" equalTo:@"gewicht"];
                        NSCalendar *gregorian2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                        NSDateComponents *offsetComponents2 = [[NSDateComponents alloc] init];
                        [offsetComponents2 setDay:-period];
                        NSDate *sinds2 = [gregorian2 dateByAddingComponents:offsetComponents2 toDate:[NSDate date] options:0];
                        [queryGewicht2 whereKey:@"updatedAt" lessThanOrEqualTo:sinds2];
                        [queryGewicht2 orderByAscending:@"updatedAt"];
                        NSArray *resultsGewicht = [queryGewicht2 findObjects];
                        if([resultsGewicht count] > 0){
                            PFObject *laatsteGewichtUpdate = [resultsGewicht objectAtIndex:0];
                            NSNumber *gewichtGetal = [laatsteGewichtUpdate objectForKey:@"hoeveelheid"];
                            [gewichten replaceObjectAtIndex:i withObject:gewichtGetal];
                            for(NSInteger j=i-1;j>=0;j--) {
                                [gewichten replaceObjectAtIndex:j withObject:gewichtGetal];
                            }
                        }
                        else {
                            for(NSInteger j=i;j>=0;j--) {
                                [gewichten replaceObjectAtIndex:j withObject:[NSNumber numberWithFloat:gewichtRechts]];
                            }
                        }
                    }
                }
            }
        }
    }
    //streefgewicht
    streefgewichten = nil;
    if (!streefgewichten) {
        PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
        [queryGewicht whereKey:@"type" equalTo:@"doel"];
        [queryGewicht whereKey:@"soort" equalTo:@"gewicht"];
        [queryGewicht whereKey:@"Naam" equalTo:@"naam"];
        NSArray *results = [queryGewicht findObjects];
        PFObject *gewicht = [results objectAtIndex:0];
        int aantal = [[gewicht objectForKey:@"hoeveelheid"] intValue];
        streefgewichten = [NSArray arrayWithObjects:
                           [NSDecimalNumber numberWithInt:aantal],
                           [NSDecimalNumber numberWithInt:aantal],
                           [NSDecimalNumber numberWithInt:aantal],
                           [NSDecimalNumber numberWithInt:aantal],
                           [NSDecimalNumber numberWithInt:aantal],
                           [NSDecimalNumber numberWithInt:aantal],
                           [NSDecimalNumber numberWithInt:aantal],
                           nil];
    }
}

- (NSDate *)beginningOfDay:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [cal dateFromComponents:components];
}

- (NSDate *)endOfDay:(NSDate *)date {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:date];
    [components setHour:23];
    [components setMinute:59];
    [components setSecond:59];
    return [cal dateFromComponents:components];
}

- (NSInteger)daysBetween:(NSDate *)date1 and:(NSDate *)date2 {
    NSDate *beginningOfDate1 = [self beginningOfDay:date1];
    NSDate *endOfDate1 = [self endOfDay:date1];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *beginningDayDiff = [calendar components:NSDayCalendarUnit fromDate:beginningOfDate1 toDate:date2 options:0];
    NSDateComponents *endDayDiff = [calendar components:NSDayCalendarUnit fromDate:endOfDate1 toDate:date2 options:0];
    if (beginningDayDiff.day > 0)
        return beginningDayDiff.day;
    else if (endDayDiff.day < 0)
        return endDayDiff.day;
    else {
        return 0;
    }
}
@end
