//
//  AanmeldenViewController.h
//  Vittles
//
//  Created by Anne Everars on 18/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AanmeldenViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *naam;
@property (strong, nonatomic) IBOutlet UITextField *wachtwoord;

- (IBAction)aanmelden:(id)sender;
- (IBAction)annuleren:(id)sender;

@end
