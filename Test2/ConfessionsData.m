//
//  ConfessionsData.m
//  Test2
//
//  Created by Not For You to Use on 11/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "ConfessionsData.h"

@interface ConfessionsData ()
@property (strong, nonatomic, readwrite) NSDictionary *data;
@property (strong, nonatomic, readwrite) NSArray *bookTitles;
@property (strong, nonatomic, readwrite) NSArray *chaptersOfConfessionArray;
@property (strong, nonatomic, readwrite) NSArray *bookDescriptionArray;
@property (strong, nonatomic, readwrite) NSOrderedSet *bookContentOrderedSet;
@property (strong, nonatomic, readwrite) NSArray *arrayOfStringsForRange;
@property (strong, nonatomic, readwrite) NSArray *chaptersLevel2Array;
@property (strong, nonatomic, readwrite) NSArray *bookDescriptionArrayTwo;
@property (strong, nonatomic) NSArray *booksSortedArray;
@property (strong, nonatomic) NSSortDescriptor *sd;

@end

@implementation ConfessionsData


- (instancetype)init{
    return [super init];
}


- (NSDictionary *)data {
    if (!_data){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ConfessionsJson" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *err = nil;
        
        _data = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
    }
    
    return _data;
}

- (NSArray *)booksSortedArray {
    if(!_booksSortedArray){
        NSArray *bookIndexArray = [self.data allKeys];
        _booksSortedArray = [bookIndexArray sortedArrayUsingDescriptors:@[self.sd]];
    }
    return _booksSortedArray;
}


- (void)getBookTitlesForType:(NSString *)typeName {
    NSMutableArray *bookTitlesMArray = [[NSMutableArray alloc] init];
    
    for (NSString *bookIndex in self.booksSortedArray){
        if([[[self.data valueForKey:bookIndex]
             valueForKey:@"type"]
            isEqualToString:typeName]){
            [bookTitlesMArray addObject:[[self.data valueForKey:bookIndex]
                                         valueForKey:@"title"]];
            
        }
    }
    
    self.bookTitles = bookTitlesMArray;
}

- (NSSortDescriptor *)sd {
    return [[NSSortDescriptor alloc] initWithKey:nil ascending:YES comparator:^(NSString * string1, NSString * string2){
        return [string1 compare:string2
                        options:NSNumericSearch];
    }];
}



- (void)getBookChaptersForConfession:(NSString *)confessionTitle
{
    for (NSString *bookIndex in self.booksSortedArray){
        if([[[self.data valueForKey:bookIndex] valueForKey:@"title"] isEqualToString:confessionTitle]){
            NSArray *chapterTempKeys = [[[[self.data valueForKey:bookIndex] valueForKey:@"content"] allKeys] sortedArrayUsingDescriptors:@[self.sd]];
            
            if ([chapterTempKeys containsObject:@"introduction"]){
                NSMutableArray *chapterMKeys = [chapterTempKeys mutableCopy];
                [chapterMKeys removeObject:@"introduction"];
                [chapterMKeys insertObject:@"introduction" atIndex:0];
                NSArray *chapterKeys = chapterMKeys;
                
                [self runFastEnumerationForChapterKeys:chapterKeys withBookIndex:bookIndex];
                
            } else{
                
                NSArray *chapterKeys = chapterTempKeys;
                
                [self runFastEnumerationForChapterKeys:chapterKeys withBookIndex:bookIndex];
            }
            
            
        }}}


-(void)runFastEnumerationForChapterKeys:(NSArray *)chapterKeys withBookIndex:(NSString *)bookIndex
{
    NSMutableArray *chaptersOfConfessionMutableArray = [[NSMutableArray alloc] init];
    
    for (NSString *obj in chapterKeys){
        
        NSString *bookChapter = [[[[self.data valueForKey:bookIndex]
                                   valueForKey:@"content"]
                                  valueForKey:obj]
                                 valueForKey:@"chapter"];
        
        [chaptersOfConfessionMutableArray addObject:bookChapter];
        
    }
    
    NSOrderedSet *orderedChapterSet = [[NSOrderedSet alloc] initWithArray:chaptersOfConfessionMutableArray];
    self.chaptersOfConfessionArray = [orderedChapterSet array];
    
    
}

- (void)getBookChaptersDescriptionForChapter:(NSString *)chapter forBookTitle:(NSString *)bookTitle
{
    NSMutableArray *descMutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *headersMutableArray = [[NSMutableArray alloc] init];
    
    for (NSString *bookIndex in self.booksSortedArray) {
        if ([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.title", bookIndex]] isEqualToString:bookTitle]){
            
            
            NSArray *sortedBookIndexArray = [[[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content", bookIndex]] allKeys] sortedArrayUsingDescriptors:@[self.sd]];
            
            for (NSString *chapterIndex in sortedBookIndexArray) {
                
                if([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.chapter", bookIndex, chapterIndex]] isEqualToString:chapter]) {
                    
                    if([self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content", bookIndex, chapterIndex]] != nil) {
                        NSString *chapterCount = [NSString stringWithFormat:@"%lu Articles", (unsigned long)[[[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content", bookIndex, chapterIndex]] allKeys] count]];
                        
                        [descMutableArray addObject:chapterCount];
                        
                        NSArray *chaptersSortedArray = [[[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content", bookIndex, chapterIndex]] allKeys] sortedArrayUsingDescriptors:@[self.sd]];
                        
                        for (NSString *articleIndex in chaptersSortedArray){
                            [headersMutableArray addObject:[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content.%@.header", bookIndex, chapterIndex, articleIndex]]];
                            
                        }
                        
                    } else {
                        if ([bookTitle isEqualToString:@"\bThe Heidelberg Catechism"]) {
                            if ([chapter isEqualToString:@"Introduction to the H.C."]){
                                [descMutableArray addObject:[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.header", bookIndex, chapterIndex]]];
                                
                            } else {
                                NSString *chapterName = [NSString stringWithFormat:@"Q. %@", chapterIndex];
                                
                                [descMutableArray addObject:chapterName];
                            }
                        }
                    }
                }
            }
        }
    }
    self.bookDescriptionArray = descMutableArray;
    self.chaptersLevel2Array = headersMutableArray;
}


- (void)getBookChaptersDescriptionForChapterLevelTwo:(NSString *)chapterLevelTwo withChapterLevelOne:(NSString *)chapterLevelOne forBookTitle:(NSString *)bookTitle
{
    NSMutableSet *mSetForSubtitle = [[NSMutableSet alloc] init];
    
    for (NSString *bookIndex in self.booksSortedArray){
        if([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.title", bookIndex]] isEqualToString:bookTitle]){
            
            for(NSString *chapterIndex in [self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content", bookIndex]]){
                
                if([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.chapter", bookIndex, chapterIndex]] isEqualToString:chapterLevelOne]){
                    
                    for (NSString *articleIndex in [self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content", bookIndex, chapterIndex]]) {
                        
                        if([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content.%@.header", bookIndex, chapterIndex, articleIndex]] isEqualToString:chapterLevelTwo]){
                            
                            NSString *bodyString = [self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content.%@.body", bookIndex, chapterIndex, articleIndex]];
                            
                            //subtitle Level 2
                            [mSetForSubtitle addObject:bodyString];
                            
                        }
                    }
                }
            }
        }
    }
    self.bookDescriptionArrayTwo = [[mSetForSubtitle allObjects] sortedArrayUsingDescriptors:@[self.sd]];
}


- (void)getContentForBookTitle:(NSString *)bookTitle forChapter:(NSString *)chapter forArticle:(NSString *)article {
    //bookIndex, chapterIndex, articleIndex
    
    NSMutableOrderedSet *mutableOrderedContentSet = [[NSMutableOrderedSet alloc] init];
    NSMutableOrderedSet *mutableOrderedContentSetForRange = [[NSMutableOrderedSet alloc] init];
    
    NSString *title = [[NSString alloc] init];
    NSString *header = [[NSString alloc] init];
    NSString *body = [[NSString alloc] init];
    NSString *proofString = [[NSString alloc] init];
    
    
    for (NSString *bookIndex in self.booksSortedArray) {
        
        
        if ([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.title", bookIndex]] isEqualToString:bookTitle]) {
            
            
            if ([self hasOnlyOneLevelforBookTitle:bookTitle] == YES) {
                
                NSArray *sortedChapterArray = [[[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content", bookIndex]] allKeys] sortedArrayUsingDescriptors:@[self.sd]];
                
                for (NSString *chapterIndex in sortedChapterArray) {
                    
                    if ([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.chapter", bookIndex, chapterIndex]] isEqualToString:chapter]) {
                        
                        
                        title = bookTitle;
                        
                        header = [self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.header", bookIndex, chapterIndex]];
                        
                        body = [self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.body", bookIndex, chapterIndex]];
                        
                        [mutableOrderedContentSet addObject:title];
                        if (header.length != 0){
                            [mutableOrderedContentSet addObject:header];
                        }
                        [mutableOrderedContentSet addObject:body];
                        
                        [mutableOrderedContentSetForRange addObject:title];
                        if (header.length != 0){
                            [mutableOrderedContentSetForRange addObject:header];
                        }
                        
                        if ([self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.proof", bookIndex, chapterIndex]] != nil) {
                            proofString =[NSString stringWithFormat:@"Proof(s): %@", [self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.proof", bookIndex, chapterIndex]]];
                            
                            for (int i = 1; i <20; i++) {
                                
                                NSString *iString = [NSString stringWithFormat:@" %d. ", i];
                                NSString *replacementString = [NSString stringWithFormat:@"\n%d. ", i];
                                proofString = [proofString stringByReplacingOccurrencesOfString:iString withString:replacementString];
                                
                            }
                            [mutableOrderedContentSet addObject:proofString];
                        }
                    }
                }
            }
            else {
                
                NSArray *sortedChapterArray = [[[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content", bookIndex]] allKeys] sortedArrayUsingDescriptors:@[self.sd]];
                
                
                for (NSString *chapterIndex in sortedChapterArray) {
                    if ([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.chapter", bookIndex, chapterIndex]] isEqualToString:chapter]) {
                        
                        NSArray *sortedArticlesArray = [[[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content", bookIndex, chapterIndex]] allKeys] sortedArrayUsingDescriptors:@[self.sd]];
                        
                        
                        for (NSString *articleIndex in sortedArticlesArray) {
                            if ([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content.%@.header", bookIndex, chapterIndex, articleIndex]] isEqualToString:article]) {
                                
                                
                                if ([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.long title", bookIndex]] length]!= 0) {
                                    
                                    title = [self.data valueForKeyPath:[NSString stringWithFormat:@"%@.long title", bookIndex]];
                                    
                                } else {
                                    title = [self.data valueForKeyPath:[NSString stringWithFormat:@"%@.title", bookIndex]];
                                }
                                
                                if ([chapter isEqualToString:article]){
                                    header = [NSString stringWithFormat:@"%@", chapter];
                                    
                                } else {
                                    
                                    header = [NSString stringWithFormat:@"%@\n%@", chapter, article];
                                    
                                }
                                
                                if([[[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content.%@.body", bookIndex, chapterIndex, articleIndex]] substringToIndex:6] isEqualToString:@"Error:"]) {
                                    body = [@"The true doctrine concerning <i>Election</i> and <i>Reprobation</i> having been explained, the Synod <i>rejects</i> the errors of those:\n\n" stringByAppendingString:[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content.%@.body", bookIndex, chapterIndex, articleIndex]]];
                                } else {
                                    body = [self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content.%@.body", bookIndex, chapterIndex, articleIndex]];
                                }
                            }
                        }
                    }
                }
            }
            [mutableOrderedContentSet addObject:title];
            if (header.length != 0){
                [mutableOrderedContentSet addObject:header];
            }
            [mutableOrderedContentSet addObject:body];
            [mutableOrderedContentSet addObject:proofString];
            
            [mutableOrderedContentSetForRange addObject:title];
            if (header.length != 0){
                [mutableOrderedContentSetForRange addObject:header];
            }
        }
        [self getRangeForCreedsForFormatting:mutableOrderedContentSetForRange];
        self.bookContentOrderedSet = mutableOrderedContentSet;
        
        
        
    }
}

- (void)getRangeForCreedsForFormatting:(NSMutableOrderedSet *)orderedSet
{
    NSMutableArray *mutableArrayOfStringsForRange = [[NSMutableArray alloc] initWithArray:[orderedSet array]];
    
    self.arrayOfStringsForRange = mutableArrayOfStringsForRange;
    
}

- (BOOL)hasOnlyOneLevelforBookTitle:(NSString *)bookTitle {
    BOOL onlyOneLevel = YES;
    
    for (NSString *bookIndex in self.booksSortedArray) {
        
        if ([[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.title", bookIndex]] isEqualToString:bookTitle]){
            
            NSArray *sortedBookIndexArray = [[[self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content", bookIndex]] allKeys] sortedArrayUsingDescriptors:@[self.sd]];
            
            for (NSString *chapterIndex in sortedBookIndexArray) {
                
                if([self.data valueForKeyPath:[NSString stringWithFormat:@"%@.content.%@.content", bookIndex, chapterIndex]] != nil) {
                    onlyOneLevel = NO;
                }
            }
        }
    }
    return onlyOneLevel;
}


- (NSArray *)sortedArrayWithDictionary:(NSDictionary *)dictionary {
    
    return [[dictionary allKeys] sortedArrayUsingDescriptors:@[self.sd]];
}

- (NSString *)stringFromInteger:(NSInteger)integer {
    return [NSString stringWithFormat:@"%ld", (long)integer];
}


@end

