//
//  searchModel.m
//  Test2
//
//  Created by Not For You to Use on 25/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "searchModel.h"
#import "PsalterModel.h"

@interface SearchModel ()
@property (nonatomic, strong) PsalterModel *psalterModel;
@property (strong, nonatomic) NSArray *psalterSortedArray;
@property (strong, nonatomic) NSSortDescriptor *sd;
@property (nonatomic, strong, readwrite) NSArray *psalterSearchResults;
@property (nonatomic, strong, readwrite) NSArray *psalterSearchTitleResults;


@end

@implementation SearchModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.psalterModel = [[PsalterModel alloc] init];
        
    }
    return self;
    
}

- (NSSortDescriptor *)sd {
    return [[NSSortDescriptor alloc] initWithKey:nil ascending:YES comparator:^(NSString * string1, NSString * string2){
        return [string1 compare:string2
                        options:NSNumericSearch];
    }];
}


- (NSArray *)psalterSortedArray {
    if(!_psalterSortedArray){
        NSArray *psalterIndexArray = [self.psalterModel.psalterData allKeys];
        
        _psalterSortedArray = [psalterIndexArray sortedArrayUsingDescriptors:@[self.sd]];
    }
    return _psalterSortedArray;
}



- (void)searchWithSearchString:(NSString *)searchString
{
    
    NSMutableArray *psalterSearchMArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *psalterSearchTitleMArray = [[NSMutableArray alloc]init];
    
    for (NSString *psalterIndex in self.psalterSortedArray){
        for (NSString *item in [self.psalterModel.psalterData valueForKey:psalterIndex]){
            
            if ([[[self.psalterModel.psalterData valueForKey:psalterIndex] valueForKey:item] respondsToSelector:@selector(stringByReplacingOccurrencesOfString:withString:)]) {
                //NEED TO WORK ON!
                NSString *stringForSearch = [[[self.psalterModel.psalterData valueForKey:psalterIndex] valueForKey:item] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                
                NSUInteger count = 0, length = [stringForSearch length];
                NSRange range = NSMakeRange(0, length);
                
                while(range.location != NSNotFound)
                {
                    range = [stringForSearch rangeOfString:searchString options:NSCaseInsensitiveSearch range:range];
                    
                    if(range.location != NSNotFound) {
                        
                        [self formatSearchResultsString:stringForSearch forRange:range forPsalterResultsMArray:psalterSearchMArray];
                        
                        NSString *psalterFound = [[self.psalterModel.psalterData valueForKey:psalterIndex]valueForKey:@"title"];
                        
                        [psalterSearchTitleMArray addObject:psalterFound];
                        
                        range = NSMakeRange(range.location + range.length,
                                            length - (range.location + range.length));
                        
                        count++;
                    }
                }
                
            }
        }
    }
    
    self.psalterSearchResults = psalterSearchMArray;
    self.psalterSearchTitleResults = psalterSearchTitleMArray;
    
}

- (void)formatSearchResultsString:(NSString *)searchResult forRange:(NSRange)range forPsalterResultsMArray:(NSMutableArray *)psalterSearchMArray{
    
    
    if (range.location <= 10) {
        if(searchResult.length >=100){
            NSString *searchResultString = [NSString stringWithFormat:@"...%@...",[[searchResult substringFromIndex:0] substringToIndex:100]];
            
            [psalterSearchMArray addObjectsFromArray:@[searchResultString]];
            
        } else {
            NSString *searchResultString = [NSString stringWithFormat:@"...%@",[searchResult substringFromIndex:0]];
            [psalterSearchMArray addObjectsFromArray:@[searchResultString]];
            
        }
        
        
    } else {
        if( searchResult.length  <= range.location +90){
            NSString *searchResultString = [NSString stringWithFormat:@"...%@",
                                            [searchResult substringFromIndex:range.location -10]];
            
            [psalterSearchMArray addObjectsFromArray:@[searchResultString]];
            
        } else {
            NSString *searchResultString = [NSString stringWithFormat:@"...%@...",
                                            [[searchResult substringFromIndex:range.location -10]
                                             substringToIndex:100]];
            
            [psalterSearchMArray addObjectsFromArray:@[searchResultString]];
            
            
            
        }
        
    }
    
    
    
}





@end
