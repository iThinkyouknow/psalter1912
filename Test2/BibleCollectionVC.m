//
//  BibleCollectionVC.m
//  Test2
//
//  Created by Not For You to Use on 06/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "BibleCollectionVC.h"
#import "BibleData.h"
#import "bibleCVCell.h"
#import "BibleCVHeader.h"
#import "BibleChaptersCVVC.h"

@interface BibleCollectionVC() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) BibleData *bibleData;
@property (strong, nonatomic) BibleCVCell *cell;
@property (strong, nonatomic) BibleCVHeader *sectionHeader;

@end

@implementation BibleCollectionVC

- (void)viewDidLoad
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.bibleData = [[BibleData alloc] init];
    self.cell = [[BibleCVCell alloc] init];
    self.sectionHeader = [[BibleCVHeader alloc] init];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0){
        return 39;
        
    }else {
        return 27;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvCell";
    
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0){
        
        [self.bibleData getbookShortTitleForIndex:indexPath.item + 1];
        
    } else {
        
        [self.bibleData getbookShortTitleForIndex:indexPath.item + 40];
    }
    
    self.cell.label.text = self.bibleData.bookShortTitle;
    
    if ([self.cell.label.text isEqualToString:@"Psa"]) {
        self.cell.label.textColor = [UIColor cyanColor];
        
    } else {
        
        self.cell.label.textColor = [UIColor whiteColor];
    }
    
    if (indexPath.section == 0){
        if (self.bookIndex == indexPath.row + 1) {
            self.cell.label.textColor = [UIColor blueColor];
        }
      
    } else {
        
        if (self.bookIndex == indexPath.row + 40) {
            self.cell.label.textColor = [UIColor blueColor];
        }
    }

    
    return self.cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvHeader";
    self.sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(indexPath.section == 0) {
        self.sectionHeader.label.text = @"Old Testament";
    } else {
        self.sectionHeader.label.text = @"New Testament";
    }
    return self.sectionHeader;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue"]) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        
        BibleChaptersCVVC *destViewController = segue.destinationViewController;
        
        self.delegate = [self.navigationController.viewControllers objectAtIndex:0];
        
        if (indexPath.section == 0){
            
            [self.bibleData getbookFullTitleForIndex:indexPath.item + 1];
            
            [self.delegate bookIndex:indexPath.item + 1];
            
            if (self.bookIndex == indexPath.item + 1) {
                destViewController.chapterIndex = self.chapterIndex;
            }
            
        } else {
            
            [self.bibleData getbookFullTitleForIndex:indexPath.item + 40];
            [self.delegate bookIndex:indexPath.item +40];
            
            if (self.bookIndex == indexPath.item + 40) {
                destViewController.chapterIndex = self.chapterIndex;
            }

        }
        destViewController.navigationItem.title = self.bibleData.bookFullTitle;
        
        
    }
}





@end
