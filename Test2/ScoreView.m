//
//  ScoreView.m
//  The Psalter
//
//  Created by Not For You to Use on 28/09/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "ScoreView.h"
#import "ScoreModel.h"


@implementation ScoreView



- (void)myDisplayPDFPage:(CGContextRef)myContext forPage:(NSInteger)integer
{
    
    size_t pageNumber = integer;
    CGPDFPageRef page;
    
    CGPDFDocumentRef document = [ScoreModel myGetPDFDocumentRef];
    
    page = CGPDFDocumentGetPage (document, pageNumber);
    
    CGRect rect = [ScoreModel pdfRect:16];
    
    CGContextScaleCTM(myContext, self.bounds.size.width / rect.size.width, -(self.bounds.size.width / rect.size.width)); //(self.bounds.size.width / pdfRect.size.width)
    
    CGContextTranslateCTM(myContext, 0, -(self.bounds.size.height) * 1/(self.bounds.size.width / rect.size.width));
    
    CGContextDrawPDFPage (myContext, page);
    
    CGPDFDocumentRelease (document);
    
}


- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, rect);
    
    [self myDisplayPDFPage:context forPage:self.pageInt];
    
    
   
    UIGraphicsEndImageContext();
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
