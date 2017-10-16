//
//  ConfessionsData.h
//  Test2
//
//  Created by Not For You to Use on 11/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfessionsData : NSObject
@property (strong, nonatomic, readonly) NSDictionary *data;
@property (strong, nonatomic, readonly) NSArray *bookTitles;
@property (strong, nonatomic, readonly) NSArray *chaptersOfConfessionArray;
@property (strong, nonatomic, readonly) NSArray *bookDescriptionArray;
@property (strong, nonatomic, readonly) NSOrderedSet *bookContentOrderedSet;
@property (strong, nonatomic, readonly) NSArray *arrayOfStringsForRange;
@property (strong, nonatomic, readonly) NSArray *chaptersLevel2Array;
@property (strong, nonatomic, readonly) NSArray *bookDescriptionArrayTwo;
@property (nonatomic, readonly) NSInteger bookKeyInt;
@property (nonatomic, readonly) NSInteger chapterKeyInt;
@property (nonatomic, readonly) NSInteger articleKeyInt;
@property (nonatomic, strong, readonly) NSString *titleAfterSwipe;


- (void)getBookTitlesForType:(NSString *)typeName;

- (void)getBookChaptersForConfession:(NSString *)confessionTitle;

- (void)getBookChaptersDescriptionForChapter:(NSString *)chapter forBookTitle:(NSString *)bookTitle;


- (void)getBookChaptersDescriptionForChapterLevelTwo:(NSString *)chapterLevelTwo withChapterLevelOne:(NSString *)chapterLevelOne forBookTitle:(NSString *)bookTitle;

- (BOOL)hasOnlyOneLevelforBookTitle:(NSString *)bookTitle;

- (void)getContentForBookTitle:(NSString *)bookTitle forChapter:(NSString *)chapter forArticle:(NSString *)article;


@end
