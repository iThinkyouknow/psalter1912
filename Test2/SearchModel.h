//
//  searchModel.h
//  Test2
//
//  Created by Not For You to Use on 25/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject
@property (nonatomic, strong, readonly) NSArray *psalterSearchResults;
@property (nonatomic, strong, readonly) NSArray *psalterSearchTitleResults;

- (void)searchWithSearchString:(NSString *)searchString;

@end
