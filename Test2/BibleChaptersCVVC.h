//
//  BibleChaptersCV.h
//  Test2
//
//  Created by Not For You to Use on 11/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"


@interface BibleChaptersCVVC : UICollectionViewController
@property (nonatomic, weak) id <ReferenceDetailsDelegate> delegate;
@property (nonatomic) NSInteger chapterIndex;

@end

