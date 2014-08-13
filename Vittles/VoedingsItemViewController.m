//
//  VoedingsItemViewController.m
//  Vittles
//
//  Created by Anne Everars on 2/08/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "VoedingsItemViewController.h"
#import <Parse/Parse.h>

@interface VoedingsItemViewController () {
    NSString *login;
}

@end

@implementation VoedingsItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //****GEBRUIKER****
    PFUser *user = [PFUser currentUser];
    NSString *naam = user.username;
    NSString *email = [[user.email stringByReplacingOccurrencesOfString:@"@" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
    login = [naam stringByAppendingString:email];
    login = [login stringByReplacingOccurrencesOfString: @" " withString:@"_"];
}

-(void)viewWillAppear:(BOOL)animated {
    //****HOEVEELHEID****
    float hoeveelheid = [[self.hoeveelheid.text stringByReplacingOccurrencesOfString:@" g" withString:@""] floatValue];
    //****TYPEVIEW****
    NSString *adh;
    UIColor *tintColor;
    if([self.self.soort isEqualToString:@"Vleesproducten"]) {
        self.ItemImage.image = [UIImage imageNamed:@"meat.png"];
        adh = @"vlees";
        tintColor = [UIColor colorWithRed:153.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0f];
    }
    else if([self.soort isEqualToString:@"Fruit"]) {
        self.ItemImage.image = [UIImage imageNamed:@"Fruit2.png"];
        adh = @"fruit";
        tintColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:102.0/255.0 alpha:1.0f];
    }
    else if([self.soort isEqualToString:@"Vis en schaaldieren"]) {
        self.ItemImage.image = [UIImage imageNamed:@"meat.png"];
        adh = @"vlees";
        tintColor = [UIColor colorWithRed:153.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0f];
    }
    else if([self.soort isEqualToString:@"Zuivelproducten"]) {
        self.ItemImage.image = [UIImage imageNamed:@"Milk.png"];
        adh = @"melk";
        tintColor = [UIColor colorWithRed:102.0/255.0 green:205.0/255.0 blue:255.0/255.0 alpha:1.0f];
    }
    else if([self.soort isEqualToString:@"Oliën en vetten"]) {
        self.ItemImage.image = [UIImage imageNamed:@"Oil.png"];
        adh = @"vetten";
        tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0f];
    }
    else if([self.soort isEqualToString:@"Suikerproducten"]) {
        self.ItemImage.image = [UIImage imageNamed:@"Sugar.png"];
        adh = @"suiker";
        tintColor = [UIColor colorWithRed:255.0/255.0 green:102.0/255.0 blue:153.0/255.0 alpha:1.0f];
    }
    else if([self.soort isEqualToString:@"Graanproducten"]) {
        self.ItemImage.image = [UIImage imageNamed:@"Wheat2.png"];
        adh = @"granen";
        tintColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    }
    else if([self.soort isEqualToString:@"Groenten"]) {
        self.ItemImage.image = [UIImage imageNamed:@"Fruit2.png"];
        adh = @"fruit";
        tintColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:102.0/255.0 alpha:1.0f];
    }
    else if([self.soort isEqualToString:@"Dranken"]) {
        self.ItemImage.image = [UIImage imageNamed:@"Water2.png"];
        adh = @"water";
        tintColor = [UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:205.0/255.0 alpha:1.0f];
    }
    else {
        self.ItemImage.image = [UIImage imageNamed:@"Rest.png"];
        adh = @"rest";
        tintColor = [UIColor colorWithRed:153.0/255.0 green:102.0/255.0 blue:204.0/255.0 alpha:1.0f];
    }
    PFQuery *queryADH = [PFQuery queryWithClassName:login];
    [queryADH whereKey:@"type" equalTo:@"ADH"];
    NSArray *resultsADH = [queryADH findObjects];
    for(PFObject *result in resultsADH) {
        float aanbevolen = [[result objectForKey:adh] floatValue];
        float waarde = (hoeveelheid/aanbevolen)*100;
        NSString *gebruikt = [[NSString stringWithFormat:@"%.2f", waarde]stringByReplacingOccurrencesOfString:@"." withString:@","];
        if(waarde > 100) {
            gebruikt = @"100,00";
            waarde = 100.0f;
        }
        [[UISlider appearance] setMinimumTrackTintColor:tintColor];
        [self.progressViewtje setTintColor:tintColor];
        self.progressViewtje.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.progressViewtje.startAngle = (3.0*M_PI)/2.0;
        self.progressViewtje.progress = waarde/100.0f;
        self.label.text = [gebruikt stringByAppendingString:@"%"];
        //****ENERGIEWAARDE****
        if([self.soort length] != 0) {
            PFQuery *query = [PFQuery queryWithClassName:[[self.soort stringByReplacingOccurrencesOfString: @" " withString:@"_"]stringByReplacingOccurrencesOfString:@"ë" withString:@"_"]];
            [query whereKey:@"Naam" equalTo:self.naam];
            if(self.type) {
                [query whereKey:@"Soort" equalTo:self.type];
            }
            NSArray *results = [query findObjects];
            PFObject *eerste = [results objectAtIndex:0];
            float calorien = [[eerste objectForKey:@"energie"] floatValue]/100*hoeveelheid;
            float eiwitten = [[eerste objectForKey:@"eiwitten"] floatValue]/100*hoeveelheid;
            float koolhydraten = [[eerste objectForKey:@"koolhydraten"] floatValue]/100*hoeveelheid;
            float vetten = [[eerste objectForKey:@"vetten"] floatValue]/100*hoeveelheid;
            self.energie.text = [[[NSString stringWithFormat:@"%.2f", calorien]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByReplacingOccurrencesOfString:@"." withString:@","];
            self.eiwitten.text = [[[[NSString stringWithFormat:@"%.2f", eiwitten]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByReplacingOccurrencesOfString:@"." withString:@","] stringByAppendingString:@" g"];
            self.vetten.text = [[[[NSString stringWithFormat:@"%.2f", vetten]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByReplacingOccurrencesOfString:@"." withString:@","]stringByAppendingString:@" g"];
            self.koolhydraten.text = [[[[NSString stringWithFormat:@"%.2f", koolhydraten]stringByReplacingOccurrencesOfString:@"." withString:@","] stringByReplacingOccurrencesOfString:@"." withString:@","]stringByAppendingString:@" g"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
