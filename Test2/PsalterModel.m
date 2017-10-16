//
//  PsalterModel.m
//  Test2
//
//  Created by Not For You to Use on 21/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "PsalterModel.h"

@interface PsalterModel()

@property (strong, nonatomic, readwrite) NSDictionary *psalterData;

@property (strong, nonatomic) NSArray *psalterSortedArray;
@property (strong, nonatomic) NSSortDescriptor *sd;
@property (strong, nonatomic, readwrite) NSString *psalterContent;
@property (strong, nonatomic, readwrite) NSString *psalterTitle;
@property (nonatomic, readwrite) BOOL shouldShowWarning;
@property (nonatomic, readwrite) BOOL shouldShowWarningForScore;
@property (nonatomic, readwrite) int psalterCount;
@property (nonatomic, readwrite) NSInteger psalmRefInt;
@property (strong, nonatomic, readwrite) NSString *psalterTitleName;
@property (strong, nonatomic, readwrite) NSString *psalterPsalmNumberString;
@property (strong, nonatomic, readwrite) NSString *psalterMeter;
@property (strong, nonatomic, readwrite) NSString *psalterCrossRef;

@end

@implementation PsalterModel

- (instancetype)init{
    self = [super init];
    return self;
}

- (NSDictionary *)psalterData {
    if(!_psalterData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PsalterJson1" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSError *err = nil;
        _psalterData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    }
    return _psalterData;
}


- (NSSortDescriptor *)sd {
    return [[NSSortDescriptor alloc] initWithKey:nil ascending:YES comparator:^(NSString * string1, NSString * string2){
        return [string1 compare:string2
                        options:NSNumericSearch];
    }];
}


- (NSArray *)psalterSortedArray {
    if(!_psalterSortedArray){
        NSArray *psalterIndexArray = [self.psalterData allKeys];
        
        _psalterSortedArray = [psalterIndexArray sortedArrayUsingDescriptors:@[self.sd]];
    }
    return _psalterSortedArray;
}


- (void)getPsalterContentForPsalterNumberString:(NSString *)psalterNumberString {
    if ([psalterNumberString intValue] !=0 && [psalterNumberString intValue] <= self.psalterSortedArray.count) {
        
        [self getPsalterDetailsForDisplayWithPsalterKeyString:psalterNumberString];
        
        self.shouldShowWarning = NO;
        
        
    } else {
        self.shouldShowWarning = YES;
       
    }
    
    
    
}

- (void)getPsalterContentForSwipeLeft:(NSString *)psalterNumberString {
    int psalterIntValue = [psalterNumberString intValue];
    if(psalterIntValue > self.psalterCount) {
        psalterIntValue = 0;
        psalterIntValue++;
        NSString *psalterNumberNewString = [NSString stringWithFormat:@"%d",psalterIntValue];
        
        [self getPsalterDetailsForDisplayWithPsalterKeyString:psalterNumberNewString];
        
        
    }
    
    else if (psalterIntValue < self.psalterCount){
        psalterIntValue++;
        NSString *psalterNumberNewString = [NSString stringWithFormat:@"%d",psalterIntValue];
        
        [self getPsalterDetailsForDisplayWithPsalterKeyString:psalterNumberNewString];
        
    }
}

- (void)getPsalterContentForSwipeRight:(NSString *)psalterNumberString {
    int psalterIntValue = [psalterNumberString intValue];
    if (psalterIntValue > 1 && psalterIntValue <= self.psalterCount){
        psalterIntValue--;
        NSString *psalterNumberNewString = [NSString stringWithFormat:@"%d",psalterIntValue];
        
        [self getPsalterDetailsForDisplayWithPsalterKeyString:psalterNumberNewString];
    }
}

- (void)getPsalterContentForPsalmRefString:(NSString *)psalmRefString {
    
    for(NSString *bookIndex in self.psalterSortedArray){
        
        if([[self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.psalm", bookIndex]] isEqualToString:[NSString stringWithFormat:@"Psalm %@", psalmRefString]]){
            
            [self getPsalterDetailsForDisplayWithPsalterKeyString:bookIndex];
            
            break;
        }
    }
}

- (void)getPsalterDetailsForDisplayWithPsalterKeyString:(NSString *)keyString {
    
    
    //titlename, psalm, meter
    self.psalterTitle = [NSString stringWithFormat:@"Psalter %@", keyString];
    
    self.psalterTitleName = [self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.title name", keyString]];
    
    self.psalterPsalmNumberString = [self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.psalm", keyString]];
    
    self.psalterMeter = [NSString stringWithFormat:@"Meter: %@",[self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.meter", keyString]]];
    
    self.psalterContent = [self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.content", keyString]];
    
    self.psalmRefInt = [[self.psalterPsalmNumberString stringByReplacingOccurrencesOfString:@"Psalm " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [self.psalterPsalmNumberString length])] integerValue];
    
}



- (int)psalterCount {
    if(!_psalterCount){
        _psalterCount = self.psalterSortedArray.count;
    }
    return _psalterCount;
}

- (void) getPsalterCrossRefForPsalter:(NSString *)psalterTitle {
    for (NSString *bookIndex in self.psalterSortedArray){
        if ([[self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.title", bookIndex]] isEqualToString:psalterTitle]) {
            
            
            NSString *rawString = [self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.ref", bookIndex]];
            
            if (rawString.length == 0){
                NSString *psalm = [self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.psalm", bookIndex]];
                for (NSString *bookIndex in self.psalterSortedArray){
                    
                    if (([[self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.psalm", bookIndex]] isEqualToString:psalm]) && ([[self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.ref", bookIndex]] length] != 0)) {
                        rawString = [self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.ref", bookIndex]];
                        
                    }
                }
                
            }
            
            [self formatRawString:rawString];
            
        }
    }
    
}

- (void)formatRawString:(NSString *)rawString {
    for (int i = 1; i <= 268; i++) {
        
        rawString = [rawString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d  ", i] withString:[NSString stringWithFormat:@"%d. Psalm ", i]];
    }
    
    self.psalterCrossRef = rawString;
    
}

- (NSInteger)getScorePageForPsalter:(NSInteger)psalterNum {
    NSInteger scorePageInt;
    
    
    if ((psalterNum > 0) && (psalterNum <= self.psalterCount)) {
        self.shouldShowWarning = NO;
        
        NSString *psalterNumString = [NSString stringWithFormat:@"%ld", (long)psalterNum];
        
        NSString *scoreRef = [self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.scoreRef", psalterNumString]];
        
        scorePageInt = [scoreRef integerValue];
        
    } else {
        self.shouldShowWarning = YES;
    }
    
    if (psalterNum == 167 || psalterNum == 168 || psalterNum == 169 || (psalterNum > 413 && psalterNum <= 434) ) {
        self.shouldShowWarningForScore = YES;
    } else {
        self.shouldShowWarningForScore = NO;
    }
    
    
    return scorePageInt;
}


- (void)getPsalterContentWithScorePage:(NSInteger)page {
    
    
   // NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    
    NSSortDescriptor *sdDesc = [[NSSortDescriptor alloc] initWithKey:nil
                                                           ascending:NO
                                                          comparator:^(NSString * string1, NSString * string2) {
                                                              
                                                              return [string1 compare:string2
                                                                              options:NSNumericSearch];
                                                              
                                                          }];
    
    NSArray *psalterSortedArrayDesc = [[self.psalterData allKeys] sortedArrayUsingDescriptors:@[sdDesc]];

   
    
    
    for (NSString *bookIndex in psalterSortedArrayDesc) {
        if ([[self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.scoreRef", bookIndex]] integerValue] == page) {
           
            for (NSInteger b = 1; b <= [bookIndex integerValue]; b++) {
                
                
                NSString *newBIndex = [NSString stringWithFormat:@"%ld", (long)b];
                
                if ([[self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.scoreRef", newBIndex]] integerValue] == page) {
                    
                   
            
                    [self getPsalterDetailsForDisplayWithPsalterKeyString:newBIndex];
                    return;
                }
            }
        } else {
            for (NSInteger i = page - 1 ; i > 0 ; i--) {
                if ([[self.psalterData valueForKeyPath:[NSString stringWithFormat:@"%@.scoreRef", bookIndex]] integerValue] == i) {
                    
                    
                    [self getPsalterDetailsForDisplayWithPsalterKeyString:bookIndex];
                    return;
                }
            }
        }
    }
    
}







@end
