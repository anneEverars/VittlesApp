//
//  CPDStockPriceStore.m
//  CorePlotDemo
//  Created by Steve Baranski on 5/4/12.
//  Copyright (c) 2012 komorka technology, llc. All rights reserved.
//

#import "CPDStockPriceStore.h"
#import <Parse/Parse.h>

@interface CPDStockPriceStore ()


@end

@implementation CPDStockPriceStore

#pragma mark - Class methods

+ (CPDStockPriceStore *)sharedInstance
{
    static CPDStockPriceStore *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - API methods

- (NSArray *)tickerSymbols
{
    static NSArray *symbols = nil;
    if (!symbols)
    {
        symbols = [NSArray arrayWithObjects:
                   @"GEWICHT",
                   @"STREEFGEWICHT",
                   nil];
    }
    return symbols;
}

- (NSArray *)dailyPortfolioPrices
{
    static NSArray *prices = nil;
    if (!prices)
    {
        prices = [NSArray arrayWithObjects:
                  [NSDecimalNumber numberWithFloat:582.13],
                  [NSDecimalNumber numberWithFloat:604.43],
                  [NSDecimalNumber numberWithFloat:32.01],
                  nil];
    }
    return prices;
}

- (NSArray *)datesInWeek
{
    static NSArray *dates = nil;
    if (!dates)
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        long day = [components day];
        long month = [components month];
        dates = [NSArray arrayWithObjects:
                 [[[NSString stringWithFormat:@"%ld", (day-6)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-5)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-4)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-3)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-2)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-1)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", day] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 nil];
    }
    return dates;
}

- (NSArray *)datesInMonth
{
    static NSArray *dates = nil;
    if (!dates)
    {
        //TODO : fixen met maanden
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        long day = [components day];
        long month = [components month];
        dates = [NSArray arrayWithObjects:
                 @"29/3",
                 @"30/3",
                 @"31/3",
                 [[[NSString stringWithFormat:@"%ld", (day-26)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-25)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-24)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-23)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-22)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-21)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-20)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-19)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-18)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-17)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-16)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-15)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-14)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-13)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-12)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-11)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-10)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-9)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-8)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-7)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-6)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-5)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-4)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-3)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-2)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", (day-1)] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 [[[NSString stringWithFormat:@"%ld", day] stringByAppendingString:@"/"] stringByAppendingString:[NSString stringWithFormat:@"%ld", month]],
                 nil];
    }
    return dates;
}

- (NSArray *)monthlyPrices:(NSString *)tickerSymbol
{
    if ([[tickerSymbol uppercaseString]rangeOfString:@"STREEF"].location == NSNotFound)
    {
        return [self monthlyGewicht];
    }
    else
    {
        return [self monthlyStreefgewicht];
    }
}

#pragma mark - Private behavior

- (NSArray *)monthlyGewicht
{
    static NSArray *prices = nil;
    if (!prices)
    {
        //TODO: moet evenveel waarden hebben als het aantal dagen in de maand!
        prices = [NSArray arrayWithObjects:
                  [NSDecimalNumber numberWithFloat:71.70],
                  [NSDecimalNumber numberWithFloat:71.50],
                  [NSDecimalNumber numberWithFloat:71.00],
                  [NSDecimalNumber numberWithFloat:71.20],
                  [NSDecimalNumber numberWithFloat:70.50],
                  [NSDecimalNumber numberWithFloat:70.00],
                  [NSDecimalNumber numberWithFloat:69.80],
                  [NSDecimalNumber numberWithFloat:69.50],
                  [NSDecimalNumber numberWithFloat:70.00],
                  [NSDecimalNumber numberWithFloat:69.80],
                  [NSDecimalNumber numberWithFloat:69.40],
                  [NSDecimalNumber numberWithFloat:69.50],
                  [NSDecimalNumber numberWithFloat:69.00],
                  [NSDecimalNumber numberWithFloat:68.70],
                  [NSDecimalNumber numberWithFloat:68.50],
                  [NSDecimalNumber numberWithFloat:68.40],
                  [NSDecimalNumber numberWithFloat:68.60],
                  [NSDecimalNumber numberWithFloat:68.50],
                  [NSDecimalNumber numberWithFloat:68.20],
                  [NSDecimalNumber numberWithFloat:68.00],
                  nil];
    }
    return prices;
}

- (NSArray *)monthlyStreefgewicht
//monthlyGoogPrices
{
    static NSArray *prices = nil;
    if (!prices)
    {
        prices = [NSArray arrayWithObjects:
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  [NSDecimalNumber numberWithFloat:65.0],
                  nil];
    }
    return prices;
}

@end
