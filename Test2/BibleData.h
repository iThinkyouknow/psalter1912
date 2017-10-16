//
//  BibleData.h
//  Test2
//
//  Created by Not For You to Use on 06/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

@import UIKit;

@interface BibleData : NSObject
@property (strong, nonatomic, readonly) NSArray *bookTitles;
@property (strong, nonatomic, readonly) NSString *bookShortTitle;
@property (strong, nonatomic, readonly) NSString *bookFullTitle;
@property (nonatomic, readonly) NSInteger countOfChapters;
@property (strong, nonatomic, readonly) NSArray *versesForSuperScript;
@property (strong, nonatomic, readonly) NSArray *bibleContent;


- (void)getbookShortTitleForIndex:(NSInteger)index;
- (void)getbookFullTitleForIndex:(NSInteger)index;
- (void)countChaptersForBook:(NSString *)book;
- (void)getContentForBook:(NSString *)book forChapter:(NSString *)chapter;
- (void)countChaptersForBookIndex:(NSInteger)bookIndex;

@end
