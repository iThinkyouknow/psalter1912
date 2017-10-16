//
//  SplitViewSelectionTVC.m
//  Test2
//
//  Created by Not For You to Use on 30/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "SplitViewSelectionTVC.h"
#import "SplitViewController.h"
#import "ViewController.h"
#import "BibleContentVC.h"
#import "ScoreVC.h"

@interface SplitViewSelectionTVC () <UITableViewDelegate, UISplitViewControllerDelegate>
@property (nonatomic) NSInteger psalmRefIntSaved;
@property (nonatomic, strong) NSString *psalterRefSaved;
@property (nonatomic, strong) ViewController *psalterViewController;
@property (nonatomic, strong) ScoreVC *scoreVC;
@property (nonatomic, strong) UINavigationController *bibleContentNavController;
@property (nonatomic, strong) UINavigationController *creedsNavController;
@property (nonatomic, strong) UINavigationController *specialNavController;

@property (nonatomic, strong) NSMutableSet *mutableSetOfVC;
@property (nonatomic, strong) NSArray *vcArray;




@end

@implementation SplitViewSelectionTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.splitViewController.delegate = self;
    self.mutableSetOfVC = [[NSMutableSet alloc] init];
    
    self.psalterViewController = [self.splitViewController.viewControllers lastObject];
    self.scoreVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ScoreVC"];
    self.bibleContentNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"BibleNavController"];
    self.creedsNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreedsNavController"];
    self.specialNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"SpecialNavController"];
    
    
    if(!_psalterViewController){
        self.psalterViewController = [self.splitViewController.viewControllers lastObject];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.row == 0) {
        
        if([self.splitViewController.viewControllers lastObject] == self.scoreVC){
            
            
            
            if (self.psalterViewController.scoreRef != self.scoreVC.scorePage) {
                
                self.PNDelegate = self.psalterViewController;
                [self.PNDelegate getPsalterDetailsWithScoreRef:self.scoreVC.scorePage];
                
            }
            
            [self.splitViewController setViewControllers:@[self.splitViewController.viewControllers[0], self.psalterViewController]];
        }
        
        
        if([self.splitViewController.viewControllers lastObject] == self.bibleContentNavController){
            
            BibleContentVC *bCVC = [self.bibleContentNavController.viewControllers firstObject];
            
            
            NSString *psalterPsalmRef = [NSString stringWithFormat:@"Psalms %ld", (long)self.psalterViewController.psalmRef];
            
            
            if (![bCVC.currentBookAndChapter isEqualToString:psalterPsalmRef]) {
                
                NSString *bibleBookName = [bCVC.currentBookAndChapter stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
                
                
                if ([bibleBookName isEqualToString:@"Psalms "]) {
                    NSString *psalmRef = [bCVC.currentBookAndChapter stringByReplacingOccurrencesOfString:@"Psalms " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [bCVC.currentBookAndChapter length])];
                    self.PNDelegate = self.psalterViewController;
                    [self.PNDelegate getPsalterDetailsWithPsalmRef:psalmRef];
                }
            }
            
            [self.splitViewController setViewControllers:@[self.splitViewController.viewControllers[0], self.psalterViewController]];
            
        } else {
            
            [self.splitViewController setViewControllers:@[self.splitViewController.viewControllers[0], self.psalterViewController]];
            
        }
    }
    
    
    if (indexPath.row == 1) {
        self.spDelegate = self.scoreVC;
       
        if (self.psalterViewController.psalterRef) {
            
            [self.spDelegate loadScorePageForPsalter:self.psalterViewController.psalterRef];
        
            
        }
        
        [self.splitViewController setViewControllers:@[self.splitViewController.viewControllers[0], self.scoreVC]];

    }
    
    
    if (indexPath.row == 2) {
        [self.splitViewController setViewControllers:@[self.splitViewController.viewControllers[0], self.creedsNavController]];
        
    }
    
    
    if(indexPath.row == 3) {
        if (self.bibleContentNavController){
            [self shouldPerformSegueWithIdentifier:@"bible Detail Segue" sender:self];
            
            if ([self.splitViewController.viewControllers lastObject] == self.psalterViewController){
                
                [self setBibleContentNavController:[self.bibleContentNavController.viewControllers firstObject] For:self.psalterViewController];
                
            }
            
            [self.splitViewController setViewControllers:@[self.splitViewController.viewControllers[0], self.bibleContentNavController]];
            
        } else {
            
            if([self.splitViewController.viewControllers lastObject] == self.psalterViewController){
                
                [self performSegueWithIdentifier:@"bible Detail Segue" sender:self];
                
                self.bibleContentNavController = [self.splitViewController.viewControllers lastObject];
                
                [self setBibleContentNavController:[self.bibleContentNavController.viewControllers firstObject] For:self.psalterViewController];
                
            } else {
                
                [self performSegueWithIdentifier:@"bible Detail Segue" sender:self];
                self.bibleContentNavController = [self.splitViewController.viewControllers lastObject];
                
            }
        }
        
        
    }
    
    
    if (indexPath.row == 4) {
        [self.splitViewController setViewControllers:@[self.splitViewController.viewControllers[0], self.specialNavController]];
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = cell.contentView.backgroundColor;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
    
}



- (void)setBibleContentNavController:(BibleContentVC *)bcvc For:(ViewController *)psalterVC {
    self.tbDelegate = bcvc;
    
    if (psalterVC.psalmRef == 0) {
        [self.tbDelegate loadContentWithBookTitle:@"Psalms" chapter:1];
        
        
    } else {
        
        
        [self.tbDelegate loadContentWithBookTitle:@"Psalms" chapter:psalterVC.psalmRef];
        
        
    }
    
    [self.tbDelegate bookIndex:19];
    
}




@end
