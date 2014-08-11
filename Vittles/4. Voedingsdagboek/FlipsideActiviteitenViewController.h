//
//  FlipsideActiviteitenViewController.h
//  Vittles
//
//  Created by Anne Everars on 28/05/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideActiviteitenViewController;

@protocol FlipsideActiviteitenViewControllerDelegate
- (void)flipsideViewControllerDidFinishAdding:(FlipsideActiviteitenViewController *) controller;
- (void)flipsideViewControllerDidFinishCancel:(FlipsideActiviteitenViewController *) controller;
@end

@interface FlipsideActiviteitenViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) id <FlipsideActiviteitenViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *naamText;
//Soorten
@property (strong, nonatomic) IBOutlet UILabel *typelabel;
@property (strong, nonatomic) IBOutlet UIPickerView *soortenPicker;

//Picker
@property (strong, nonatomic) IBOutlet UILabel *energieverbruiklabel;
@property (strong, nonatomic) IBOutlet UIPickerView *geheelgetal;
@property (strong, nonatomic) IBOutlet UIPickerView *kommagetal;
@property (nonatomic, retain) NSMutableArray *aantallen;


-(IBAction)done:(id)sender;

- (IBAction)cancel:(id)sender;

@end
