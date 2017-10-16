//
//  ArticlesModel.m
//  Test2
//
//  Created by Not For You to Use on 23/07/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "ArticlesModel.h"
@interface ArticlesModel()
@property (nonatomic, strong, readwrite) NSArray *articlesArray;

@end

@implementation ArticlesModel

- (instancetype)init{
    self = [super init];
    return self;
}

- (NSArray *)articlesArray {
    if (!_articlesArray) {
        _articlesArray = @[@{@"title":@"\"Through Endless Ages Sound His Praise\": The History of Psalm-Singing in the Church",
                             @"link":@"http://standardbearer.rfpa.org/articles/“through-endless-ages-sound-his-praise”-history-psalm-singing-church",
                             @"author": @"Rev. Brian Huizinga"},
                           @{@"title": @"Our Psalter: 100 Years of Praise (1) Called to Sing Psalms",
                             @"link": @"http://standardbearer.rfpa.org/articles/o-ur-psalter-100-years-praise-1-called-sing-psalms",
                             @"author": @"Rev. David Overway"},
                           @{@"title": @"Basil the Great (c. A.D. 330-c. A.D. 379) on Psalm Singing",
                             @"link": @"http://standardbearer.rfpa.org/articles/basil-great-c-ad-330-c-ad-379-psalm-singing",
                             @"author": @"Basil the Great"},
                           @{@"title": @"Worship the Lord in Psalms",
                             @"link": @"http://standardbearer.rfpa.org/articles/worship-lord-psalms",
                             @"author": @"Prof. Herman Hanko"},
                           @{@"title": @"The Secession of 1857: A Return to Psalm-Singing",
                             @"link": @"http://standardbearer.rfpa.org/articles/secession-1857-return-psalm-singing",
                             @"author": @"Rev. Cory Griess"},
                           @{@"title": @"Singing the Imprecatory Psalms",
                             @"link": @"http://standardbearer.rfpa.org/articles/singing-imprecatory-psalms",
                             @"author": @"Rev. Ronald H. Hanko"}];
    }
    return _articlesArray;
}

@end
