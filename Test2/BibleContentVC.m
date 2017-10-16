//
//  BibleContentVC.m
//  Test2
//
//  Created by Not For You to Use on 11/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "BibleContentVC.h"
#import "BibleData.h"
#import "ViewController.h"
#import "Settings.h"
#import "BibleCollectionVC.h"


@interface BibleContentVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) BibleData *bibleData;
@property (strong, nonatomic) BibleChaptersCVVC *bibleChaptersCVVC;
@property (strong, nonatomic) ViewController *mainViewController;
@property (strong, nonatomic) NSString *bookTitle;
@property (strong, nonatomic) NSString *chapter;
@property (strong, nonatomic, readwrite) NSString *currentBookAndChapter;
@property (nonatomic) CGFloat defaultFontSize;
@property (nonatomic) NSInteger bookIndex;
@property (nonatomic) NSInteger chapterIndex;


@end

@implementation BibleContentVC

-(void)viewDidLayoutSubviews{
    [self.textView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)viewDidLoad {
    
    self.bibleData = [[BibleData alloc] init];
    self.defaultFontSize = [Settings defaultFontSize];
    self.textView.font = [UIFont systemFontOfSize:self.defaultFontSize];
    
    
    if (self.splitViewController){
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    if (self.bookIndex == 0 || !_bookIndex) {
    self.bookIndex = 19;
    self.chapterIndex = 1;
    [self.bibleData getContentForBook:@"Psalms" forChapter:@"1"];
    
    self.bookTitle = @"Psalms";
    self.chapter = @"1";
    }
    [self loadTextView];
}

- (void)loadTextView {
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ %@", self.bookTitle, self.chapter];
    
    if (self.bookTitle.length != 0){
        
        [self.bibleData getContentForBook:self.bookTitle forChapter:self.chapter];
        
    }
    
    
    self.textView.text = [self.bibleData.bibleContent componentsJoinedByString:@""];
    
    [self formattPage];
    
    self.currentBookAndChapter = self.navigationItem.title;
}

- (void)formattPage {
    NSMutableAttributedString *attStr = [self.textView.attributedText mutableCopy];
    
    for (NSString *superScriptCandidate  in self.bibleData.versesForSuperScript){
        
        NSRange range = [[attStr string] rangeOfString:superScriptCandidate options:0];
        
        if (range.location != NSNotFound) {
            [attStr
             setAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                             NSFontAttributeName: [UIFont systemFontOfSize:self.textView.font.pointSize * 0.8],
                             (id)kCTSuperscriptAttributeName:@1}
             range:range];
            
        }
    }
    self.textView.attributedText = attStr;
    self.textView.textAlignment = NSTextAlignmentJustified;
    
}



- (void)loadContentWithBookTitle:(NSString *)title chapter:(NSInteger)chapter{
    
    NSString *chapterString = [NSString stringWithFormat:@"%ld", (long)chapter];
    self.chapterIndex = chapter;
    
    self.bookTitle = title;
    self.chapter = chapterString;
    
    [self loadTextView];
    
}

- (void)bookIndex:(NSInteger)bookIndex {
    self.bookIndex = bookIndex;
}

- (IBAction)swipeForNext:(UISwipeGestureRecognizer *)sender {
    self.chapterIndex++;
    NSString *chapterString;
    
    [self.bibleData countChaptersForBookIndex:self.bookIndex];
    
    if (self.chapterIndex > self.bibleData.countOfChapters) {
        
        self.bookIndex++;
        
        if (self.bookIndex > 66) {
            self.bookIndex = 1;
        }
        
        self.chapterIndex = 1;
    }
    
    [self.bibleData getbookFullTitleForIndex:self.bookIndex];
    chapterString = [NSString stringWithFormat:@"%ld", (long)self.chapterIndex];
    
    self.bookTitle = self.bibleData.bookFullTitle;
    self.chapter = chapterString;
    
    
    [self loadTextView];
    [self animationForLoadingText];
}

- (IBAction)swipeForPrevious:(UISwipeGestureRecognizer *)sender {
    self.chapterIndex--;
    NSString *chapterString;
    
    if (self.chapterIndex < 1) {
        
        self.bookIndex--;
        
        if (self.bookIndex < 1) {
            self.bookIndex = 66;
        }
        
        
        [self.bibleData countChaptersForBookIndex:self.bookIndex];
        
        self.chapterIndex = self.bibleData.countOfChapters;
    }
    
    [self.bibleData getbookFullTitleForIndex:self.bookIndex];
    chapterString = [NSString stringWithFormat:@"%ld", (long)self.chapterIndex];
    
    self.bookTitle = self.bibleData.bookFullTitle;
    self.chapter = chapterString;
    
    
    [self loadTextView];
    [self animationForLoadingText];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    BibleCollectionVC *destVC = segue.destinationViewController;
    destVC.bookIndex = self.bookIndex;
    destVC.chapterIndex = self.chapterIndex;
}

#pragma mark Zoom Methods

- (IBAction)pinchForZoom:(UIPinchGestureRecognizer *)sender {
    CGFloat tempFontSize = sender.scale * self.textView.font.pointSize;
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        if(tempFontSize > self.defaultFontSize / 3 && tempFontSize < self.defaultFontSize * 5) {
            
            self.textView.font = [UIFont
                                  fontWithName:self.textView.font.fontName
                                  size:tempFontSize];
            
            self.textView.attributedText = self.textView.attributedText;
            
            
            sender.scale = 1;
            
        }
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        
        if(tempFontSize < self.defaultFontSize / 2){
            self.textView.font = [UIFont
                                  fontWithName:self.textView.font.fontName
                                  size:self.defaultFontSize / 2];
            
            
        }else if (tempFontSize > self.defaultFontSize * 4){
            self.textView.font = [UIFont
                                  fontWithName:self.textView.font.fontName
                                  size:self.defaultFontSize * 4];
            
            
        }else {
            self.textView.font = [UIFont
                                  fontWithName:self.textView.font.fontName
                                  size:tempFontSize];
            
        }
        [self formattPage];
    }
}

- (IBAction)tapForZoom:(UITapGestureRecognizer *)sender {
    
    if (self.textView.font.pointSize <= self.defaultFontSize * 2) {
        self.textView.font = [UIFont
                              fontWithName:self.textView.font.fontName
                              size:self.textView.font.pointSize * 2];
        
        
    } else if (self.textView.font.pointSize > self.defaultFontSize * 2){
        
        self.textView.font = [UIFont
                              fontWithName:self.textView.font.fontName
                              size:self.defaultFontSize];
        
    }
    [self formattPage];
    
}




- (void)animationForLoadingText {
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5f;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    //transition.subtype =kCATransitionFromTop;
    transition.delegate = self;
    [self.textView.layer addAnimation:transition forKey:nil];
}


@end
