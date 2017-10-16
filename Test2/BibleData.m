//
//  BibleData.m
//  Test2
//
//  Created by Not For You to Use on 06/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "BibleData.h"
@interface BibleData()

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSSortDescriptor *sd;
@property (strong, nonatomic, readwrite) NSArray *bookIndexSortedArray;
@property (strong, nonatomic, readwrite) NSArray *bookTitles;
@property (strong, nonatomic, readwrite) NSString *bookShortTitle;
@property (strong, nonatomic, readwrite) NSString *bookFullTitle;
@property (nonatomic, readwrite) NSInteger countOfChapters;
@property (strong, nonatomic, readwrite) NSArray *versesForSuperScript;
@property (strong, nonatomic, readwrite) NSArray *bibleContent;



@end
@implementation BibleData

- (instancetype)init {
    return [super init];
}


- (NSDictionary *)data {
    if (!_data){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BibleJson" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *err = nil;
        
        _data = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    }
    return _data;
}

- (NSSortDescriptor *)sd
{
    return [[NSSortDescriptor alloc] initWithKey:nil ascending:YES comparator:^(NSString * string1, NSString * string2){
        return [string1 compare:string2
                        options:NSNumericSearch];
    }];
}

- (NSArray *)bookIndexSortedArray
{
    if(!_bookIndexSortedArray){
        if ([[self.data allKeys] lastObject] != nil){
            NSArray *bookTitlesArray = [[self.data valueForKey:@"version"] allKeys];
            bookTitlesArray = [bookTitlesArray sortedArrayUsingDescriptors:@[self.sd]];
            _bookIndexSortedArray = bookTitlesArray;
        }
    }
    return _bookIndexSortedArray;
}



- (NSArray *)bookTitles
{
    NSMutableArray *bookTitlesMArray = [[NSMutableArray alloc] init];
    
    for (NSString *bookIndex in self.bookIndexSortedArray) {
        NSString *bookName = [[[self.data valueForKey:@"version"] valueForKey:bookIndex]valueForKey:@"book_name"];
        
        if([bookName intValue]) {
            NSString *bookTitle = [bookName substringToIndex:5];
            [bookTitlesMArray addObject:bookTitle];
        } else {
            NSString *bookTitle = [bookName substringToIndex:3];
            [bookTitlesMArray addObject:bookTitle];
        }
    }
    return bookTitlesMArray;
}

- (void)getbookShortTitleForIndex:(NSInteger)index
{
    NSString *bookTitle = [[[self.data valueForKey:@"version"] valueForKey:[NSString stringWithFormat:@"%ld", (long)index]] valueForKey:@"book_name"];
    if([bookTitle intValue]) {
        self.bookShortTitle = [bookTitle substringToIndex:5];
    } else {
        self.bookShortTitle = [bookTitle substringToIndex:3];
    }
}

- (void)getbookFullTitleForIndex:(NSInteger)index
{
    NSString *bookTitle = [[[self.data valueForKey:@"version"] valueForKey:[NSString stringWithFormat:@"%ld", (long)index]] valueForKey:@"book_name"];
    
    self.bookFullTitle = bookTitle;
}

- (void)countChaptersForBook:(NSString *)book
{
    for (NSString *bookIndex in self.bookIndexSortedArray) {
        if([[[[self.data valueForKey:@"version"] valueForKey:bookIndex]valueForKey:@"book_name"] isEqualToString:book]){
            self.countOfChapters = [[self.data valueForKeyPath:[NSString stringWithFormat:@"version.%@.book", bookIndex]] allKeys].count;
        }
    }
}

- (void)countChaptersForBookIndex:(NSInteger)bookIndex {
    self.countOfChapters = [[self.data valueForKeyPath:[NSString stringWithFormat:@"version.%ld.book", (long)bookIndex]] allKeys].count;
    
}

- (void)getContentForBook:(NSString *)book forChapter:(NSString *)chapter
{
    NSMutableArray *verseNumbersMArray = [[NSMutableArray alloc] init];
    NSMutableArray *objectsForContentMArray = [[NSMutableArray alloc] init];
    for (NSString *bookIndex in self.bookIndexSortedArray) {
        if([[[[self.data valueForKey:@"version"] valueForKey:bookIndex]valueForKey:@"book_name"] isEqualToString:book]){
            for (NSString *chapterIndex in [self.data valueForKeyPath:[NSString stringWithFormat:@"version.%@.book", bookIndex]]){
                if ([chapterIndex isEqualToString:chapter]){
                    
                    NSArray *versesSortedArray = [[[self.data valueForKeyPath:[NSString stringWithFormat:@"version.%@.book.%@.chapter", bookIndex, chapterIndex]] allKeys] sortedArrayUsingDescriptors:@[self.sd]];
                    
                    for(NSString *verseIndex in versesSortedArray){
                        NSString *verseNumString = verseIndex;
                        NSString *contentString = [self.data valueForKeyPath:[NSString stringWithFormat:@"version.%@.book.%@.chapter.%@.verse", bookIndex, chapterIndex, verseIndex]];
                        
                        [objectsForContentMArray addObject:verseNumString];
                        [objectsForContentMArray addObject:@" "];
                        [objectsForContentMArray addObject:contentString];
                        [objectsForContentMArray addObject:@"\n\n"];
                        
                        [verseNumbersMArray addObject:verseNumString];
                    }
                }
            }
        }
    }
    self.versesForSuperScript = verseNumbersMArray;
    self.bibleContent = objectsForContentMArray;
}





@end
