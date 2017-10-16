//
//  ViewController.h
//  Test2
//
//  Created by Not For You to Use on 25/03/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BibleChaptersCVVC.h"
#import "TabBarController.h"

@interface ViewController : UIViewController  <PsalterNumberDetails>
@property (nonatomic, readonly) NSInteger psalmRef;
@property (nonatomic, readonly) NSInteger scoreRef;
@property (nonatomic, readonly) NSInteger psalterRef;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) id <PsalmandPsalterReferenceDelegate> psalmPsalterRefDelegate;





@end

