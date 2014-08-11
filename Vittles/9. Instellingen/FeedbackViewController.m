//
//  FeedbackViewController.m
//  Vittles
//
//  Created by Anne Everars on 7/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "FeedbackViewController.h"
#import <Parse/Parse.h>

@interface FeedbackViewController () {
    NSArray *vragen;
    int index;
    NSMutableArray *scores;
}

@end

@implementation FeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    index=0;
    scores = [[NSMutableArray alloc]init];
    self.next = [[UIBarButtonItem alloc] initWithTitle:@"Volgende" style:UIBarButtonItemStylePlain target:self action:@selector(volgende:)];
    self.navigationItem.rightBarButtonItem = self.next;
    self.question0.text = @"1. Ik denk dat ik dit systeem regelmatig zou gebruiken.";
    self.question1.text = @"2. Ik vond het systeem onnodig complex.";
    self.question2.text = @"3. Ik vond het systeem makkelijk te gebruiken.";
    [self.slider0 setMinimumTrackTintColor:[UIColor greenColor]];
    [self.slider1 setMinimumTrackTintColor:[UIColor greenColor]];
    [self.slider2 setMinimumTrackTintColor:[UIColor greenColor]];
    [self.slider0 addTarget:self action:@selector(slider0ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider1 addTarget:self action:@selector(slider1ValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider2 addTarget:self action:@selector(slider2ValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.score0.text = @"3/5";
    self.score1.text = @"3/5";
    self.score2.text = @"3/5";
    [self.slider0 setValue: 3.0f];
    [self.slider1 setValue: 3.0f];
    [self.slider2 setValue: 3.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)volgende:(UIBarButtonItem *)sender {
    if(index==0) {
        int eerste = (int)self.slider0.value;
        int tweede = (int)self.slider1.value;
        int derde = (int)self.slider2.value;
        [scores addObject:[NSNumber numberWithInt:eerste]];
        [scores addObject:[NSNumber numberWithInt:tweede]];
        [scores addObject:[NSNumber numberWithInt:derde]];
        self.question0.text = @"4. Ik denk dat ik ondersteuning nodig heb van een technisch persoon om dit systeem te kunnen gebruiken.";
        self.question1.text = @"5. Ik vond dat de verschillende functies in dit systeem erg goed geïntegreerd zijn.";
        self.question2.text = @"6. Ik vond dat er teveel tegenstrijdigheden in het systeem zaten.";
        self.score0.text = @"3/5";
        self.score1.text = @"3/5";
        self.score2.text = @"3/5";
        [self.slider0 setValue: 3.0f];
        [self.slider1 setValue: 3.0f];
        [self.slider2 setValue: 3.0f];
        index ++;
    }
    else if(index==1) {
        int eerste = (int)self.slider0.value;
        int tweede = (int)self.slider1.value;
        int derde = (int)self.slider2.value;
        [scores addObject:[NSNumber numberWithInt:eerste]];
        [scores addObject:[NSNumber numberWithInt:tweede]];
        [scores addObject:[NSNumber numberWithInt:derde]];
        self.question0.text = @"7. Ik kan me voorstellen dat de meeste mensen zeer snel leren om dit systeem te gebruiken.";
        self.question1.text = @"8. Ik vond het systeem erg omslachtig in gebruik.";
        self.question2.text = @"9. Ik voelde me erg vertrouwd met het systeem.";
        self.score0.text = @"3/5";
        self.score1.text = @"3/5";
        self.score2.text = @"3/5";
        [self.slider0 setValue: 3.0f];
        [self.slider1 setValue: 3.0f];
        [self.slider2 setValue: 3.0f];
        index ++;
    }
    else if(index==2) {
        int eerste = (int)self.slider0.value;
        int tweede = (int)self.slider1.value;
        int derde = (int)self.slider2.value;
        [scores addObject:[NSNumber numberWithInt:eerste]];
        [scores addObject:[NSNumber numberWithInt:tweede]];
        [scores addObject:[NSNumber numberWithInt:derde]];
        self.question0.text = @"10. Ik moest erg veel leren voordat ik aan de gang kon gaan met dit systeem.";
        [self.question1 setHidden:TRUE];
        [self.question2 setHidden:TRUE];
        self.score0.text = @"3/5";
        [self.score1 setHidden:TRUE];
        [self.score2 setHidden:TRUE];
        [self.slider0 setValue: 3.0f];
        [self.slider1 setHidden:TRUE];
        [self.slider2 setHidden:TRUE];
        [self.label1 setHidden:TRUE];
        [self.label2 setHidden:TRUE];
        [self.label3 setHidden:TRUE];
        [self.label4 setHidden:TRUE];
        [self.label5 setHidden:TRUE];
        [self.label6 setHidden:TRUE];
        [self.label7 setHidden:TRUE];
        [self.label8 setHidden:TRUE];
        self.next = [[UIBarButtonItem alloc] initWithTitle:@"Opslaan" style:UIBarButtonItemStylePlain target:self action:@selector(opslaan:)];
        self.navigationItem.rightBarButtonItem = self.next;
    }
}
- (IBAction)opslaan:(UIBarButtonItem *)sender {
    int eerste = (int)self.slider0.value;
    [scores addObject:[NSNumber numberWithInt:eerste]];
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
    PFObject *update = [PFObject objectWithClassName:@"SUS"];
    update[@"login"] = login;
    update[@"scores"] = scores;
    [update saveInBackground];
}

- (IBAction)slider0ValueChanged:(id)sender{
    self.score0.text = [NSString stringWithFormat:@"%d/%d",(int)self.slider0.value,5];
    [self.slider0 setValue:(int)self.slider0.value];
}

- (IBAction)slider1ValueChanged:(id)sender{
    self.score1.text = [NSString stringWithFormat:@"%d/%d",(int)self.slider1.value,5];
    [self.slider1 setValue:(int)self.slider1.value];
}

- (IBAction)slider2ValueChanged:(id)sender{
    self.score2.text = [NSString stringWithFormat:@"%d/%d",(int)self.slider2.value,5];
    [self.slider2 setValue:(int)self.slider2.value];
}

@end
