//
//  AudioPlayer.m
//  Test2
//
//  Created by Not For You to Use on 26/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "AudioPlayer.h"

@interface AudioPlayer ()
@property (nonatomic, strong)AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong, readwrite) NSMutableString *timePlayed;
@property (nonatomic, strong, readwrite) NSString *currentTime;
@property (nonatomic, readwrite) float maxTime;
@property (nonatomic, readwrite) float currentTimeFloat;
@property (nonatomic, readwrite) BOOL isPlaying;
@property (nonatomic, strong, readwrite) NSString *currentPsalterName;


@end
@implementation AudioPlayer

- (instancetype)init {
    self = [super init];
    if(self){
    }
    return self;
    
    
}

- (BOOL) isPlaying{
    return self.player.isPlaying;
}


- (float)maxTime{
    return self.player.duration;
}

- (float)currentTimeFloat{
    return self.player.currentTime;
}


- (NSString *)currentTime{
    int totalSeconds = (int)(self.player.currentTime);
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    
    
}

- (void)loadMusic:(NSString *)fileName
{
    if(!_player){
        NSString *soundFilePath =
        [[NSBundle mainBundle] pathForResource:fileName
                                        ofType:@"m4a"];
        
        if(soundFilePath != nil){
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
            
            _player = [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                                             error:nil];
            
        } else {
            
            soundFilePath = [[NSBundle mainBundle] pathForResource:fileName
                                                            ofType:@"mp3"];
            if(soundFilePath != nil){
                
                NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
                
                _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL
                                                                 error:nil];
                
            }
        }
        self.currentPsalterName = fileName;
    }
    
}



- (void)play{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    
    [self.player play];
}

- (void)setTime:(float)timeValue{
    self.player.currentTime = timeValue;
}



- (void)pause{
    [self.player pause];
}


@end
