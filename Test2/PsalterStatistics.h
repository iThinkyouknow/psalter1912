//
//  PsalterStatistics.h
//  The Psalter
//
//  Created by Not For You to Use on 15/08/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PsalterStatistics : NSObject
@property (strong, nonatomic, readonly) NSArray *psalterStatsArray;

- (void)updateDictionaryFor:(NSString *)psalterTitle;
- (NSInteger)psalterSingCount:(NSString *)psalterTitle;
- (NSInteger)psalterCount;
- (void)getStatsForType:(NSString *)type ascending:(BOOL)ascending;
- (void)getStatsForPsalter:(NSString *)psalterTitle type:(NSString *)type ascending:(BOOL)ascending;

@end
