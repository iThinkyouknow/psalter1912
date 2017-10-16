//
//  SplitViewSelectionTVC.h
//  Test2
//
//  Created by Not For You to Use on 30/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"

@interface SplitViewSelectionTVC : UITableViewController 
@property (nonatomic, weak) id <ReferenceDetailsDelegate> tbDelegate;
@property (nonatomic, weak) id <PsalterNumberDetails> PNDelegate;
@property (nonatomic, weak) id <ScorePageProtocol> spDelegate;

@end
