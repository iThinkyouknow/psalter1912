//
//  TabBarController.m
//  Test2
//
//  Created by Not For You to Use on 22/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "TabBarController.h"
#import "BibleData.h"
#import "ViewController.h"
#import "BibleContentVC.h"
#import "PsalterModel.h"
#import "ScoreVC.h"

@interface TabBarController () <UITabBarControllerDelegate>
@property (strong, nonatomic) PsalterModel *psalterModel;


@end

@implementation TabBarController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
}


- (BOOL) tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    ViewController *VC = [tabBarController.viewControllers objectAtIndex:0];
    ScoreVC *scoreVC = [tabBarController.viewControllers objectAtIndex:1];
    
    UINavigationController *bcNVC = [tabBarController.viewControllers objectAtIndex:3];
    BibleContentVC *bCVC = [bcNVC.viewControllers objectAtIndex:0];
    
    if (VC == tabBarController.selectedViewController){
        if (viewController == bcNVC) {
            
            self.tbDelegate = bCVC;
            
            if (VC.psalmRef == 0) {
                [self.tbDelegate loadContentWithBookTitle:@"Psalms" chapter:1];
                [self.tbDelegate bookIndex:19];
                
            } else {
                
                [self.tbDelegate loadContentWithBookTitle:@"Psalms" chapter:VC.psalmRef];
                [self.tbDelegate bookIndex:19];
                
            }
            
        } else if (viewController == scoreVC) {
            self.spDelegate = scoreVC;
            
            if (VC.psalterRef) {
                [self.spDelegate loadScorePageForPsalter:VC.psalterRef];
                
            }
            
            
            
        }
    }
    
    if (scoreVC == tabBarController.selectedViewController) {
        if (VC == viewController) {
            
            
            if (VC.scoreRef != scoreVC.scorePage) {
            
            self.pnDelegate = VC;
            [self.pnDelegate getPsalterDetailsWithScoreRef:scoreVC.scorePage];
            
            }
            
        }
    }
    
    if (bcNVC == tabBarController.selectedViewController){
        if (viewController == [tabBarController.viewControllers objectAtIndex:0]) {
            NSString *psalterPsalmRef = [NSString stringWithFormat:@"Psalms %ld", (long)VC.psalmRef];
            
            
            if (![bCVC.currentBookAndChapter isEqualToString:psalterPsalmRef]) {
                NSString *bibleBookName = [bCVC.currentBookAndChapter stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
                
                
                if ([bibleBookName isEqualToString:@"Psalms "]) {
                    NSString *psalmRef = [bCVC.currentBookAndChapter stringByReplacingOccurrencesOfString:@"Psalms " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [bCVC.currentBookAndChapter length])];
                    self.pnDelegate = VC;
                    [self.pnDelegate getPsalterDetailsWithPsalmRef:psalmRef];
                }
            }
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
