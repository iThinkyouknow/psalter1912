//
//  Protocols.h
//  Test2
//
//  Created by Not For You to Use on 27/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PsalterNumberDetails

- (void)getPsalterDetailsWithPsalmRef:(NSString *)psalmRef;
- (void)getPsalterDetailsWithScoreRef:(NSInteger)scoreRef;

@end


@protocol ReferenceDetailsDelegate <NSObject>
@required

- (void)loadContentWithBookTitle:(NSString *)title chapter:(NSInteger)chapter;
- (void)bookIndex:(NSInteger)bookIndex;

@end


@protocol PsalmandPsalterReferenceDelegate <NSObject>
@required

- (void)savePsalmRef:(NSInteger)psalmRef andPsalterRef:(NSString *)psalterRef;

@end


@protocol getNextArticleProtocol <NSObject>
@required

- (void)selectNextArticleIndex:(BOOL)willAutoSelectNextPageFirstArticle;
- (void)selectPreviousArticleIndex:(BOOL)willAutoSelectNextPageLastArticle;

@optional
- (void)autoSelectFirstArticle;


@end


@protocol ScorePageProtocol <NSObject>

- (void)loadScorePageForPsalter:(NSInteger)psalterRef;

@end



@interface Protocols : NSObject

@end
