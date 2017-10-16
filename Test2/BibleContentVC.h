//
//  BibleContentVC.h
//  Test2
//
//  Created by Not For You to Use on 11/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BibleChaptersCVVC.h"


@import CoreText;


@interface BibleContentVC : UIViewController <ReferenceDetailsDelegate>
@property (strong, nonatomic, readonly) NSString *currentBookAndChapter;

@end
