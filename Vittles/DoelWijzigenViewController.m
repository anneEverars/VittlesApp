//
//  DoelWijzigenViewController.m
//  Vittles
//
//  Created by Anne Everars on 8/04/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "DoelWijzigenViewController.h"
#import <Parse/Parse.h>
#import "ECSlidingViewController.h"

@interface DoelWijzigenViewController () {
    BOOL gewichtChecked;
    BOOL heupenChecked;
    BOOL tailleChecked;
    BOOL geenTijdChecked;
    BOOL tijdChecked;
    NSString *login;
    float verschil;
}

@end

@implementation DoelWijzigenViewController

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
		NSString *item = [[NSString alloc] initWithFormat:@"%02i", i];
		[array addObject:item];
	}
    self.aantallen = array;
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
    [self updateDifficulty];
    //****HUIDIG GEWICHT****
    PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
    [queryGewicht whereKey:@"type" equalTo:@"profiel"];
    [queryGewicht whereKey:@"Naam" equalTo:@"gewicht"];
    NSArray *results = [queryGewicht findObjects];
    PFObject *object = [results objectAtIndex:0];
    float gewicht = [[object objectForKey:@"hoeveelheid"] floatValue];
    self.huidigeGewicht.text = [[[NSString stringWithFormat:@"%.2f", gewicht]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kg"];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setProgressView:nil];
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
        PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
        [queryGewicht whereKey:@"type" equalTo:@"profiel"];
        if(gewichtChecked){
            [queryGewicht whereKey:@"Naam" equalTo:@"gewicht"];
        }
        else if(heupenChecked) {
            [queryGewicht whereKey:@"Naam" equalTo:@"heupen"];
        }
        else {
            [queryGewicht whereKey:@"Naam" equalTo:@"taille"];
        }
        NSArray *results = [queryGewicht findObjects];
        PFObject *object = [results objectAtIndex:0];
        float aantalNu = [[object objectForKey:@"hoeveelheid"] floatValue];
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


- (IBAction)save:(id)sender {
    //Bestaat er al een doel?
    PFQuery *queryUser = [PFQuery queryWithClassName:login];
    [queryUser whereKey:@"type" equalTo:@"doel"];
    [queryUser whereKey:@"Naam" equalTo:@"naam"];
    NSArray *resultaat = [queryUser findObjects];
    PFObject *doel =[resultaat objectAtIndex:0];
    PFQuery *queryUser2 = [PFQuery queryWithClassName:login];
    [queryUser2 whereKey:@"type" equalTo:@"doel"];
    [queryUser2 whereKey:@"Naam" equalTo:@"begin"];
    NSArray *resultaat2 = [queryUser2 findObjects];
    PFObject *begin =[resultaat2 objectAtIndex:0];
    doel[@"type"] = @"doel";
    doel[@"Naam"] = @"naam";
    PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
    [queryGewicht whereKey:@"type" equalTo:@"profiel"];
    NSString *soort;
    if(gewichtChecked){
        soort=@"gewicht";
        [queryGewicht whereKey:@"Naam" equalTo:@"gewicht"];
    }
    else if(heupenChecked) {
        soort=@"heupen";
        [queryGewicht whereKey:@"Naam" equalTo:@"heupen"];
    }
    else {
        soort=@"taille";
        [queryGewicht whereKey:@"Naam" equalTo:@"taille"];
    }
    doel[@"soort"] = soort;
    float aantalEenheden = [self.aantal selectedRowInComponent:0];
    float aantalKomma = [self.aantalKomma selectedRowInComponent:0];
    float aantalDoel = aantalEenheden+(aantalKomma/100);
    NSArray *results = [queryGewicht findObjects];
    PFObject *object = [results objectAtIndex:0];
    float aantalNu = [[object objectForKey:@"hoeveelheid"] floatValue];
    verschil = aantalNu - aantalDoel;
    doel[@"hoeveelheid"] = [NSNumber numberWithFloat:verschil];
    if(tijdChecked) {
        NSInteger seconden = [self.tijdWeken selectedRowInComponent:0]*604800+[self.tijdDagen selectedRowInComponent:0]*86400;
        NSDate *tegen = [[NSDate date]dateByAddingTimeInterval:seconden];
        doel[@"Deadline"] = tegen;
    }
    [doel saveInBackground];
    begin[@"soort"] = soort;
    begin[@"hoeveelheid"] = [NSNumber numberWithFloat:aantalNu];
    [begin saveInBackground];
    //Ga terug naar activiteitenlogboek
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Doelstellingen"];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)GewichtCheckbox:(id)sender {
    [tailleCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [heupenCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [gewichtCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    gewichtChecked = YES;
    heupenChecked = NO;
    tailleChecked = NO;
    self.huidigeStatus.text = @"Je huidige gewicht :";
    PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
    [queryGewicht whereKey:@"type" equalTo:@"profiel"];
    [queryGewicht whereKey:@"Naam" equalTo:@"gewicht"];
    NSArray *results = [queryGewicht findObjects];
    PFObject *object = [results objectAtIndex:0];
    float gewicht = [[object objectForKey:@"hoeveelheid"] floatValue];
    self.huidigeGewicht.text = [[[NSString stringWithFormat:@"%.2f", gewicht]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" kg"];
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
    PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
    [queryGewicht whereKey:@"type" equalTo:@"profiel"];
    [queryGewicht whereKey:@"Naam" equalTo:@"heupen"];
    NSArray *results = [queryGewicht findObjects];
    PFObject *object = [results objectAtIndex:0];
    float gewicht = [[object objectForKey:@"hoeveelheid"] floatValue];
    self.huidigeGewicht.text = [[[NSString stringWithFormat:@"%.2f", gewicht]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" cm"];
    self.eenheid.text = @"cm";
    [self updateDifficulty];
}

- (IBAction)TailleCheckbox:(id)sender {
    [gewichtCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [heupenCheckbox setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
    [tailleCheckbox setImage:[UIImage imageNamed:@"checkBoxMarked.png"] forState:UIControlStateNormal];
    gewichtChecked = NO;
    heupenChecked = NO;
    tailleChecked = YES;
    self.huidigeStatus.text = @"Je huidige taille-omtrek :";
    PFQuery *queryGewicht = [PFQuery queryWithClassName:login];
    [queryGewicht whereKey:@"type" equalTo:@"profiel"];
    [queryGewicht whereKey:@"Naam" equalTo:@"taille"];
    NSArray *results = [queryGewicht findObjects];
    PFObject *object = [results objectAtIndex:0];
    float gewicht = [[object objectForKey:@"hoeveelheid"] floatValue];
    self.huidigeGewicht.text = [[[NSString stringWithFormat:@"%.2f", gewicht]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" cm"];
    self.eenheid.text = @"cm";
    [self updateDifficulty];
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

@end