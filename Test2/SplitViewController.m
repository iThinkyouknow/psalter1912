//
//  SplitViewController.m
//  Test2
//
//  Created by Not For You to Use on 30/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "SplitViewController.h"
#import "BibleData.h"
#import "ViewController.h"
#import "BibleContentVC.h"
#import "PsalterModel.h"

@interface SplitViewController() <UISplitViewControllerDelegate>

@property (strong, nonatomic) PsalterModel *psalterModel;

@end

@implementation SplitViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
}




@end
