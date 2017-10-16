//
//  psalterSearchModel.h
//  Test2
//
//  Created by Not For You to Use on 23/04/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PsalterSearchModel : NSObject 
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSArray *searchTitleResults;



- (void)searchPsalterWithString:(NSString *)string;

//- (void)loopySearchForSearchCandidate:candidate forString:(NSString *)string forContentMutableArray:(NSMutableArray *)contentMutableArray forTitleMutableArray:(NSMutableArray *)titleMutableArray forKey:(NSString *)key;



@end
