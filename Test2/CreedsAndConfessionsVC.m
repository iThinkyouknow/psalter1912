//
//  CreedsAndConfessionsVC.m
//  Test2
//
//  Created by Not For You to Use on 07/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "CreedsAndConfessionsVC.h"
#import "ConfessionsData.h"
#import "CVCell.h"
#import "CreedsTVVC.h"

@interface CreedsAndConfessionsVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) ConfessionsData *confessionsData;
@property (nonatomic, strong) CVCell *cell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *formsButton;
@property (nonatomic) BOOL willAutoSelectNextPageFirstArticle;
@property (nonatomic) BOOL willAutoSelectNextPageLastArticle;


@end

@implementation CreedsAndConfessionsVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    
    if (self.splitViewController){
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    self.confessionsData = [[ConfessionsData alloc] init];
    [self.confessionsData getBookTitlesForType:self.navigationItem.title];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    self.willAutoSelectNextPageFirstArticle = NO;
    self.willAutoSelectNextPageLastArticle = NO;
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.confessionsData.bookTitles count];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionViewLayout invalidateLayout];
    return CGSizeMake(self.view.bounds.size.width/2.5f, self.view.bounds.size.width/2.5f*1.3f);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    self.cell = nil;
    static NSString *cellIdentifier = @"cvCell";
    
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    self.cell.bookIcon.image = nil;
    
    self.cell.bookIcon.image = [UIImage imageNamed:@"Book Icon"];
    
    self.cell.bookTitleLabel.text = [self.confessionsData.bookTitles objectAtIndex:indexPath.row];
    
    self.cell.bookTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    return self.cell;
    
}



#pragma mark Segue Code

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Creeds Content"]) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        
        CreedsTVVC *destViewController = segue.destinationViewController;
        
        destViewController.navigationItem.title = [self.confessionsData.bookTitles objectAtIndex:indexPath.item];
        
        destViewController.willAutoSelectLastRow = self.willAutoSelectNextPageLastArticle;
        destViewController.willAutoSelectFirstRow = self.willAutoSelectNextPageFirstArticle;
    }
}


- (IBAction)formsButton:(UIBarButtonItem *)sender {
    
    [UIView transitionWithView:self.collectionView
                      duration:0.8f
                       options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        NSString *currentTitle = self.navigationItem.title;
                        self.navigationItem.title = self.navigationItem.rightBarButtonItem.title;
                        self.navigationItem.rightBarButtonItem.title = currentTitle;
                        [self.confessionsData getBookTitlesForType:self.navigationItem.title];
                        
                        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
                        [self.collectionView reloadData];
                    }
                    completion:^(BOOL finished) {
                    }];
    
    
}




- (void)selectNextArticleIndex:(BOOL)willAutoSelectNextPageFirstArticle {
    
    self.willAutoSelectNextPageFirstArticle = willAutoSelectNextPageFirstArticle;
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
    
    NSInteger newRow = indexPath.item + 1;
    
    
    if (newRow < [self.collectionView numberOfItemsInSection:indexPath.section]) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newRow inSection:indexPath.section];
        
        if([self.view respondsToSelector:@selector(addMotionEffect:)]){
        [self.collectionView selectItemAtIndexPath:newIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        } else {
            [self.collectionView selectItemAtIndexPath:newIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        }
        
        [self performSegueWithIdentifier:@"Creeds Content" sender:[self.collectionView cellForItemAtIndexPath:[self.collectionView indexPathsForSelectedItems].firstObject]];
    } else {
        self.willAutoSelectNextPageFirstArticle = NO;
        
        self.willAutoSelectNextPageLastArticle = NO;
    }
    
}

- (void)selectPreviousArticleIndex:(BOOL)willAutoSelectNextPageLastArticle {
    self.willAutoSelectNextPageLastArticle = willAutoSelectNextPageLastArticle;
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
    
    NSInteger newRow = indexPath.item - 1;
    
    
    if (newRow >= 0) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newRow inSection:indexPath.section];
        
        if([self.view respondsToSelector:@selector(addMotionEffect:)]){
        [self.collectionView selectItemAtIndexPath:newIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        } else {
           [self.collectionView selectItemAtIndexPath:newIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionTop];
        }
       
        
        [self performSegueWithIdentifier:@"Creeds Content" sender:[self.collectionView cellForItemAtIndexPath:[self.collectionView indexPathsForSelectedItems].firstObject]];
        
    } else {
        self.willAutoSelectNextPageFirstArticle = NO;
        
        self.willAutoSelectNextPageLastArticle = NO;
    }

}


@end
