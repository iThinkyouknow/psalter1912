//
//  Settings.m
//  The Psalter
//
//  Created by Not For You to Use on 19/08/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "Settings.h"

@implementation Settings

- (instancetype)init {
        return [super init];
    }

+ (float)defaultFontSize {
    float fontSize = 18.0;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        fontSize = 20.0;
    } 
    
    return fontSize;
}

@end
