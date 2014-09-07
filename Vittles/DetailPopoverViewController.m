//
//  DetailPopoverViewController.m
//  Vittles
//
//  Created by Anne Everars on 16/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "DetailPopoverViewController.h"
#import <Parse/Parse.h>

@interface DetailPopoverViewController () {
    NSString *login;
}

@end

@implementation DetailPopoverViewController

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

-(void)viewWillAppear:(BOOL)animated {
    //Gebruiker
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    //Datum
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:[NSDate date]];
    NSDate* dateOnly = [calendar dateFromComponents:components];
    
    self.elementen = [[NSMutableArray alloc]init];
    self.aantallen = [[NSMutableArray alloc]init];
    self.lijstje.delegate = self;
    self.lijstje.dataSource = self;
    PFQuery *query = [PFQuery queryWithClassName:login];
    [query whereKey:@"type" equalTo:@"food"];
    [query whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
    if(self.type == 0) {
        //water
        self.NavigationBar.topItem.title = @"Water en dranken";
        [query whereKey:@"soort" equalTo:@"Dranken"];
        NSArray *results = [query findObjects];
        for(PFObject *result in results) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
    }
    else if(self.type == 1) {
        //fruit
        self.NavigationBar.topItem.title = @"Groenten en fruit";
        [query whereKey:@"soort" equalTo:@"Fruit"];
        NSArray *results = [query findObjects];
        for(PFObject *result in results) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
        PFQuery *query2 = [PFQuery queryWithClassName:login];
        [query2 whereKey:@"type" equalTo:@"food"];
        [query2 whereKey:@"soort" equalTo:@"Groenten"];
        [query2 whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
        NSArray *results2 = [query2 findObjects];
        for(PFObject *result in results2) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
    }
    else if(self.type == 2) {
        //Granen
        self.NavigationBar.topItem.title = @"Graanproducten";
        [query whereKey:@"soort" equalTo:@"Graanproducten"];
        NSArray *results = [query findObjects];
        for(PFObject *result in results) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
    }
    else if(self.type == 3) {
        //vlees
        self.NavigationBar.topItem.title = @"Vlees en vis";
        [query whereKey:@"soort" equalTo:@"Vleesproducten"];
        NSArray *results = [query findObjects];
        for(PFObject *result in results) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
        PFQuery *query2 = [PFQuery queryWithClassName:login];
        [query2 whereKey:@"type" equalTo:@"food"];
        [query2 whereKey:@"soort" equalTo:@"Vis en schaaldieren"];
        [query2 whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
        NSArray *results2 = [query2 findObjects];
        for(PFObject *result in results2) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
    }
    else if(self.type == 4) {
        //olie
        self.NavigationBar.topItem.title = @"Olie en vetten";
        [query whereKey:@"soort" equalTo:@"Oliën en vetten"];
        NSArray *results = [query findObjects];
        for(PFObject *result in results) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
    }
    else if(self.type == 5) {
        //melk
        self.NavigationBar.topItem.title = @"Zuivelproducten";
        [query whereKey:@"soort" equalTo:@"Zuivelproducten"];
        NSArray *results = [query findObjects];
        for(PFObject *result in results) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
    }
    else if(self.type == 6) {
        //suiker
        self.NavigationBar.topItem.title = @"Suikers";
        [query whereKey:@"soort" equalTo:@"Suikerproducten"];
        NSArray *results = [query findObjects];
        for(PFObject *result in results) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
    }
    else if(self.type == 7) {
        //rest
        self.NavigationBar.topItem.title = @"Restgroep";
        [query whereKey:@"soort" equalTo:@"Diversen"];
        NSArray *results = [query findObjects];
        for(PFObject *result in results) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
    }
    else {
        //activiteiten
        self.NavigationBar.topItem.title = @"Activiteiten";
        PFQuery *query2 = [PFQuery queryWithClassName:login];
        [query2 whereKey:@"type" equalTo:@"activity"];
        [query2 whereKey:@"updatedAt" greaterThanOrEqualTo:dateOnly];
        NSArray *results2 = [query2 findObjects];
        for(PFObject *result in results2) {
            NSString *naam = [result objectForKey:@"Naam"];
            float waarde = [[result objectForKey:@"energie"] floatValue];
            NSString *energie = [[[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kcal"];
            [self.elementen addObject:naam];
            [self.aantallen addObject:energie];
        }
    }
    if([self.elementen count] > 0) {
        [self.lijstje setHidden:FALSE];
        [self.label setHidden:TRUE];
    }
    else {
        [self.lijstje setHidden:TRUE];
        [self.label setHidden:FALSE];
        self.label.text = @"Van deze categorie heb je geen items toegevoegd.";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.elementen.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier: CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    [[cell textLabel] setNumberOfLines:0]; // unlimited number of lines
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    cell.textLabel.text = [self.elementen objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.aantallen objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)done:(id)sender {
        [self.delegate DetailPopoverViewControllerDidFinishAdding:self];
}
@end
