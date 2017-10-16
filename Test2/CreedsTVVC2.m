//
//  CreedsTVVC2.m
//  Test2
//
//  Created by Not For You to Use on 23/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "CreedsTVVC2.h"
#import "ConfessionsData.h"
#import "CreedsContentViewController.h"
#import "CreedsTVVC.h"
#import "CreedsAndConfessionsVC.h"

@interface CreedsTVVC2 () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) ConfessionsData *confessionsData;
@property (weak, nonatomic) IBOutlet UITableView *creeds2TV;


@end

@implementation CreedsTVVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.confessionsData = [[ConfessionsData alloc]init];
    
    NSUInteger navigationVControllersCount = [self.navigationController.viewControllers count];
    
    UIViewController* prevController = [self.navigationController.viewControllers objectAtIndex:navigationVControllersCount-2];
    
    
    [self.confessionsData getBookChaptersDescriptionForChapter:self.navigationItem.title forBookTitle:prevController.navigationItem.title];
    
    self.creeds2TV.delegate = self;
    self.creeds2TV.dataSource = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
   // [super viewDidAppear:animated];
    
    if ([self.creeds2TV numberOfRowsInSection:0] > 0) {
        if(self.willAutoSelectFirstRow) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self autoSelectRow:indexPath];
            
        } else if (self.willAutoSelectLastRow) {
            NSInteger rowCount = [self.creeds2TV numberOfRowsInSection:0];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount - 1 inSection:0];
            
            [self autoSelectRow:indexPath];
        }
    }

}

-(void)viewDidDisappear:(BOOL)animated {
    
    self.willAutoSelectLastRow = NO;
    self.willAutoSelectFirstRow = NO;
}

- (void)autoSelectRow:(NSIndexPath *)indexPath {
     [self.creeds2TV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    if([self.view respondsToSelector:@selector(addMotionEffect:)]){
    [self.creeds2TV selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        
    } else {
        [self.creeds2TV selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
    
    [self tableView:self.creeds2TV didSelectRowAtIndexPath:indexPath];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.confessionsData.chaptersLevel2Array count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.creeds2TV dequeueReusableCellWithIdentifier:@"chapters of confession cell two"
                                                                 forIndexPath:indexPath];
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    
    if([self.confessionsData.chaptersLevel2Array count]>0){
        
        cell.textLabel.text = [self.confessionsData.chaptersLevel2Array objectAtIndex:indexPath.row];
        
        //subtitle
        NSUInteger navigationVControllersCount = [self.navigationController.viewControllers count];
        
        UIViewController* prevController = [self.navigationController.viewControllers objectAtIndex:navigationVControllersCount-2];
        
        [self.confessionsData getBookChaptersDescriptionForChapterLevelTwo:cell.textLabel.text withChapterLevelOne:self.navigationItem.title forBookTitle:prevController.navigationItem.title];
        
        if(self.confessionsData.bookDescriptionArrayTwo != NULL){
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.confessionsData.bookDescriptionArrayTwo componentsJoinedByString:@"|"]];
            
        } else {
            cell.detailTextLabel.text = nil;
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = cell.contentView.backgroundColor;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"contentSegue" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"contentSegue"]) {
        NSIndexPath *indexPath = [self.creeds2TV indexPathForSelectedRow];
        CreedsContentViewController *destViewController = segue.destinationViewController;
        
        destViewController.navigationItem.title = [self.creeds2TV cellForRowAtIndexPath:indexPath].textLabel.text;
        
    }
}

- (void)selectNextArticleIndex:(BOOL)willAutoSelectNextPageFirstArticle {
    
    NSInteger newRow = [self.creeds2TV indexPathForSelectedRow].row + 1;
    
    if (newRow < [self.creeds2TV numberOfRowsInSection:[self.creeds2TV indexPathForSelectedRow].section]) {
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:[self.creeds2TV indexPathForSelectedRow].section];
        
        
        [self.creeds2TV selectRowAtIndexPath:newIndexPath  animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        
        [self tableView:self.creeds2TV didSelectRowAtIndexPath:newIndexPath];
        
    } else {
        
        if ([self.navigationController.viewControllers count] == 3) {
            CreedsTVVC *prevVC = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2];
            
            self.getNextDelegate = prevVC;
            
        } else {
            
            CreedsAndConfessionsVC *prevVC = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2];
            
            self.getNextDelegate = prevVC;
        }
        
        if([self.view respondsToSelector:@selector(addMotionEffect:)]){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }
        
        [self.getNextDelegate selectNextArticleIndex:YES];
        
        
        
        
    }
    
}

- (void)selectPreviousArticleIndex:(BOOL)willAutoSelectNextPageLastArticle {
    NSInteger newRow = [self.creeds2TV indexPathForSelectedRow].row - 1;
    
    if (newRow >= 0) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newRow inSection:[self.creeds2TV indexPathForSelectedRow].section];
        
        
        [self.creeds2TV selectRowAtIndexPath:newIndexPath  animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        [self tableView:self.creeds2TV didSelectRowAtIndexPath:newIndexPath];
        
    } else {
        
        if ([self.navigationController.viewControllers count] == 3) {
            CreedsTVVC *prevVC = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2];
            
            self.getNextDelegate = prevVC;
            
        } else {
            
            CreedsAndConfessionsVC *prevVC = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count] - 2];
            
            self.getNextDelegate = prevVC;
        }
        
        if([self.view respondsToSelector:@selector(addMotionEffect:)]){
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
