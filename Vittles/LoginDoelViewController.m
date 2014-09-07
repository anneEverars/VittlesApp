//
//  LoginDoelViewController.m
//  Vittles
//
//  Created by Anne Everars on 17/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "LoginDoelViewController.h"
#import <Parse/Parse.h>

@interface LoginDoelViewController () {
    BOOL gewichtChecked;
    BOOL heupenChecked;
    BOOL tailleChecked;
    BOOL geenTijdChecked;
    BOOL tijdChecked;
    NSString *login;
    float verschil;
}

@end

@implementation LoginDoelViewController

@synthesize gewichtCheckbox;
@synthesize heupenCheckbox;
@synthesize tailleCheckbox;
@synthesize geenTijdCheckbox;
@synthesize tijdCheckbox;
@synthesize progressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //****Gebruiker****
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    [self.resultaat setHidden:TRUE];
    [self.ditBetekent setHidden:TRUE];
    //****PICKERS****
    NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i = 0; i < 100; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[array addObject:item];
	}
    self.aantallen = array;
    self.aantal.dataSource = self;
    self.aantal.delegate = self;
    self.aantalKomma.dataSource = self;
    self.aantalKomma.delegate = self;
    self.tijdWeken.dataSource = self;
    self.tijdWeken.delegate = self;
    self.tijdDagen.dataSource = self;
    self.tijdDagen.delegate = self;
    NSMutableArray *arrayD = [[NSMutableArray alloc] init];
	for (int i = 0; i < 8; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[arrayD addObject:item];
	}
    self.dagen = arrayD;
    NSMutableArray *arrayW = [[NSMutableArray alloc] init];
	for (int i = 0; i < 100; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[arrayW addObject:item];
	}
    self.weken = arrayW;
    //****CHECKBUTTONS****
    gewichtChecked = YES;
    heupenChecked = NO;
    tailleChecked = NO;
    geenTijdChecked = YES;
    tijdChecked = NO;
    //****MOEILIJKHEID****
    verschil = 0.0f;
    [self updateDifficulty];
    //****HUIDIG GEWICHT****
    float gewicht = [self.gewicht floatValue];
    self.huidigeGewicht.text = [[[NSString stringWithFormat:@"%.2f", gewicht]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if(self.aantal==pickerView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.aantal.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallen objectAtIndex:row];
        return label;
    }
    else if(self.tijdDagen==pickerView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tijdDagen.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.dagen objectAtIndex:row];
        return label;
    }
    else if(self.tijdWeken==pickerView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tijdWeken.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.weken objectAtIndex:row];
        return label;
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.aantalKomma.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallen objectAtIndex:row];
        return label;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.tijdWeken==pickerView) {
        return self.weken.count;
    }
    else if(self.tijdDagen==pickerView) {
        return self.dagen.count;
    }
    return self.aantallen.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(self.tijdWeken==pickerView) {
        return [self.weken objectAtIndex:row];
    }
    else if(self.tijdDagen==pickerView) {
        return [self.dagen objectAtIndex:row];
    }
    return [self.aantallen objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(self.aantal==pickerView || self.aantalKomma==pickerView) {
        float aantalEenheden = [self.aantal selectedRowInComponent:0];
        float aantalKomma = [self.aantalKomma selectedRowInComponent:0];
        float aantalDoel = aantalEenheden+(aantalKomma/100);
        float aantalNu = 0;
        if(gewichtChecked){
            aantalNu = [self.gewicht floatValue];
        }
        else if(heupenChecked) {
            aantalNu = [self.heupen floatValue];
        }
        else {
            aantalNu = [self.taille floatValue];
        }
        verschil = aantalNu - aantalDoel;
        if(gewichtChecked){
            self.resultaat.text = [[[NSString stringWithFormat:@"%.2f", verschil]stringByReplacingOccurrencesOfString:@"." withString:@","]stringByAppendingString:@" kg wil verliezen"];
        }
        else if(heupenChecked) {
            self.resultaat.text = [[[NSString stringWithFormat:@"%.2f", verschil]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" cm op je heupen wil verliezen"];
        }
        else {
            self.resultaat.text = [[[NSString stringWithFormat:@"%.2f", verschil]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" cm in je taille wil verliezen"];
        }
        [self.resultaat setHidden:FALSE];
        [self.ditBetekent setHidden:FALSE];
        
    }
    [self updateDifficulty];
}

- (IBAction)GewichtCheckbox:(id)sender {
    [tailleCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [heupenCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [gewichtCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    gewichtChecked = YES;
    heupenChecked = NO;
    tailleChecked = NO;
    self.huidigeStatus.text = @"Je huidige gewicht :";
    float huidiggewicht = [self.gewicht floatValue];
    self.huidigeGewicht.text = [[[NSString stringWithFormat:@"%.2f", huidiggewicht]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kg"];
    [self updateDifficulty];
}
- (IBAction)HeupenCheckbox:(id)sender {
    [tailleCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [gewichtCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [heupenCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    gewichtChecked = NO;
    heupenChecked = YES;
    tailleChecked = NO;
    self.huidigeStatus.text = @"Je huidige heupenomtrek :";
    if(self.heupen > 0) {
        float heupenFloat = [self.heupen floatValue];
        self.huidigeGewicht.text = [[[NSString stringWithFormat:@"%.2f", heupenFloat] stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" cm"];
        self.eenheid.text = @"cm";
        [self updateDifficulty];
    }
    else {
        UIAlertView* dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:self];
        [dialog setMessage:@"Geef je heupomtrek in om verder te gaan"];
        [dialog addButtonWithTitle:@"Cancel"];
        [dialog setCancelButtonIndex:0];
        [dialog addButtonWithTitle:@"OK"];
        dialog.tag = 5;
        dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
        [dialog show];
    }
}
- (IBAction)TailleCheckbox:(id)sender {
    [gewichtCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [heupenCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [tailleCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    gewichtChecked = NO;
    heupenChecked = NO;
    tailleChecked = YES;
    self.huidigeStatus.text = @"Je huidige taille-omtrek :";
    if(self.taille > 0) {
        float tailleFloat = [self.taille floatValue];
        self.huidigeGewicht.text = [[[NSString stringWithFormat:@"%.2f", tailleFloat] stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" cm"];
        self.eenheid.text = @"cm";
        [self updateDifficulty];
    }
    else {
        UIAlertView* dialog = [[UIAlertView alloc] init];
        [dialog setDelegate:self];
        [dialog setMessage:@"Geef je tailleomtrek in om verder te gaan"];
        [dialog addButtonWithTitle:@"Cancel"];
        [dialog setCancelButtonIndex:0];
        [dialog addButtonWithTitle:@"OK"];
        dialog.tag = 5;
        dialog.alertViewStyle = UIAlertViewStylePlainTextInput;
        [dialog show];
    }
}

- (IBAction)GeenTijdCheckbox:(id)sender {
    [tijdCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [geenTijdCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    geenTijdChecked = YES;
    tijdChecked = NO;
    [self updateDifficulty];
}

- (IBAction)TijdCheckbox:(id)sender {
    [geenTijdCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [tijdCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    geenTijdChecked = NO;
    tijdChecked = YES;
    [self updateDifficulty];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *waarde = textField.text;
        if(heupenChecked) {
            NSString *waarde2 = [waarde stringByReplacingOccurrencesOfString:@"." withString:@","];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            self.heupen = [f numberFromString:waarde2];
        }
        else if(tailleChecked) {
            NSString *waarde2 = [waarde stringByReplacingOccurrencesOfString:@"." withString:@","];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            self.taille = [f numberFromString:waarde2];
        }
        self.huidigeGewicht.text = [[waarde stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" cm"];
        self.eenheid.text = @"cm";
        [self updateDifficulty];
    }
    else {
        [self GewichtCheckbox:self];
    }
}

- (void) updateDifficulty {
    float moeilijkheid = 0.33f;
    if (tijdChecked) {
        if (gewichtChecked) {
            long weken = [self.tijdWeken selectedRowInComponent:0];
            float gemiddeld = verschil/weken;
            if(gemiddeld <= 0.5) {
                moeilijkheid = 0.2f;
            }
            else if(gemiddeld <= 1.0) {
                moeilijkheid = 0.5f;
            }
            else {
                moeilijkheid = 0.8f;
            }
        }
    }
    else {
        if (gewichtChecked &&(verschil > 5)) {
            moeilijkheid += 0.2f;
        }
    }
    if(moeilijkheid < 0.33) {
        UIColor *tintColor = [UIColor greenColor];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [[CERoundProgressView appearance] setTintColor:tintColor];
    }
    else if(moeilijkheid < 0.66) {
        UIColor *tintColor = [UIColor orangeColor];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [[CERoundProgressView appearance] setTintColor:tintColor];
    }
    else {
        UIColor *tintColor = [UIColor redColor];
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [[CERoundProgressView appearance] setTintColor:tintColor];
    }
    self.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
    self.progressView.startAngle = (3.0*M_PI)/2.0;
    self.progressView.progress = moeilijkheid;
}

- (IBAction)registreer:(id)sender {
    BOOL verdergaan = FALSE;
    if(! [self.resultaat isHidden]) {
        verdergaan = true;
    }
    if(verdergaan) {
        //1. Profielgegevens
        PFObject *update = [[PFObject alloc] initWithClassName:login];
        update[@"type"] = @"profiel";
        update[@"Naam"] = @"gegevens";
        update[@"hoeveelheid"] = self.lengte;
        update[@"Datum"] = self.geboortedatum;
        update[@"soort"] = self.geslacht;
        [update save];
        //2. Gewicht
        PFObject *updateGewicht = [PFObject objectWithClassName:login];
        updateGewicht[@"type"] = @"profiel";
        updateGewicht[@"Naam"] = @"gewicht";
        updateGewicht[@"hoeveelheid"] = self.gewicht;
        [updateGewicht saveInBackground];
        //3. Eventueel taille of heupen
        if(self.heupen>0) {
            PFObject *updateHeupen = [PFObject objectWithClassName:login];
            updateHeupen[@"type"] = @"profiel";
            updateHeupen[@"Naam"] = @"heupen";
            updateHeupen[@"hoeveelheid"] = self.heupen;
            [updateHeupen saveInBackground];
        }
        if(self.taille>0) {
            PFObject *updateTaille = [PFObject objectWithClassName:login];
            updateTaille[@"type"] = @"profiel";
            updateTaille[@"Naam"] = @"taille";
            updateTaille[@"hoeveelheid"] = self.taille;
            [updateTaille saveInBackground];
        }
        //4. ADH
        [self bepaalADH];
        //5. Doelstelling
        NSString *soort;
        if(gewichtChecked){
            soort=@"gewicht";
        }
        else if(heupenChecked) {
            soort=@"heupen";
        }
        else {
            soort=@"taille";
        }
        float aantalEenheden = [self.aantal selectedRowInComponent:0];
        float aantalKomma = [self.aantalKomma selectedRowInComponent:0];
        float aantalDoel = aantalEenheden+(aantalKomma/100);
        PFObject *doel = [PFObject objectWithClassName:login];
        doel[@"type"] = @"doel";
        doel[@"Naam"] = @"naam";
        doel[@"soort"] = soort;
        doel[@"hoeveelheid"] = [NSNumber numberWithFloat:aantalDoel];
        if(tijdChecked) {
            NSInteger seconden = [self.tijdWeken selectedRowInComponent:0]*604800+[self.tijdDagen selectedRowInComponent:0]*86400;
            NSDate *tegen = [[NSDate date]dateByAddingTimeInterval:seconden];
            doel[@"Deadline"] = tegen;
        }
        [doel saveInBackground];
    
        PFObject *doelBegin = [PFObject objectWithClassName:login];
        doelBegin[@"type"] = @"doel";
        doelBegin[@"Naam"] = @"begin";
        doelBegin[@"soort"] = soort;
        NSNumber *aantalBegin = self.gewicht;
        if(tailleChecked){
            aantalBegin=self.taille;
        }
        else if(heupenChecked) {
            aantalBegin=self.heupen;
        }
        doelBegin[@"hoeveelheid"] = aantalBegin;
        [doelBegin saveInBackground];
        //****NOTIFICATIES****
        int uur = 11;
        int minuten = 0;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date]];
        [components setHour:uur];
        [components setMinute:minuten];
        NSDate *datum = [calendar dateFromComponents:components];
        PFObject *notificatie = [PFObject objectWithClassName:login];
        notificatie[@"type"] = @"profiel";
        notificatie[@"Naam"] = @"notificatie";
        notificatie[@"aan"] = @"Ja";
        notificatie[@"voedingChecked"] = [NSNumber numberWithBool:TRUE];
        notificatie[@"activiteitenChecked"] = [NSNumber numberWithBool:TRUE];
        notificatie[@"vooruitgangChecked"] = [NSNumber numberWithBool:TRUE];
        notificatie[@"voeding"] = datum;
        notificatie[@"activiteiten"] = datum;
        notificatie[@"vooruitgangUUR"] = datum;
        [notificatie saveInBackground];
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        if (!localNotification) {
            return;
        }
        localNotification.fireDate = datum;
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        [localNotification setAlertAction:@"openen"];
        [localNotification setAlertBody:@"Heb je je maaltijd al ingegeven?"];
        [localNotification setSoundName:UILocalNotificationDefaultSoundName];
        [localNotification setRepeatInterval:NSDayCalendarUnit];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        localNotification = [[UILocalNotification alloc] init];
        if (!localNotification) {
            return;
        }
        localNotification.fireDate = [calendar dateFromComponents:components];
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        [localNotification setAlertAction:@"openen"];
        [localNotification setAlertBody:@"Heb je je uitgevoerde activiteiten al ingegeven?"];
        [localNotification setSoundName:UILocalNotificationDefaultSoundName];
        [localNotification setRepeatInterval:NSDayCalendarUnit];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        localNotification = [[UILocalNotification alloc] init];
        if (!localNotification) {
            return;
        }
        localNotification.fireDate = [calendar dateFromComponents:components];
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        [localNotification setAlertAction:@"openen"];
        [localNotification setAlertBody:@"Heb je je vooruitgang al aangegeven?"];
        [localNotification setSoundName:UILocalNotificationDefaultSoundName];
        [localNotification setRepeatInterval:NSDayCalendarUnit];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foutje!" message:@"Je moet een streefdoel kiezen voordat je kan verdergaan!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    PFQuery *queryUserGewicht = [PFQuery queryWithClassName:login];
    if(!([[queryUserGewicht findObjects] count]>0)){
        NSLog(@"Login creatie is gefaald!");
    }
}

- (IBAction)cancel:(id)sender {
    [PFUser logOut];
    UIStoryboard *storyboard = [self storyboard];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"welkom"];
    [self presentViewController:vc animated:YES completion:nil];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void)bepaalADH {
    //****leeftijd****
    NSDate *vandaag = [NSDate date];
    NSTimeInterval interval = [vandaag timeIntervalSinceDate:self.geboortedatum];
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:interval sinceDate:date1];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSInteger year = [breakdownInfo year];
    //****Geslacht****
    NSNumber *water = [[NSNumber alloc] init];
    NSNumber *fruit = [[NSNumber alloc] init];
    NSNumber *granen = [[NSNumber alloc] init];
    NSNumber *vlees = [[NSNumber alloc] init];
    NSNumber *vetten = [[NSNumber alloc] init];
    NSNumber *melk = [[NSNumber alloc] init];
    NSNumber *suikers = [NSNumber numberWithFloat:20.0f];
    NSNumber *rest = [NSNumber numberWithFloat:20.0f];
    NSNumber *hoeveelheid = [NSNumber numberWithFloat:30.0f];
    if([self.geslacht isEqualToString:@"M"]) {
        if(year <= 12) {
        }
        else if (year <= 18) {
        }
        else if(year <= 50) {
            water = [NSNumber numberWithFloat:2000.0f];
            fruit = [NSNumber numberWithFloat:400.0f];
            granen = [NSNumber numberWithFloat:500.0f];
            vlees = [NSNumber numberWithFloat:125.0f];
            vetten = [NSNumber numberWithFloat:50.0f];
            melk = [NSNumber numberWithFloat:500.0f];
        }
        else if(year <= 70) {
            water = [NSNumber numberWithFloat:2000.0f];
            fruit = [NSNumber numberWithFloat:400.0f];
            granen = [NSNumber numberWithFloat:400.0f];
            vlees = [NSNumber numberWithFloat:125.0f];
            vetten = [NSNumber numberWithFloat:45.0f];
            melk = [NSNumber numberWithFloat:530.0f];
        }
        else {
            water = [NSNumber numberWithFloat:2000.0f];
            fruit = [NSNumber numberWithFloat:350.0f];
            granen = [NSNumber numberWithFloat:350.0f];
            vlees = [NSNumber numberWithFloat:125.0f];
            vetten = [NSNumber numberWithFloat:40.0f];
            melk = [NSNumber numberWithFloat:670.0f];
        }
    }
    else {
        if(year <= 12) {
        }
        else if (year <= 18) {
        }
        else if(year <= 50) {
            water = [NSNumber numberWithFloat:2000.0f];
            fruit = [NSNumber numberWithFloat:400.0f];
            granen = [NSNumber numberWithFloat:410.0f];
            vlees = [NSNumber numberWithFloat:125.0f];
            vetten = [NSNumber numberWithFloat:45.0f];
            melk = [NSNumber numberWithFloat:480.0f];
        }
        else if(year <= 70) {
            water = [NSNumber numberWithFloat:2000.0f];
            fruit = [NSNumber numberWithFloat:400.0f];
            granen = [NSNumber numberWithFloat:325.0f];
            vlees = [NSNumber numberWithFloat:125.0f];
            vetten = [NSNumber numberWithFloat:40.0f];
            melk = [NSNumber numberWithFloat:530.0f];
        }
        else {
            water = [NSNumber numberWithFloat:2000.0f];
            fruit = [NSNumber numberWithFloat:350.0f];
            granen = [NSNumber numberWithFloat:265.0f];
            vlees = [NSNumber numberWithFloat:125.0f];
            vetten = [NSNumber numberWithFloat:35.0f];
            melk = [NSNumber numberWithFloat:670.0f];
        }
    }
    PFObject *adh = [PFObject objectWithClassName:login];
    adh[@"type"] = @"ADH";
    adh[@"water"] = water;
    adh[@"fruit"] = fruit;
    adh[@"granen"] = granen;
    adh[@"vlees"] = vlees;
    adh[@"vetten"] = vetten;
    adh[@"melk"] = melk;
    adh[@"suiker"] = suikers;
    adh[@"rest"] = rest;
    adh[@"hoeveelheid"] = hoeveelheid;
    [adh saveInBackground];
}
@end
