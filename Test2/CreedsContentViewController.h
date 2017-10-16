//
//  CreedsContentViewController.h
//  Test2
//
//  Created by Not For You to Use on 20/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"
@import CoreText;


@interface CreedsContentViewController : UIViewController

@property (nonatomic, weak) id <getNextArticleProtocol> getNextDelegate;

@end
