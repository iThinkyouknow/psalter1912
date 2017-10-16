//
//  TabBarController.h
//  Test2
//
//  Created by Not For You to Use on 22/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BibleChaptersCVVC.h"
#import "Protocols.h"



@interface TabBarController : UITabBarController
@property (nonatomic, weak) id <ReferenceDetailsDelegate> tbDelegate;
@property (nonatomic, weak) id <PsalterNumberDetails> pnDelegate;
@property (nonatomic, weak) id <ScorePageProtocol> spDelegate;

@end
