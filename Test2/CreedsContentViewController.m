//
//  CreedsContentViewController.m
//  Test2
//
//  Created by Not For You to Use on 20/05/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "CreedsContentViewController.h"
#import "ConfessionsData.h"
#import "Settings.h"
#import "CreedsTVVC2.h"
#import "CreedsTVVC.h"
#import "CreedsAndConfessionsVC.h"

@interface CreedsContentViewController ()
@property (strong, nonatomic) ConfessionsData *confessionsData;
@property (weak, nonatomic) IBOutlet UITextView *creedsContentTextV;
@property (nonatomic) CGFloat defaultFontSize;
@property (nonatomic) NSUInteger navControllerCount;
@end

@implementation CreedsContentViewController

- (void)viewDidLayoutSubviews{
    [self.creedsContentTextV setContentOffset:CGPointMake(0, 0) animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.defaultFontSize = [Settings defaultFontSize];
    self.creedsContentTextV.font = [UIFont systemFontOfSize:self.defaultFontSize];
    
    if (self.splitViewController){
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    self.confessionsData = [[ConfessionsData alloc]init];
    
    self.navControllerCount = [self.navigationController.viewControllers count];
    
    UIViewController* prevController = [self.navigationController.viewControllers objectAtIndex:self.navControllerCount-2];
    
    
    if([self.navigationController.viewControllers count] == 4){
        
        UIViewController* bookTitleController = [self.navigationController.viewControllers objectAtIndex:self.navControllerCount-3];
        [self.confessionsData getContentForBookTitle:bookTitleController.navigationItem.title forChapter:prevController.navigationItem.title forArticle:self.navigationItem.title];
        
    } else {
        [self.confessionsData getContentForBookTitle:prevController.navigationItem.title forChapter:self.navigationItem.title forArticle:nil];
        
    }
    
    [self setTextForCreedsContentTextV];
    
}




- (void)setTextForCreedsContentTextV
{
    self.creedsContentTextV.text = [[self.confessionsData.bookContentOrderedSet array] componentsJoinedByString:@"\n\n"];
    
    [self formattPage];
    
  }


- (void)formattPage {
    NSMutableAttributedString *attributedString = [self.creedsContentTextV.attributedText mutableCopy];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableParagraphStyle *paragraphStyleJ = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyleJ setAlignment:NSTextAlignmentJustified];
    
    
    for (NSString *stringForRange in self.confessionsData.arrayOfStringsForRange){
        
        UIFont *font = [UIFont boldSystemFontOfSize:self.creedsContentTextV.font.pointSize * 1.1];
        
        NSDictionary *attDict = @{
                                  NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle,
                                  NSForegroundColorAttributeName: [UIColor whiteColor]
                                  };
        
        [self formatTextforAttributedText:attributedString withAttDict:attDict forText:stringForRange];
        
        font = [UIFont boldSystemFontOfSize:self.creedsContentTextV.font.pointSize * 1.0];
        
        attDict = @{
                    NSFontAttributeName:font,
                    NSParagraphStyleAttributeName:paragraphStyleJ,
                    NSForegroundColorAttributeName: [UIColor whiteColor]
                    };
        
        [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"A. "];
    }
    
    
    UIFont *font = [UIFont boldSystemFontOfSize:self.creedsContentTextV.font.pointSize * 1.0];
    
    NSDictionary *attDict = @{
                              NSFontAttributeName:font,
                              NSParagraphStyleAttributeName:paragraphStyleJ,
                              NSForegroundColorAttributeName: [UIColor whiteColor]
                              };
    
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText1:@"<b>" forText2:@"</b>"];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"Error: "];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"Rejection: "];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"Answer: "];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"First. "];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"\nFirst"];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"\nSecondly"];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"\nThirdly"];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"\nFourthly"];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"\nFifthly"];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"\nPrayer\n"];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:@"\nThanksgiving\n"];
    
    
    font = [UIFont italicSystemFontOfSize:self.creedsContentTextV.font.pointSize * 1.0];
    
    attDict = @{
                NSFontAttributeName:font,
                NSParagraphStyleAttributeName:paragraphStyleJ,
                NSForegroundColorAttributeName: [UIColor whiteColor]
                };
    
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText1:@"<i>" forText2:@"</i>"];
    
    attDict = @{(id)kCTSuperscriptAttributeName:@1,
                NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText1:@"#" forText2:@"#"];
    
    self.creedsContentTextV.attributedText = attributedString;

}


- (void) formatTextforAttributedText:(NSMutableAttributedString *)attributedString withAttDict:(NSDictionary *)attDict forText:(NSString *)stringForRange {
    
    NSUInteger count = 0, length = [attributedString length];
    NSRange range = NSMakeRange(0, length);
    
    while(range.location != NSNotFound)
    {
        range = [[attributedString string] rangeOfString:stringForRange options:0 range:range];
        
        if(range.location != NSNotFound) {
            
            [attributedString setAttributes:attDict range:range];
            
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            
            count++;
        }
    }
}

- (void) formatTextforAttributedText:(NSMutableAttributedString *)attributedString withAttDict:(NSDictionary *)attDict forText1:(NSString *)stringForRange forText2:(NSString *)stringForRange2 {
    
    NSUInteger count = 0, length = [attributedString length];
    NSRange range = NSMakeRange(0, length);
    
    while(range.location != NSNotFound)
    {
        
        range = [[attributedString string] rangeOfString:stringForRange options:0 range:range];
        //
        
        if (range.location != NSNotFound) {
            
            NSRange rangeA = range;
            
            range = [[attributedString string] rangeOfString:stringForRange2 options:0 range:NSMakeRange(rangeA.location + rangeA.length, length - rangeA.location - rangeA.length)];
            
            [attributedString setAttributes:attDict range:NSMakeRange(rangeA.location, range.location - rangeA.location + range.length)];
            
            [attributedString deleteCharactersInRange:rangeA];
            
            length = [attributedString length];
            
            range = [[attributedString string] rangeOfString:stringForRange2 options:0 range:NSMakeRange(rangeA.location - rangeA.length, length - rangeA.location - rangeA.length)];
            
            [attributedString deleteCharactersInRange:range];
            
            length = [attributedString length];
            
            range = NSMakeRange(range.location, length - (range.location));
            
            count++;
        }
        
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



- (IBAction)pinchForZoom:(UIPinchGestureRecognizer *)sender {
    CGFloat tempFontSize = sender.scale * self.creedsContentTextV.font.pointSize;
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        
        if(tempFontSize > self.defaultFontSize / 3 && tempFontSize < self.defaultFontSize * 5) {
            
            self.creedsContentTextV.font = [UIFont
                                            fontWithName:self.creedsContentTextV.font.fontName
                                                    size:tempFontSize];
            
            self.creedsContentTextV.attributedText = self.creedsContentTextV.attributedText;
            
            sender.scale = 1;
            
        }
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded){
        
        if(tempFontSize < self.defaultFontSize / 2){
            self.creedsContentTextV.font = [UIFont
                                            fontWithName:self.creedsContentTextV.font.fontName
                                                    size:self.defaultFontSize / 2];
            
            
        }else if (tempFontSize > self.defaultFontSize * 4){
            self.creedsContentTextV.font = [UIFont
                                            fontWithName:self.creedsContentTextV.font.fontName
                                                    size:self.defaultFontSize * 4];
            
            
        }else {
            self.creedsContentTextV.font = [UIFont
                                            fontWithName:self.creedsContentTextV.font.fontName
                                                    size:tempFontSize];
            
        }
        [self formattPage];
    }
}

- (IBAction)tapForZoom:(UITapGestureRecognizer *)sender {
    
    if (self.creedsContentTextV.font.pointSize <= self.defaultFontSize * 2) {
        self.creedsContentTextV.font = [UIFont
                                        fontWithName:self.creedsContentTextV.font.fontName
                                                size:self.creedsContentTextV.font.pointSize * 2];
        
        
    } else if (self.creedsContentTextV.font.pointSize > self.defaultFontSize * 2){
        
        self.creedsContentTextV.font = [UIFont
                                        fontWithName:self.creedsContentTextV.font.fontName
                                                size:self.defaultFontSize];
        
    }
    [self formattPage];
    
}

- (IBAction)swipeForNext:(UISwipeGestureRecognizer *)sender {
    
    if ([self.navigationController.viewControllers count] == 4) {
        CreedsTVVC2 *prevVC = [self.navigationController.viewControllers objectAtIndex:self.navControllerCount - 2];
        
        self.getNextDelegate = prevVC;
    } else {
        CreedsTVVC *prevVC = [self.navigationController.viewControllers objectAtIndex:self.navControllerCount - 2];
        self.getNextDelegate = prevVC;
    }
    
    
    if([self.view respondsToSelector:@selector(addMotionEffect:)]){
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
    
        [self.getNextDelegate selectNextArticleIndex:NO];
    
}

- (IBAction)swipeForPrevious:(UISwipeGestureRecognizer *)sender {
    if ([self.navigationController.viewControllers count] == 4) {
        CreedsTVVC2 *prevVC = [self.navigationController.viewControllers objectAtIndex:self.navControllerCount - 2];
        
        self.getNextDelegate = prevVC;
    } else {
        CreedsTVVC *prevVC = [self.navigationController.viewControllers objectAtIndex:self.navControllerCount - 2];
        self.getNextDelegate = prevVC;
    }
    
    if([self.view respondsToSelector:@selector(addMotionEffect:)]){
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }

    [self.getNextDelegate selectPreviousArticleIndex:NO];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
