//
//  PsalterModel.h
//  Test2
//
//  Created by Not For You to Use on 21/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PsalterModel : NSObject
@property (strong, nonatomic, readonly) NSDictionary *psalterData;
@property (strong, nonatomic, readonly) NSString *psalterContent;
@property (strong, nonatomic, readonly) NSString *psalterTitle;
@property (nonatomic, readonly) BOOL shouldShowWarning;
@property (nonatomic, readonly) BOOL shouldShowWarningForScore;
@property (nonatomic, readonly) int psalterCount;
@property (nonatomic, readonly) NSInteger psalmRefInt;
@property (strong, nonatomic, readonly) NSString *psalterTitleName;
@property (strong, nonatomic, readonly) NSString *psalterPsalmNumberString;
@property (strong, nonatomic, readonly) NSString *psalterMeter;
@property (strong, nonatomic, readonly) NSString *psalterCrossRef;



- (void)getPsalterContentForPsalterNumberString:(NSString *)psalterNumberString;
- (void)getPsalterContentForSwipeLeft:(NSString *)psalterNumberString;
- (void)getPsalterContentForSwipeRight:(NSString *)psalterNumberString;
- (void)getPsalterContentForPsalmRefString:(NSString *)psalmRefString;
- (void)getPsalterContentWithScorePage:(NSInteger)page;
- (void) getPsalterCrossRefForPsalter:(NSString *)psalterTitle;
- (NSInteger)getScorePageForPsalter:(NSInteger)psalterNum;


@end
