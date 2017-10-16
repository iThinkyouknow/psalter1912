//
//  ScoreModel.m
//  The Psalter
//
//  Created by Not For You to Use on 28/09/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "ScoreModel.h"

@implementation ScoreModel
+(CGPDFDocumentRef)myGetPDFDocumentRef
{
    
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"The_Psalter_PDF"
                                                           ofType:@"pdf"];
    NSURL *url = [NSURL fileURLWithPath:pathString];
    CFURLRef cfURL = (__bridge CFURLRef)(url);
    
    
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL (cfURL);
    
    
    //size_t count = CGPDFDocumentGetNumberOfPages (document);
    
    
    
    
    return document;
    //    CFRelease (cfURL);
}

+(CGRect)pdfRect:(NSInteger)pageInt {
    
    size_t pageNumber = pageInt;
    
    CGPDFDocumentRef document = [[self class] myGetPDFDocumentRef];;
    CGPDFPageRef page = CGPDFDocumentGetPage (document, pageNumber);
    
    CGRect rect = CGPDFPageGetBoxRect(page, kCGPDFArtBox);
    
    
    CGPDFDocumentRelease (document);
    
    
    return rect;
}

@end
