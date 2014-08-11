//
//  FotoalbumViewController.m
//  Vittles
//
//  Created by Anne Everars on 10/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "FotoalbumViewController.h"
#import "ECSlidingViewController.h"
#import "MenuUitklapbaarViewController.h"
#import <Parse/Parse.h>

@interface FotoalbumViewController () {
    NSString *login;
}

@end

@implementation FotoalbumViewController

@synthesize menuBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    //****MENU****
    //alsof het erover slide
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    //is er al een viewcontroller?
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MenuUitklapbaarViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(20, 24, 44, 34);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menuButton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.menuBtn];
    
    //****PROFIELFOTO****
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    NSArray *results = [query findObjects];
    if([results count] > 0){
        PFObject *foto = [results objectAtIndex:0];
        PFFile *theImage = [foto objectForKey:@"imageFile"];
        NSData *imageData = [theImage getData];
        UIImage *image = [UIImage imageWithData:imageData];
        [self.profielfoto setContentMode:UIViewContentModeScaleAspectFit];
        [self.profielfoto setClipsToBounds:YES];
        [self.profielfoto setImage:image];
    }
    //****NAAM****
    NSString *naam = user.username;
    self.Gebruikersnaam.text = naam;
    //****Lengte,Leeftijd en gewicht****
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    PFQuery *queryUserOne = [PFQuery queryWithClassName:login];
    [queryUserOne whereKey:@"type" equalTo:@"profiel"];
    [queryUserOne whereKey:@"Naam" equalTo:@"gegevens"];
    NSArray *resultsGegevens = [queryUserOne findObjects];
    PFObject *gegevens = [resultsGegevens objectAtIndex:0];
    float waarde =
    [[gegevens objectForKey:@"hoeveelheid"] floatValue];
    NSString *lengte = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" m"];
    NSDate *geboortedatum = [gegevens objectForKey:@"Datum"];
    NSDate *vandaag = [NSDate date];
    NSTimeInterval interval = [vandaag timeIntervalSinceDate:geboortedatum];
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date1];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    long year = [breakdownInfo year];
    NSString *leeftijd = [[[NSString stringWithFormat:@"%li", year]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" jaar"];
    PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
    [queryGewicht whereKey:@"type" equalTo:@"profiel"];
    [queryGewicht whereKey:@"Naam" equalTo:@"gewicht"];
    [queryGewicht orderByDescending:@"updatedAt"];
    NSArray *resultsGewicht = [queryGewicht findObjects];
    assert(resultsGewicht.count > 0);
    PFObject *result = [resultsGewicht objectAtIndex:0];
    float gewichtGetal = [[result objectForKey:@"hoeveelheid"] floatValue];
    NSString *gewicht = [[[NSString stringWithFormat:@"%.2f", gewichtGetal]stringByReplacingOccurrencesOfString:@"." withString:@", "] stringByAppendingString:@" kg"];
    self.karakteristieken.text = [[[[leeftijd stringByAppendingString:@"\n"] stringByAppendingString:lengte] stringByAppendingString:@"\n"] stringByAppendingString:gewicht];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
