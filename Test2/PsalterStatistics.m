//
//  PsalterStatistics.m
//  The Psalter
//
//  Created by Not For You to Use on 15/08/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "PsalterStatistics.h"

@interface PsalterStatistics()
@property (nonatomic, strong) NSString *dictionaryFileName;
@property (nonatomic, strong) NSString *dictionaryPathName;
@property (nonatomic, strong) NSDictionary *psalterStatisticsDictionary;
@property (strong, nonatomic) NSSortDescriptor *sd;
@property (strong, nonatomic) NSSortDescriptor *sdDescending;
@property (strong, nonatomic) NSArray *psalterStatsSortedArray;
@property (strong, nonatomic, readwrite) NSArray *psalterStatsArray;

@end

@implementation PsalterStatistics

#pragma mark init
- (instancetype)init{
    self = [super init];
    
    if (self && !_psalterStatisticsDictionary) {
        [self loadPsalterDictionaryFile];
    }
    return self;
}

#pragma mark PSALTERSTATISTICS DICTIONARY

- (NSDictionary *)psalterStatisticsDictionary {
    if (!_psalterStatisticsDictionary) {
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] init];
        
        for (NSInteger i = 1; i <= 434; i++) {
            [mutDict setObject:@[] forKey:[NSString stringWithFormat:@"Psalter %ld", (long)i]];
        }
        _psalterStatisticsDictionary = mutDict;
    }
    return _psalterStatisticsDictionary;
}

#pragma mark UPDATE METHODS

#pragma mark sd

- (NSSortDescriptor *)sd
{
    return [[NSSortDescriptor alloc] initWithKey:nil ascending:YES comparator:^(NSString * string1, NSString * string2){
        return [string1 compare:string2
                        options:NSNumericSearch];
    }];
}

- (NSSortDescriptor *)sdDescending
{
    return [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^(NSString * string1, NSString * string2){
        return [string1 compare:string2
                        options:NSNumericSearch];
    }];
}

#pragma mark sortedArray
- (NSArray *)psalterStatsSortedArray
{
    if(!_psalterStatsSortedArray){
        NSArray *psalterStatsIndexArray = [self.psalterStatisticsDictionary allKeys];
        
        _psalterStatsSortedArray = [psalterStatsIndexArray sortedArrayUsingDescriptors:@[self.sd]];
    }
    
    return _psalterStatsSortedArray;
}


#pragma mark save and load methods
- (NSString*)dictionaryFileName {
    return @"psalterstatistics.plist";
}


- (NSString *)documentsDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}


- (NSString *)fileInFileDirectories:(NSString *)fileName {
    NSLog(@"directory = %@", [[self documentsDirectory] stringByAppendingPathComponent:fileName]);
    
    return [[self documentsDirectory] stringByAppendingPathComponent:fileName];
}

- (NSString *)dictionaryPathName {
    return [self fileInFileDirectories:self.dictionaryFileName];
}


- (BOOL)saveDictionary:(NSDictionary *)dictionary {
    
    BOOL saveResults = [dictionary writeToFile:self.dictionaryPathName atomically:YES];
    return saveResults;
}

- (void)loadPsalterDictionaryFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:self.dictionaryPathName]){
        self.psalterStatisticsDictionary = [NSDictionary dictionaryWithContentsOfFile:self.dictionaryPathName];
    }
}



- (void)updateDictionaryFor:(NSString *)psalterTitle {
    NSMutableDictionary *mutDict = [self.psalterStatisticsDictionary mutableCopy];
    
    NSArray *array = [mutDict objectForKey:psalterTitle];
    NSMutableArray *mutArray = [array mutableCopy];
    
    [mutArray addObject:[NSDate date]];
    
    
    [mutDict setObject:mutArray forKey:psalterTitle];
    self.psalterStatisticsDictionary = mutDict;
    
    
    if ([self saveDictionary:self.psalterStatisticsDictionary]) {
        NSLog(@"saved successfully");
    } else {
        for (NSInteger i = 1; i < 100; i++) {
            if([self saveDictionary:self.psalterStatisticsDictionary]) {
                break;
            };
        }
        NSLog(@"unsuccessfully saved");
    }
    
}

#pragma mark STATISTICS

- (NSInteger)psalterCount {
    return [[self.psalterStatisticsDictionary allKeys] count];
}

- (NSInteger)psalterSingCount:(NSString *)psalterTitle {
    NSInteger count;
    
    if ([self.psalterStatisticsDictionary valueForKey:psalterTitle] != nil) {
        count = [[self.psalterStatisticsDictionary objectForKey:psalterTitle] count];
        
    } else {
        count = 0;
    }
    
    return count;
}


- (NSArray *)psalterSungInformation:(NSString *)psalterTitle{
    return [self.psalterStatisticsDictionary objectForKey:psalterTitle];
}

#pragma mark SORTING METHODS
// by psalter # and count

- (NSArray *)psalterStatsSortedByCount:(BOOL)ascending {
    NSArray *array = [[NSArray alloc] init];
    NSMutableOrderedSet *mutCountOrderedSet = [[NSMutableOrderedSet alloc] init];
    NSMutableOrderedSet *mutPsalterOrderedSet = [[NSMutableOrderedSet alloc] init];
    
    
    for (NSString *psalterStatsIndex in self.psalterStatsSortedArray){
        NSString *countString = [NSString stringWithFormat:@"%ld", (long)[[self.psalterStatisticsDictionary objectForKey:psalterStatsIndex] count]];
        
        [mutCountOrderedSet addObject:countString];
        
    }
    
    NSArray *countArray = [mutCountOrderedSet array];
    
    if (ascending) {
        
        countArray = [countArray sortedArrayUsingDescriptors:@[self.sd]];
        
    } else {
        
        countArray = [countArray sortedArrayUsingDescriptors:@[self.sdDescending]];
        
    }
    
    for (NSString *countString in countArray) {
        NSUInteger count = [countString integerValue];
        for (NSString *psalterStatsIndex in self.psalterStatsSortedArray){
            if ([[self.psalterStatisticsDictionary objectForKey:psalterStatsIndex] count] == count) {
                
                [mutPsalterOrderedSet addObject:psalterStatsIndex];
            }
        }
    }
    
    array = [mutPsalterOrderedSet array];
    return array;
}


- (NSArray *)psalterStatsSortedByNumber:(BOOL)ascending {
    NSArray *array;
    
    if(ascending) {
        
        array = [self psalterStatsSortedArray];
        
    } else {
        
        array = [[self.psalterStatisticsDictionary allKeys] sortedArrayUsingDescriptors:@[self.sdDescending]];
    }
    
    return array;
}

- (NSArray *)psalterStatsSortedForPsalter:(NSString *)psalterTitle byLastSung:(BOOL)ascending {
    NSArray *array;
    
    NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES];
  
    
    if(!ascending){
        
        sd = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
        
    }
    
    if ([[self psalterSungInformation:psalterTitle] count] > 0) {
        
        array = [[self psalterSungInformation:psalterTitle] sortedArrayUsingDescriptors:@[sd]];
    
    } else {
    
    
    array = @[@"You have neglected to sing me! 😭\nDo the right thing: Sing me now!"];
    }
    
    return array;
}

#pragma mark GET STATS METHODS

- (void)getStatsForType:(NSString *)type ascending:(BOOL)ascending {
    
    NSArray *array = [[NSArray alloc] init];
    
    if ([type isEqualToString:@"Ps #"]) {
        array = [self psalterStatsSortedByNumber:ascending];
        
        
    } else if ([type isEqualToString:@"Count"]) {
        array = [self psalterStatsSortedByCount:ascending];
    }
    
    
    self.psalterStatsArray = array;
}

- (void)getStatsForPsalter:(NSString *)psalterTitle type:(NSString *)type ascending:(BOOL)ascending {
    NSArray *array;
    
 

    if ([type isEqualToString:@"Last Sung"]) {
        array = [self psalterStatsSortedForPsalter:psalterTitle byLastSung:ascending];
    }
    
    self.psalterStatsArray = array;
}

@end



