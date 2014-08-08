//
//  AanmeldenViewController.m
//  Vittles
//
//  Created by Anne Everars on 18/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "AanmeldenViewController.h"
#import <Parse/Parse.h>

@interface AanmeldenViewController () {
    CGFloat animatedDistance;
    BOOL higher;
}

@end

@implementation AanmeldenViewController
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
    self.wachtwoord.delegate = self;
    higher = false;
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
    if(textField.tag<=1 && !higher) {
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
    if(textField.tag == 0) {
        [[self.view viewWithTag:1] becomeFirstResponder];
    }
    else if (textField.tag == 1) {
        [PFUser logInWithUsernameInBackground:self.naam.text password:self.wachtwoord.text block:^(PFUser *user, NSError *error) {
            if(!error) {
                [self performSegueWithIdentifier:@"loginGeslaagd" sender:self];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foutje!" message:@"Aanmelden niet geslaagd." delegate:nil cancelButtonTitle:@"Probeer opnieuw" otherButtonTitles:nil];
                [alert show];
            }
        }];
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

- (IBAction)aanmelden:(id)sender {
    [PFUser logInWithUsernameInBackground:self.naam.text password:self.wachtwoord.text block:^(PFUser *user, NSError *error) {
        if(!error) {
            [self performSegueWithIdentifier:@"loginGeslaagd" sender:self];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Foutje!" message:@"Aanmelden niet geslaagd." delegate:nil cancelButtonTitle:@"Probeer opnieuw" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (IBAction)annuleren:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
