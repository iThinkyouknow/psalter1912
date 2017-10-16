//
//  CreditsVC.m
//  Test2
//
//  Created by Not For You to Use on 23/07/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "CreditsVC.h"
#import "Settings.h"

@interface CreditsVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) CGFloat defaultFontSize;

@end

@implementation CreditsVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.defaultFontSize = [Settings defaultFontSize];
    self.textView.font = [UIFont systemFontOfSize:self.defaultFontSize];
    
    [self loadTextView];
}

- (void)viewDidLayoutSubviews{
    [self.textView setContentOffset:CGPointMake(0, 0) animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTextView {
    NSString *n = @"\n";
    NSString *source = @"Source: ";
    NSString *intro = @"We would like to give credit and thanks to the following that made this app possible.";
    
    NSString *cat1 = @"The Lord God Almighty";
    NSString *party1 = @"";
    NSString *line1 = @"First and foremost, We thank God, our Lord, for the fruition of this work.\n<i>For of him, and through him, and to him, are all things: to whom be glory for ever. Amen.</i> - Romans 11:36";
    
    NSString *cat2 = @"The Bible";
    NSString *party2 = @"\bGetBible.net";
    NSString *line2 = @"The file for the Bible (in King James Version) used in this app is obtained from the website - https://getbible.net. We thank them for their generosity in providing this service for us and the community with no hindrances.";
    
    NSString *cat3 = @"\bConfessions, Forms and Church Order";
    NSString *party3 = @"\bProtestant Reformed Churches of America (PRCA)";
    NSString *line3 = @"The Confessions, Forms and Church Order in this app were obtained from the website of the Protestant Reformed Churches of America (PRCA) - http://www.prca.org";
    
    NSString *cat4 = @"Music for the Psalters";
    NSString *party4 = @"\bProtestant Reformed Churches of America (PRCA)";
    NSString *line4 = @"The music for the psalters in this app were obtained from the website of the Protestant Reformed Churches of America (PRCA) - http://www.prca.org";
    
    NSString *cat5 = @"Cross References for the Psalms";
    NSString *party5 = @"\bBible Study Tools";
    NSString *line5 = @"The cross references for the Psalms were obtained from http://www.biblestudytools.com/ using the English Standard Version (ESV) of the Bible";
    
    NSString *cat6 = @"\bIcons";
    NSString *party6 = @"\bIcons 8";
    NSString *line6 = @"Book Icons at the Tab Bar were obtained from https://icons8.com, with a \"Creative Commons Attribution-NoDerivs 3.0 Unported\" licence";
    
    NSString *cat7 = @"\bFont for \"The Psalter\"";
    NSString *party7 = @"\b1001 Fonts";
    NSString *line7 = @"The font name is \"Durwent\" and was obtained from http://www.1001fonts.com, with a \"1001Fonts Free For Commercial Use License (FFC)\" licence";
    
    NSString *cat8 = @"\bApp Icon";
    NSString *party8 = @"\bAppicon.build";
    NSString *line8 = @"The App Icon was generated from http://appicon.build";
    
    NSString *cat9 = @"\bScreenshots wrapped in iPhones/iPad";
    NSString *party9 = @"\bMockuPhone";
    NSString *line9 = @"The screenshots on the website were generated from http://mockuphone.com";
    
    NSString *cat10 = @"\bBeta Testers";
    NSString *party10 = @"\bSelect Individuals";
    NSString *line10 = @"We would also like to thank the beta testers for testing the app so that you get as little problems as possible in using this app - You know who you are 😄.";
    
    NSString *cat11 = @"\bInspiration & Audio Files";
    NSString *party11 = @"\bCornelius Boon";
    NSString *line11 = @"Cornelius Boon is the creator of the Psalter app for a different platform and contributor of the audio files with reduced file size";
    
    NSString *cat12 = @"\bPsalter Scores";
    NSString *party12 = @"\bGoogle";
    NSString *line12 = @"The original book is in public domain, having its copyright expired, and was digitized by Google.";
    
    
    NSArray *array = @[intro, n, n, n, cat1, n, party1, n, line1, n, n, n, cat11, n, n, source, party11, n, n,  line11, n, n, n, cat10, n, n, source, party10, n, n,  line10, n, n, n, cat2, n, n, source, party2, n, n,  line2, n, n, n, cat3, n, n, source, party3, n, n, line3, n, n, n, cat12, n, n, source, party12, n, n, line12, n, n, n, cat4, n, n, source, party4, n, n,  line4, n, n, n, cat5, n, n, source, party5, n, n, line5, n, n, n, cat6, n, n, source, party6, n, n, line6, n, n, n, cat7, n, n, source, party7, n, n, line7,  n, n, n, cat8, n, n, source, party8, n, n, line8,  n, n, n, cat9, n, n, source, party9, n, n, line9];
    
    self.textView.text = [array componentsJoinedByString:@""];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableParagraphStyle *paragraphStyleJ = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyleJ setAlignment:NSTextAlignmentJustified];
    
    
    NSMutableAttributedString *attributedString = [self.textView.attributedText mutableCopy];
    
    UIFont *font = [UIFont boldSystemFontOfSize:self.textView.font.pointSize * 1.2];
    
    NSDictionary *attDict = @{
                              NSFontAttributeName:font,
                              NSParagraphStyleAttributeName:paragraphStyle,
                              NSForegroundColorAttributeName: [UIColor whiteColor]
                              };
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat1];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat2];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat3];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat4];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat5];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat6];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat7];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat8];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat9];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat10];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat11];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:cat12];
    
    font = [UIFont boldSystemFontOfSize:self.textView.font.pointSize * 1.0];
    
    attDict = @{
                NSFontAttributeName:font,
                NSParagraphStyleAttributeName:paragraphStyle,
                NSForegroundColorAttributeName: [UIColor whiteColor]
                };
    
    
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party1];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party2];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party3];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party4];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party5];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party6];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party7];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party8];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party9];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party10];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party11];
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText:party12];
    
    font = [UIFont italicSystemFontOfSize:self.textView.font.pointSize * 1.0];
    
    attDict = @{
                NSFontAttributeName:font,
                NSParagraphStyleAttributeName:paragraphStyleJ,
                NSForegroundColorAttributeName: [UIColor whiteColor]
                };
    
    [self formatTextforAttributedText:attributedString withAttDict:attDict forText1:@"<i>" forText2:@"</i>"];
    
    self.textView.attributedText = attributedString;
    
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
        //
    }
}

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
        self.textView.text = nil;
        [self loadTextView];
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
    self.textView.text = nil;
    [self loadTextView];
    
    
}



@end
