//
//  ScoreVC.h
//  The Psalter
//
//  Created by Not For You to Use on 28/09/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"

@interface ScoreVC : UIViewController <ScorePageProtocol>
@property (nonatomic, readonly) NSInteger scorePage;

@end
