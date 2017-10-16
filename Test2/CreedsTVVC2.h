//
//  CreedsTVVC2.h
//  Test2
//
//  Created by Not For You to Use on 23/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "CreedsTVVC.h"
#import "Protocols.h"

@interface CreedsTVVC2 : ViewController <getNextArticleProtocol>
@property (nonatomic, weak) id <getNextArticleProtocol> getNextDelegate;
@property (nonatomic) BOOL willAutoSelectFirstRow;
@property (nonatomic) BOOL willAutoSelectLastRow;


@end
