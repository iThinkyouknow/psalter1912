//
//  AudioPlayer.h
//  Test2
//
//  Created by Not For You to Use on 26/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject
@property (nonatomic, strong, readonly) NSMutableString *timePlayed;
@property (nonatomic, strong, readonly) NSString *currentTime;
@property (nonatomic, readonly) float maxTime;
@property (nonatomic, readonly) float currentTimeFloat;
@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, strong, readonly) NSString *currentPsalterName;

- (void)play;

- (void)pause;

- (void)setTime:(float)timeValue;

- (void)loadMusic:(NSString *)fileName;

@end
