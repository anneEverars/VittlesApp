//
//  LichaamsveranderingViewController.m
//  Vittles
//
//  Created by Anne Everars on 3/03/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "LichaamsveranderingViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import <Parse/Parse.h>
#import "math.h"

@interface LichaamsveranderingViewController () {
    BOOL taille;
    BOOL heupen;
    CPTGraph *graph;
    NSMutableArray *heupenAantallen;
    NSArray *streefheupen;
    NSMutableArray *tailleAantallen;
    NSArray *streefTaille;
    int period;
    NSString *login;
    BOOL everentered;
}

@end

@implementation LichaamsveranderingViewController

@synthesize hostView = hostView_;
@synthesize menuBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //******Gebruiker******
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
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
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //****INITIALISATIE****
    period = 7;
    if(!heupen&&!taille) {
        heupen = TRUE;
        taille = FALSE;
    }
    //******Pickers******
    NSMutableArray *dollarsArray = [[NSMutableArray alloc] init];
	for (int i = 0; i < 201; i++){
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
    self.pickerCm.delegate = self;
    self.pickerCm.dataSource = self;
    self.pickerMm.delegate = self;
    self.pickerMm.dataSource = self;
    [self initPicker];
    //******ABSI******
    [self.progressView setHidden:TRUE];
    //******Grafiek******
    [self laadGrafiek];
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
    if(self.pickerCm == pickerView){
        return self.arrayNo.count;
    }
    else {
        return self.arrayNo2.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(self.pickerCm == pickerView){
        return [self.arrayNo objectAtIndex:row];
    }
    else {
        return [self.arrayNo2 objectAtIndex:row];
    }
}

- (IBAction)heupenKlik:(id)sender {
    heupen = TRUE;
    taille = FALSE;
    [self.progressView setHidden:TRUE];
    [self.heupenButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:204.0/255.0 alpha:1]];
    [self.tailleButton setTintColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
    [self initPicker];
    [self laadGrafiek];
    [self initPlot];
    [graph reloadData];
}

- (IBAction)tailleKlik:(id)sender {
    taille = TRUE;
    heupen = FALSE;
    [self.progressView setHidden:FALSE];
    [self.tailleButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:102.0/255.0 blue:204.0/255.0 alpha:1]];
    [self.heupenButton setTintColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
    [self initPicker];
    [self laadGrafiek];
    [self initPlot];
    [self checkABSI];
    [graph reloadData];
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
            if (([plot.identifier isEqual:@"Heupen"] == YES)||([plot.identifier isEqual:@"Taille"] == YES)) {
                if(heupen) {
                    return[heupenAantallen objectAtIndex:index];
                }
                else if(taille) {
                    return[tailleAantallen objectAtIndex:index];
                }
            }
            else if ([plot.identifier isEqual:@"Streefdoel"] == YES) {
                if(heupen) {
                    return[streefheupen objectAtIndex:index];
                }
                else if(taille) {
                    return[streefTaille objectAtIndex:index];
                }
            }
            break;
    }
    return [NSDecimalNumber zero];
}


#pragma mark - Chart behavior
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
                            (parentRect.origin.y + 170.0),
                            parentRect.size.width - 400.0,
                            (parentRect.size.height - 270.0));
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
    int min = 0;
    int max = 0;
    if(heupen&&everentered) {
        for(NSString *string in heupenAantallen){
            int tmp = [string intValue];
            if(tmp < min){
                min = tmp;
            }
        }
        for(NSString *string in heupenAantallen){
            int tmp = [string intValue];
            if(tmp > max){
                max = tmp;
            }
        }
        for(NSString *string in streefheupen){
            int tmp = [string intValue];
            if(tmp < min){
                min = tmp;
            }
        }
        for(NSString *string in streefheupen){
            int tmp = [string intValue];
            if(tmp > max){
                max = tmp;
            }
        }
    }
    else if(taille&&everentered) {
        for(NSString *string in tailleAantallen){
            int tmp = [string intValue];
            if(tmp < min){
                min = tmp;
            }
        }
        for(NSString *string in tailleAantallen){
            int tmp = [string intValue];
            if(tmp > max){
                max = tmp;
            }
        }
        for(NSString *string in streefTaille){
            int tmp = [string intValue];
            if(tmp < min){
                min = tmp;
            }
        }
        for(NSString *string in streefTaille){
            int tmp = [string intValue];
            if(tmp > max){
                max = tmp;
            }
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
    if(heupen) {
        gewichtPlot.identifier = @"Heupen";
    }
    else {
        gewichtPlot.identifier = @"Taille";
    }
    CPTColor *gewichtColor = [CPTColor redColor];
    [graph addPlot:gewichtPlot toPlotSpace:plotSpace];
    CPTScatterPlot *streefGewichtPlot = [[CPTScatterPlot alloc] init];
    streefGewichtPlot.dataSource = self;
    streefGewichtPlot.identifier = @"Streefdoel";
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
    int min = 0;
    int max = 0;
    if(heupen&&everentered) {
        for(NSString *string in heupenAantallen){
            int tmp = [string intValue];
            if(tmp < min){
                min = tmp;
            }
        }
        for(NSString *string in heupenAantallen){
            int tmp = [string intValue];
            if(tmp > max){
                max = tmp;
            }
        }
        for(NSString *string in streefheupen){
            int tmp = [string intValue];
            if(tmp < min){
                min = tmp;
            }
        }
        for(NSString *string in streefheupen){
            int tmp = [string intValue];
            if(tmp > max){
                max = tmp;
            }
        }
    }
    else if(taille&&everentered) {
        for(NSString *string in tailleAantallen){
            int tmp = [string intValue];
            if(tmp < min){
                min = tmp;
            }
        }
        for(NSString *string in tailleAantallen){
            int tmp = [string intValue];
            if(tmp > max){
                max = tmp;
            }
        }
        for(NSString *string in streefTaille){
            int tmp = [string intValue];
            if(tmp < min){
                min = tmp;
            }
        }
        for(NSString *string in streefTaille){
            int tmp = [string intValue];
            if(tmp > max){
                max = tmp;
            }
        }
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
    y.title = @"Omtrek (cm)";
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(taille) {
        [self checkABSI];
    }
}

-(void)configureLegend {
    // 1 - Get graph instance
    graph = self.hostView.hostedGraph;
    // 2 - Create legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    // 3 - Configure legend
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 5.0;
    // 4 - Add legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorTopRight;
    graph.legendDisplacement = CGPointMake(-20.0, -20.0);
}

- (IBAction)registreer:(id)sender {
    float geheelGetal = [self.pickerCm selectedRowInComponent:0];
    float kommaGetal = [self.pickerMm selectedRowInComponent:0];
    float omtrek = (kommaGetal/(100.0f));
    omtrek = omtrek + geheelGetal;
    NSNumber *hoeveelheid = [NSNumber numberWithFloat:omtrek];
    PFObject *update = [PFObject objectWithClassName:login];
    update[@"type"] = @"profiel";
    if(heupen) {
        update[@"Naam"] = @"heupen";
    }
    else if(taille) {
        update[@"Naam"] = @"taille";
        [self checkABSI];
    }
    update[@"hoeveelheid"] = hoeveelheid;
    [update saveInBackground];
    [self laadGrafiek];
    [graph reloadData];
}

-(void)checkABSI {
    self.progressView.backgroundColor = [UIColor clearColor];
    self.progressView.opaque = NO;
    self.progressView.trackColor = [UIColor whiteColor];
    float geheelGetal = [self.pickerCm selectedRowInComponent:0];
    float kommaGetal = [self.pickerMm selectedRowInComponent:0];
    float taille0 = (kommaGetal/(100.0f));
    float tailleOmtrek = taille0 + geheelGetal;
    if(tailleOmtrek<=0 && everentered) {
        PFQuery *query = [PFQuery queryWithClassName:login];
        [query whereKey:@"type" equalTo:@"profiel"];
        [query whereKey:@"Naam" equalTo:@"taille"];
        [query orderByDescending:@"updatedAt"];
        NSArray *resultsTaille = [query findObjects];
        PFObject *recentResultaat = [resultsTaille objectAtIndex:0];
        tailleOmtrek = [[recentResultaat objectForKey:@"hoeveelheid"]floatValue];
    }
    //gewicht
    PFQuery *queryRecent = [PFQuery queryWithClassName:login];
    [queryRecent whereKey:@"type" equalTo:@"profiel"];
    [queryRecent whereKey:@"Naam" equalTo:@"gewicht"];
    [queryRecent orderByDescending:@"updatedAt"];
    NSArray *results = [queryRecent findObjects];
    PFObject *gewichtRecent = [results objectAtIndex:0];
    float gewicht = [[gewichtRecent objectForKey:@"hoeveelheid"]floatValue];
    //Lengte
    PFQuery *queryLengte = [PFQuery queryWithClassName:login];
    [queryLengte whereKey:@"type" equalTo:@"profiel"];
    [queryLengte whereKey:@"Naam" equalTo:@"gegevens"];
    NSArray *resultaatgegevens = [queryLengte findObjects];
    PFObject *lengteObject = [resultaatgegevens objectAtIndex:0];
    float lengte = [[lengteObject objectForKey:@"hoeveelheid"] floatValue];
    //ABSI
    float sqrtLengte = sqrtf(lengte*100);
    float BMI = gewicht/(lengte*lengte);
    float BMICubicRoot = pow(BMI, 2.0/3.0);
    float multiplication = BMICubicRoot*sqrtLengte;
    float ABSI = tailleOmtrek/multiplication;
    if(ABSI <=0) {
        [self.progressView setHidden:TRUE];
    }
    else {
        self.absiLabel.text = [[NSString stringWithFormat:@"%.2f", ABSI]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(ABSI<0.95) {
            UIColor *tintColor = [UIColor greenColor];
            [[UISlider appearance] setMinimumTrackTintColor:tintColor];
            [[CERoundProgressView appearance] setTintColor:tintColor];
            self.progressView.tintColor = tintColor;
        }
        else if(ABSI<1.05) {
            UIColor *tintColor = [UIColor orangeColor];
            [[UISlider appearance] setMinimumTrackTintColor:tintColor];
            [[CERoundProgressView appearance] setTintColor:tintColor];
            self.progressView.tintColor = tintColor;
        }
        else {
            UIColor *tintColor = [UIColor redColor];
            [[UISlider appearance] setMinimumTrackTintColor:tintColor];
            [[CERoundProgressView appearance] setTintColor:tintColor];
            self.progressView.tintColor = tintColor;
        }
        float vooruitgang = ABSI *0.25;
        self.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.progressView.startAngle = (3.0*M_PI)/2.0;
        self.progressView.progress = vooruitgang;
    }
}

-(void) laadGrafiek {
    [self.tailleOfHeupen setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:255.0/255.0 blue:204.0/255.0 alpha:1]];
    //Effectieve waarden
    heupenAantallen = nil;
    tailleAantallen = nil;
    heupenAantallen = [[NSMutableArray alloc]initWithCapacity:period-1];
    for (NSInteger i = 0; i < period; i++) {
        [heupenAantallen addObject:[NSNull null]];
    }
    tailleAantallen = [[NSMutableArray alloc]initWithCapacity:period-1];
    for (NSInteger i = 0; i < period; i++) {
        [tailleAantallen addObject:[NSNull null]];
    }
    if(everentered) {
        //We halen de meest recente update op.
        PFQuery *query = [PFQuery queryWithClassName:login];
        [query whereKey:@"type" equalTo:@"profiel"];
        if(heupen) {
            [query whereKey:@"Naam" equalTo:@"heupen"];
        }
        else if(taille) {
            [query whereKey:@"Naam" equalTo:@"taille"];
        }
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setDay:-period];
        NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
        [query whereKey:@"updatedAt" greaterThan:sinds];
        [query orderByAscending:@"updatedAt"];
        NSArray *results = [query findObjects];
        for (PFObject *object in results) {
            NSDate *updated = [object updatedAt];
            NSDate *today = [NSDate date];
            NSInteger dagenVerschil = [self daysBetween:updated and:today];
            long index = period - 1 - dagenVerschil;
            NSNumber *getal = [object objectForKey:@"hoeveelheid"];
            if(heupen) {
                [heupenAantallen replaceObjectAtIndex:index withObject:getal];
            }
            else if(taille){
                [tailleAantallen replaceObjectAtIndex:index withObject:getal];
            }
        }
        //Vul de ontbrekende waarden in
        if(heupen) {
            for (NSInteger i = period-1; i>=0; i--) {
                if([heupenAantallen objectAtIndex:i]== (id)[NSNull null]) {
                    if(i == period-1) {
                        //Dan zitten we aan het einde van de rij
                        BOOL stop = NO;
                        while (!stop) {
                            for(NSInteger j=period-2;j>0;j--) {
                                if([heupenAantallen objectAtIndex:i]!= (id)[NSNull null]) {
                                    stop = YES;
                                    long aantalindices = i-j;
                                    for(NSInteger k=1; k<=aantalindices; k++) {
                                        [heupenAantallen replaceObjectAtIndex:j+k withObject:[heupenAantallen objectAtIndex:j]];
                                    }
                                }
                            }
                            if(!stop) {
                                PFQuery *queryGewicht2 = [PFQuery queryWithClassName:login];
                                [queryGewicht2 whereKey:@"type" equalTo:@"profiel"];
                                [queryGewicht2 whereKey:@"Naam" equalTo:@"heupen"];
                                [queryGewicht2 orderByDescending:@"updatedAt"];
                                NSArray *results2 = [queryGewicht2 findObjects];
                                PFObject *meestRecent = [results2 objectAtIndex:0];
                                NSNumber *gewichtGetal = [meestRecent objectForKey:@"hoeveelheid"];
                                [heupenAantallen replaceObjectAtIndex:i  withObject:gewichtGetal];
                                stop = YES;
                            }
                        }
                    }
                    else if(i==0) {
                        //Dan zitten we aan het begin van de rij
                        //Dus halen we de meest recente heupenomtrek op
                        PFQuery *queryGewicht2 = [PFQuery queryWithClassName:login];
                        [queryGewicht2 whereKey:@"type" equalTo:@"profiel"];
                        [queryGewicht2 whereKey:@"Naam" equalTo:@"heupen"];
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                        [offsetComponents setDay:-period];
                        NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                        [queryGewicht2 whereKey:@"updatedAt" lessThanOrEqualTo:sinds];
                        [queryGewicht2 orderByAscending:@"updatedAt"];
                        NSArray *results = [queryGewicht2 findObjects];
                        PFObject *laatsteGewichtUpdate = [results objectAtIndex:0];
                        NSNumber *gewichtGetal = [laatsteGewichtUpdate objectForKey:@"hoeveelheid"];
                        [heupenAantallen replaceObjectAtIndex:0 withObject:gewichtGetal];
                    }
                    else {
                        //Ergens een getal tussenin
                        float gewichtRechts = [[heupenAantallen objectAtIndex:i+1] floatValue];
                        BOOL waardeLinksGevonden = NO;
                        long indexLinks;
                        float gewichtLinks;
                        for(NSInteger j=i-1;j>=0;j--) {
                            if([heupenAantallen objectAtIndex:j] != (id)[NSNull null]) {
                                waardeLinksGevonden = YES;
                                indexLinks = j;
                                gewichtLinks = [[heupenAantallen objectAtIndex:j] floatValue];
                                break;
                            }
                        }
                        if(waardeLinksGevonden) {
                            float verschilInGewicht = gewichtRechts - gewichtLinks;
                            float extra = indexLinks/(indexLinks+1);
                            float waarde = verschilInGewicht*extra;
                            NSNumber *gewichtwaarde = [NSNumber numberWithFloat:(gewichtLinks+waarde)];
                            [heupenAantallen replaceObjectAtIndex:i withObject:gewichtwaarde];
                        }
                        else {
                            PFQuery *queryGewicht3 = [PFQuery queryWithClassName:login];
                            [queryGewicht3 whereKey:@"type" equalTo:@"profiel"];
                            [queryGewicht3 whereKey:@"Naam" equalTo:@"heupen"];
                            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                            [offsetComponents setDay:-period];
                            NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                            [queryGewicht3 whereKey:@"updatedAt" lessThanOrEqualTo:sinds];
                            [queryGewicht3 orderByAscending:@"updatedAt"];
                            NSArray *results = [queryGewicht3 findObjects];
                            if([results count] > 0){
                                PFObject *laatsteGewichtUpdate = [results objectAtIndex:0];
                                NSNumber *gewichtGetal = [laatsteGewichtUpdate objectForKey:@"hoeveelheid"];
                                [heupenAantallen replaceObjectAtIndex:i withObject:gewichtGetal];
                                for(NSInteger j=i-1;j>=0;j--) {
                                    [heupenAantallen replaceObjectAtIndex:j withObject:gewichtGetal];
                                }
                            }
                            else {
                                for(NSInteger j=i;j>=0;j--) {
                                    [heupenAantallen replaceObjectAtIndex:j withObject:[NSNumber numberWithFloat:gewichtRechts]];
                                }
                            }
                        }
                    }
                }
            }
        }
        else if(taille) {
            for (NSInteger i = period-1; i>=0; i--) {
                if([tailleAantallen objectAtIndex:i]== (id)[NSNull null]) {
                    if(i == period-1) {
                        //Dan zitten we aan het einde van de rij
                        BOOL stop = NO;
                        while (!stop) {
                            for(NSInteger j=period-2;j>0;j--) {
                                if([tailleAantallen objectAtIndex:i]!= (id)[NSNull null]) {
                                    stop = YES;
                                    long aantalindices = i-j;
                                    for(NSInteger k=1; k<=aantalindices; k++) {
                                        [tailleAantallen replaceObjectAtIndex:j+k withObject:[tailleAantallen objectAtIndex:j]];
                                    }
                                }
                            }
                            if(!stop) {
                                PFQuery *queryGewicht2 = [PFQuery queryWithClassName:login];
                                [queryGewicht2 whereKey:@"type" equalTo:@"profiel"];
                                [queryGewicht2 whereKey:@"Naam" equalTo:@"taille"];
                                [queryGewicht2 orderByDescending:@"updatedAt"];
                                NSArray *results2 = [queryGewicht2 findObjects];
                                PFObject *meestRecent = [results2 objectAtIndex:0];
                                NSNumber *gewichtGetal = [meestRecent objectForKey:@"hoeveelheid"];
                                [tailleAantallen replaceObjectAtIndex:i  withObject:gewichtGetal];
                                stop = YES;
                            }
                        }
                    }
                    else if(i==0) {
                        //Dan zitten we aan het begin van de rij
                        //Dus halen we het meest recente gewicht op
                        PFQuery *queryGewicht2 = [PFQuery queryWithClassName:login];
                        [queryGewicht2 whereKey:@"type" equalTo:@"profiel"];
                        [queryGewicht2 whereKey:@"Naam" equalTo:@"taille"];
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                        [offsetComponents setDay:-period];
                        NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                        [queryGewicht2 whereKey:@"updatedAt" lessThanOrEqualTo:sinds];
                        [queryGewicht2 orderByAscending:@"updatedAt"];
                        NSArray *results = [queryGewicht2 findObjects];
                        PFObject *laatsteGewichtUpdate = [results objectAtIndex:0];
                        NSNumber *gewichtGetal = [laatsteGewichtUpdate objectForKey:@"hoeveelheid"];
                        [tailleAantallen replaceObjectAtIndex:0 withObject:gewichtGetal];
                    }
                    else {
                        //Ergens een getal tussenin
                        float gewichtRechts = [[tailleAantallen objectAtIndex:i+1] floatValue];
                        BOOL waardeLinksGevonden = NO;
                        long indexLinks;
                        float gewichtLinks;
                        for(NSInteger j=i-1;j>=0;j--) {
                            if([tailleAantallen objectAtIndex:j] != (id)[NSNull null]) {
                                waardeLinksGevonden = YES;
                                indexLinks = j;
                                gewichtLinks = [[tailleAantallen objectAtIndex:j] floatValue];
                                break;
                            }
                        }
                        if(waardeLinksGevonden) {
                            float verschilInGewicht = gewichtRechts - gewichtLinks;
                            float extra = indexLinks/(indexLinks+1);
                            float waarde = verschilInGewicht*extra;
                            NSNumber *gewichtwaarde = [NSNumber numberWithFloat:(gewichtLinks+waarde)];
                            [tailleAantallen replaceObjectAtIndex:i withObject:gewichtwaarde];
                        }
                        else {
                            PFQuery *queryGewicht3 = [PFQuery queryWithClassName:login];
                            [queryGewicht3 whereKey:@"type" equalTo:@"profiel"];
                            [queryGewicht3 whereKey:@"Naam" equalTo:@"taille"];
                            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                            NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
                            [offsetComponents setDay:-period];
                            NSDate *sinds = [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
                            [queryGewicht3 whereKey:@"updatedAt" lessThanOrEqualTo:sinds];
                            [queryGewicht3 orderByAscending:@"updatedAt"];
                            NSArray *results = [queryGewicht3 findObjects];
                            if([results count] > 0){
                                PFObject *laatsteGewichtUpdate = [results objectAtIndex:0];
                                NSNumber *gewichtGetal = [laatsteGewichtUpdate objectForKey:@"hoeveelheid"];
                                [tailleAantallen replaceObjectAtIndex:i withObject:gewichtGetal];
                                for(NSInteger j=i-1;j>=0;j--) {
                                    [tailleAantallen replaceObjectAtIndex:j withObject:gewichtGetal];
                                }
                            }
                            else {
                                for(NSInteger j=i;j>=0;j--) {
                                    [tailleAantallen replaceObjectAtIndex:j withObject:[NSNumber numberWithFloat:gewichtRechts]];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //streefdoelen
    streefheupen = nil;
    streefTaille = nil;
    if ((heupen&&!streefheupen)||(taille&&!streefTaille)) {
        PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
        [queryGewicht whereKey:@"type" equalTo:@"doel"];
        if(heupen) {
            [queryGewicht whereKey:@"soort" equalTo:@"heupen"];
        }
        else if(taille) {
            [queryGewicht whereKey:@"soort" equalTo:@"taille"];
        }
        [queryGewicht whereKey:@"Naam" equalTo:@"naam"];
        NSArray *results = [queryGewicht findObjects];
        int aantal = 0;
        if([results count] != 0) {
            PFObject *gewicht = [results objectAtIndex:0];
            aantal = [[gewicht objectForKey:@"hoeveelheid"] intValue];
        }
        if(heupen) {
            streefheupen = [NSArray arrayWithObjects:
                            [NSDecimalNumber numberWithInt:aantal],
                            [NSDecimalNumber numberWithInt:aantal],
                            [NSDecimalNumber numberWithInt:aantal],
                            [NSDecimalNumber numberWithInt:aantal],
                            [NSDecimalNumber numberWithInt:aantal],
                            [NSDecimalNumber numberWithInt:aantal],
                            [NSDecimalNumber numberWithInt:aantal],
                            nil];
        }
        else if(taille) {
            streefTaille = [NSArray arrayWithObjects:
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

-(void) initPicker {
    PFQuery *query = [PFQuery queryWithClassName:login];
    [query whereKey:@"type" equalTo:@"profiel"];
    if(heupen) {
        [query whereKey:@"Naam" equalTo:@"heupen"];
    }
    else if(taille) {
        [query whereKey:@"Naam" equalTo:@"taille"];
    }
    [query orderByDescending:@"updatedAt"];
    NSArray *results = [query findObjects];
    everentered = NO;
    if([results count] > 0){
        PFObject *recentResultaat = [results objectAtIndex:0];
        NSNumber *recent = [recentResultaat objectForKey:@"hoeveelheid"];
        int geheel = [recent intValue];
        int komma = (int) (([recent floatValue] - geheel)*100);
        [self.pickerCm selectRow:geheel inComponent:0 animated:NO];
        [self.pickerMm selectRow:komma inComponent:0 animated:NO];
        everentered = YES;
    }
}

@end
