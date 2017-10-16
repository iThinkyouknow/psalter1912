//
//  CreedsTVVC.m
//  Test2
//
//  Created by Not For You to Use on 16/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "CreedsTVVC.h"
#import "ConfessionsData.h"
#import "CreedsContentViewController.h"
#import "CreedsTVVC2.h"
#import "CreedsAndConfessionsVC.h"

@interface CreedsTVVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *creedsTV;
@property (strong, nonatomic) ConfessionsData *confessionsData;
@property (nonatomic) BOOL willAutoSelectNextPageFirstArticle;
@property (nonatomic) BOOL willAutoSelectNextPageLastArticle;


@end

@implementation CreedsTVVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.confessionsData = [[ConfessionsData alloc]init];
    [self.confessionsData getBookChaptersForConfession:self.navigationItem.title];
    
    
    self.creedsTV.delegate = self;
    self.creedsTV.dataSource = self;
    
    }

- (void)viewDidAppear:(BOOL)animated {
    //[super viewDidAppear:animated];
    
    if ([self.creedsTV numberOfRowsInSection:0] > 0) {
        
        if (self.willAutoSelectFirstRow) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self autoSelectRow:indexPath];
            
        } else if (self.willAutoSelectLastRow) {
            
            NSInteger rowCount = [self.creedsTV numberOfRowsInSection:0];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount - 1 inSection:0];
            
            [self autoSelectRow:indexPath];
        }
    }
    
}


- (void)autoSelectRow:(NSIndexPath *)indexPath {
    [self.creedsTV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    if([self.view respondsToSelector:@selector(addMotionEffect:)]){
        
        [self.creedsTV selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        
    } else {
        [self.creedsTV selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
    
    
    [self tableView:self.creedsTV didSelectRowAtIndexPath:indexPath];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.confessionsData.chaptersOfConfessionArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.creedsTV dequeueReusableCellWithIdentifier:@"chapters of confession cell"
                                                                forIndexPath:indexPath];
    

    
    if([self.confessionsData.chaptersOfConfessionArray count]>0){
        
        cell.textLabel.text = [self.confessionsData.chaptersOfConfessionArray objectAtIndex:indexPath.row];
        
        //subtitle
        [self.confessionsData getBookChaptersDescriptionForChapter:cell.textLabel.text forBookTitle:self.navigationItem.title];
        
        if(self.confessionsData.bookDescriptionArray != NULL){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.confessionsData.bookDescriptionArray componentsJoinedByString:@" | "]];
        } else {
            cell.detailTextLabel.text = nil;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = cell.contentView.backgroundColor;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"contentSegue"]) {
        NSIndexPath *indexPath = [self.creedsTV indexPathForSelectedRow];
        CreedsContentViewController *destViewController = segue.destinationViewController;
        destViewController.navigationItem.title = [self.creedsTV cellForRowAtIndexPath:indexPath].textLabel.text;
        
    } else if([segue.identifier isEqualToString:@"chapterSegue"]) {
        NSIndexPath *indexPath = [self.creedsTV indexPathForSelectedRow];
        CreedsTVVC2 *destViewController = segue.destinationViewController;
        destViewController.navigationItem.title = [self.creedsTV cellForRowAtIndexPath:indexPath].textLabel.text;
        
        if (self.willAutoSelectFirstRow) {
            self.willAutoSelectNextPageFirstArticle = YES;
        } if (self.willAutoSelectLastRow) {
            self.willAutoSelectNextPageLastArticle = YES;
        }
        destViewController.willAutoSelectFirstRow = self.willAutoSelectNextPageFirstArticle;
        destViewController.willAutoSelectLastRow = self.willAutoSelectNextPageLastArticle;
        
       
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self.confessionsData hasOnlyOneLevelforBookTitle:self.navigationItem.title] == NO){
        
        [self performSegueWithIdentifier:@"chapterSegue" sender:self];
        
    } else {
        
        [self performSegueWithIdentifier:@"contentSegue" sender:self];
        
    }
}

- (void)selectNextArticleIndex:(BOOL)willAutoSelectNextPageFirstArticle {
   
    
    self.willAutoSelectNextPageFirstArticle = willAutoSelectNextPageFirstArticle;
    
    NSInteger newRow = [self.creedsTV indexPathForSelectedRow].row + 1;
    
    
    if (newRow < [self.creedsTV numberOfRowsInSection:[self.creedsTV indexPathForSelectedRow].section]) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:[self.creedsTV indexPathForSelectedRow].section];
        
        [self.creedsTV selectRowAtIndexPath:newIndexPath  animated:YES scrollPosition:UITableViewScrollPositionMiddle];

        [self tableView:self.creedsTV didSelectRowAtIndexPath:newIndexPath];
        
    } else {
        
        CreedsAndConfessionsVC *prevVC = [self.navigationController.viewControllers firstObject];
            
            self.getNextDelegate = prevVC;
        
        if([self.view respondsToSelector:@selector(addMotionEffect:)]){
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }

        [self.getNextDelegate selectNextArticleIndex:YES];
        
    }
}

- (void)selectPreviousArticleIndex:(BOOL)willAutoSelectNextPageLastArticle {
    
    
    self.willAutoSelectNextPageLastArticle = willAutoSelectNextPageLastArticle;
    
    NSInteger newRow = [self.creedsTV indexPathForSelectedRow].row - 1;
    
    if (newRow >= 0) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:[self.creedsTV indexPathForSelectedRow].section];
        
        
        [self.creedsTV selectRowAtIndexPath:newIndexPath  animated:YES scrollPosition:UITableViewScrollPositionMiddle];

        [self tableView:self.creedsTV didSelectRowAtIndexPath:newIndexPath];
        
    } else {
        
        CreedsAndConfessionsVC *prevVC = [self.navigationController.viewControllers firstObject];
        
        self.getNextDelegate = prevVC;
        
        if([self.view respondsToSelector:@selector(addMotionEffect:)]){
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        }

        [self.getNextDelegate selectPreviousArticleIndex:YES];
        
    }

}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)viewDidDisappear:(BOOL)animated {
    
    self.willAutoSelectNextPageFirstArticle = NO;
    self.willAutoSelectNextPageLastArticle = NO;
    self.willAutoSelectFirstRow = NO;
    self.willAutoSelectLastRow = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
