//
//  LoginViewController.m
//  Vittles
//
//  Created by Anne Everars on 17/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginDoelViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController () {
    CGFloat animatedDistance;
    BOOL higher;
}

@end

@implementation LoginViewController
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naam.delegate = self;
    self.emailaddress.delegate = self;
    self.wachtwoord1.delegate = self;
    self.wachtwoord2.delegate = self;
    higher = false;
}

-(void)viewWillAppear:(BOOL)animated {
    //****PICKERS****
    NSMutableArray *array = [[NSMutableArray alloc] init];
	for (int i = 0; i < 100; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[array addObject:item];
	}
    self.aantallen = array;
    array = [[NSMutableArray alloc] init];
	for (int i = 0; i < 180; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[array addObject:item];
	}
    self.aantallenGewicht = array;
    array = [[NSMutableArray alloc] init];
	for (int i = 0; i < 3; i++){
		NSString *item = [[NSString alloc] initWithFormat:@"%i", i];
		[array addObject:item];
	}
    self.aantalMeter = array;
    self.geheelGewicht.dataSource = self;
    self.geheelGewicht.delegate = self;
    self.kommaGewicht.dataSource = self;
    self.kommaGewicht.delegate = self;
    self.geheelLengte.dataSource = self;
    self.geheelLengte.delegate = self;
    self.kommaLengte.dataSource = self;
    self.kommaLengte.delegate = self;
    //****SWITCH****
    [self.geslacht addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    if ([self.geslacht isOn]) {
        self.man.textColor = [UIColor lightGrayColor];
        self.vrouw.textColor = [UIColor blackColor];
    }
    else {
        self.man.textColor = [UIColor blackColor];
        self.vrouw.textColor = [UIColor lightGrayColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    if(higher) {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.x += animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        higher = false;
    }
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    if(textField.tag<=3 && !higher) {
        CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
        CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
        CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
        CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
        CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
        CGFloat heightFraction = numerator/denominator;
        if (heightFraction < 0.0) {
            heightFraction = 0.0;
        }
        else if (heightFraction > 1.0) {
            heightFraction = 1.0;
        }
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.x -= animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        higher = true;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"#"]) {
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.tag <= 2) {
        long tag = textField.tag + 1;
        [[self.view viewWithTag:tag] becomeFirstResponder];
    }
    else {
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.x += animatedDistance;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
        higher = false;
        [textField resignFirstResponder];
    }
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if(self.geheelGewicht==pickerView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.geheelGewicht.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallenGewicht objectAtIndex:row];
        return label;
    }
    else if(self.kommaGewicht==pickerView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.kommaGewicht.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallen objectAtIndex:row];
        return label;
    }
    else if(self.geheelLengte==pickerView) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.geheelLengte.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantalMeter objectAtIndex:row];
        return label;
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.kommaLengte.frame.size.width, pickerView.frame.size.height)];
        label.font = [UIFont fontWithName:@"System" size:19];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = [self.aantallen objectAtIndex:row];
        return label;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(self.geheelGewicht==pickerView) {
        return self.aantallenGewicht.count;
    }
    else if(self.geheelLengte==pickerView) {
        return self.aantalMeter.count;
    }
    else {
        return self.aantallen.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(self.geheelGewicht==pickerView) {
        return [self.aantallenGewicht objectAtIndex:row];
    }
    else if(self.geheelLengte==pickerView) {
        return [self.aantalMeter objectAtIndex:row];
    }
    else {
        return [self.aantallen objectAtIndex:row];
    }
}

-(void)changeSwitch:(id)sender {
    if ([sender isOn]) {
        self.man.textColor = [UIColor lightGrayColor];
        self.vrouw.textColor = [UIColor blackColor];
    }
    else {
        self.man.textColor = [UIColor blackColor];
        self.vrouw.textColor = [UIColor lightGrayColor];
    }
}

- (IBAction)Volgende:(id)sender {
    //Kijk of alle velden ingevuld zijn
    BOOL verdergaan = FALSE;
    if(self.naam.text && !self.naam.text.length <= 0) {
        if(self.emailaddress.text && !self.emailaddress.text.length <= 0) {
            if([self wachtwoordenMatchen]) {
                if(![self.geheelGewicht selectedRowInComponent:0]==0) {
                    if(![self.geheelLengte selectedRowInComponent:0]==0) {
                        verdergaan = TRUE;
                    }
                }
            }
        }
    }
    //Bewaar de opgeslagen data
    if(verdergaan){
        //1. Naam
        self.naam.layer.cornerRadius=8.0f;
        self.naam.layer.masksToBounds=YES;
        self.naam.layer.borderWidth = 1.0f;
        self.naam.layer.borderColor = [[UIColor clearColor]CGColor];
        //2. E-mail adres
        self.emailaddress.layer.cornerRadius=8.0f;
        self.emailaddress.layer.masksToBounds=YES;
        self.emailaddress.layer.borderWidth = 1.0f;
        self.emailaddress.layer.borderColor = [[UIColor clearColor]CGColor];
        //3. Wachtwoord
        self.wachtwoord1.layer.cornerRadius=8.0f;
        self.wachtwoord1.layer.masksToBounds=YES;
        self.wachtwoord1.layer.borderWidth = 1.0f;
        self.wachtwoord1.layer.borderColor = [[UIColor clearColor]CGColor];
        self.wachtwoord2.layer.cornerRadius=8.0f;
        self.wachtwoord2.layer.masksToBounds=YES;
        self.wachtwoord2.layer.borderWidth = 1.0f;
        self.wachtwoord2.layer.borderColor = [[UIColor clearColor]CGColor];
        [self registerNewUser];
    }
    else {
        if([self wachtwoordenMatchen]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foutje!" message:@"Je moet alle velden invullen voordat je kan verdergaan!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            //1. Naam
            if(!self.naam.text || self.naam.text.length <= 0) {
                self.naam.layer.cornerRadius=8.0f;
                self.naam.layer.masksToBounds=YES;
                self.naam.layer.borderWidth = 1.0f;
                self.naam.layer.borderColor = [[UIColor redColor] CGColor];
            }
            else {
                self.naam.layer.borderColor = [[UIColor clearColor]CGColor];
            }
            //2. E-mail adres
            if(!self.emailaddress.text || self.emailaddress.text.length <= 0) {
                self.emailaddress.layer.cornerRadius=8.0f;
                self.emailaddress.layer.masksToBounds=YES;
                self.emailaddress.layer.borderWidth = 1.0f;
                self.emailaddress.layer.borderColor = [[UIColor redColor] CGColor];
            }
            else {
                self.emailaddress.layer.borderColor = [[UIColor clearColor]CGColor];
            }
            //3. Wachtwoorden
            if(!self.wachtwoord1.text || self.wachtwoord1.text.length <= 0) {
                self.wachtwoord1.layer.cornerRadius=8.0f;
                self.wachtwoord1.layer.masksToBounds=YES;
                self.wachtwoord1.layer.borderWidth = 1.0f;
                self.wachtwoord1.layer.borderColor = [[UIColor redColor] CGColor];
            }
            else {
                self.wachtwoord1.layer.borderColor = [[UIColor clearColor]CGColor];
            }
            if(!self.wachtwoord2.text || self.wachtwoord2.text.length <= 0) {
                self.wachtwoord2.layer.cornerRadius=8.0f;
                self.wachtwoord2.layer.masksToBounds=YES;
                self.wachtwoord2.layer.borderWidth = 1.0f;
                self.wachtwoord2.layer.borderColor = [[UIColor redColor] CGColor];
            }
            else {
                self.wachtwoord2.layer.borderColor = [[UIColor clearColor]CGColor];
            }
        }
    }
}

- (IBAction)annuleren:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)registerNewUser {
    [self.naam resignFirstResponder];
    [self.emailaddress resignFirstResponder];
    [self.wachtwoord1 resignFirstResponder];
    [self.wachtwoord2 resignFirstResponder];
    //1. Lees waarden
    NSString *naamString = self.naam.text;
    NSString *emailString = self.emailaddress.text;
    NSString *wachtwoord = self.wachtwoord1.text;
    //2. Maak User aan
    PFUser *newUser = [PFUser user];
    newUser.username = naamString;
    newUser.email = emailString;
    newUser.password = wachtwoord;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            [self performSegueWithIdentifier:@"verdergaanLogin" sender:self];
        }
        else {
            NSString *errorBericht = [error description];
            if([errorBericht rangeOfString:@"username"].location != NSNotFound) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foutje!" message:@"Gebruiker met dezelfde naam is al geregistreerd." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
            else if([errorBericht rangeOfString:@"email"].location != NSNotFound) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foutje!" message:@"Gebruiker met hetzelfde e-mailadres is al geregistreerd." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alert show];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foutje!" message:@"Registratie mislukt." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"verdergaanLogin"]) {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            LoginDoelViewController *vc = [segue destinationViewController];
            NSString *geslachtStr = @"M";
            if([self.geslacht isOn]) {
                geslachtStr = @"V";
            }
            NSDate *geboortedatum = [self.geboortedatum date];
            NSNumber *lengteAantal = 0;
            NSNumber *gewichtAantal = 0;
            if(([self.geheelLengte selectedRowInComponent:0] >0) || ([self.kommaLengte selectedRowInComponent:0] >0)) {
                float geheelGetalLengte = [self.geheelLengte selectedRowInComponent:0];
                float kommaGetalLengte = [self.kommaLengte selectedRowInComponent:0];
                float lengte = (kommaGetalLengte/(100.0f));
                lengte = lengte + geheelGetalLengte;
                lengteAantal = [NSNumber numberWithFloat:lengte];
            }
            if(([self.geheelGewicht selectedRowInComponent:0] >0) || ([self.kommaGewicht selectedRowInComponent:0] >0)) {
                float geheelGetal = [self.geheelGewicht selectedRowInComponent:0];
                float kommaGetal = [self.kommaGewicht selectedRowInComponent:0];
                float gewicht = (kommaGetal/(100.0f));
                gewicht = gewicht + geheelGetal;
                gewichtAantal = [NSNumber numberWithFloat:gewicht];
            }
            vc.geboortedatum = geboortedatum;
            vc.gewicht = gewichtAantal;
            vc.lengte = lengteAantal;
            vc.geslacht = geslachtStr;
            
        }
    }
}

-(BOOL)wachtwoordenMatchen {
    if(![self.wachtwoord1.text isEqualToString:self.wachtwoord2.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foutje!" message:@"Je moet twee keer hetzelfde wachtwoord ingeven!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    return TRUE;
}

@end
