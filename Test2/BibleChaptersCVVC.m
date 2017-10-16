//
//  BibleChaptersCV.m
//  Test2
//
//  Created by Not For You to Use on 11/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "BibleChaptersCVVC.h"
#import "BibleData.h"
#import "bibleCVCell.h"
#import "BibleCVHeader.h"
#import "BibleContentVC.h"

@interface BibleChaptersCVVC ()  <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) BibleData *bibleData;
@property (strong, nonatomic) BibleCVCell *cell;
@property (strong, nonatomic) BibleCVHeader *sectionHeader;

@end



@implementation BibleChaptersCVVC
@synthesize delegate;

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
    [self.bibleData countChaptersForBook:self.navigationItem.title];
    return self.bibleData.countOfChapters;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cvCell";
    
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    self.cell.label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item +1];
    
        if (self.chapterIndex == indexPath.row + 1) {
            self.cell.label.textColor = [UIColor blueColor];
        } else {
            self.cell.label.textColor = [UIColor whiteColor];
        }
        
    return self.cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cvHeader";
    self.sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    self.sectionHeader.label.text = @"Chapters";
    
    return self.sectionHeader;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.delegate = [self.navigationController.viewControllers objectAtIndex:0];
    [self.delegate loadContentWithBookTitle:self.navigationItem.title chapter:indexPath.item +1];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


@end
