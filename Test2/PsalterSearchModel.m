//
//  psalterSearchModel.m
//  Test2
//
//  Created by Not For You to Use on 23/04/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "psalterSearchModel.h"
#import "PsalterData.h"

@interface PsalterSearchModel () 
@property (nonatomic, strong) PsalterData *psalterData;
@end

@implementation PsalterSearchModel

- (instancetype)init{
    self = [super init];
    if (self) {
        self.psalterData = [[PsalterData alloc] init];
    
    }
    return self;

}

/*- (PsalterData *)psalterData {
    if(!_psalterData) _psalterData = [[PsalterData alloc]init];
    return _psalterData;
}*/



-(void)searchPsalterWithString:(NSString *)string{
    NSMutableArray *searchRequestContentMArray = [[NSMutableArray alloc]init];
    NSMutableArray *searchRequestTitleMArray = [[NSMutableArray alloc]init];
    
    
    for (NSString *key in self.psalterData){
        for(NSString *keyInKey in [self.psalterData valueForKeyPath:key]){
            NSLog(@"keyInKey = %@", keyInKey);
            // work on removing unicode values
            NSString *psalterSearchCandidate = [[[self.psalterData valueForKeyPath:key]valueForKeyPath:keyInKey]stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            //self.candidate = [[[self.psalterData valueForKeyPath:key] valueForKeyPath:keyInKey]stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
            
            [self loopySearchForSearchCandidate:psalterSearchCandidate forString:string forContentMutableArray:searchRequestContentMArray forTitleMutableArray:searchRequestTitleMArray forKey:key];
        }
    }
  
    if ([searchRequestContentMArray count]){
    self.searchResults = [searchRequestContentMArray copy];
    self.searchTitleResults = [searchRequestTitleMArray copy];
    }
    NSLog(@"self.searchResults = %@", self.searchResults);
    NSLog(@"searchResultsMArray = %@", searchRequestContentMArray);
    
    
}



- (void)loopySearchForSearchCandidate:candidate forString:(NSString *)string forContentMutableArray:(NSMutableArray *)contentMutableArray forTitleMutableArray:(NSMutableArray *)titleMutableArray forKey:(NSString *)key{
    
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", string];
    BOOL match = [myPredicate evaluateWithObject:candidate];
    NSLog(match ? @"match = Yes" : @"match = No");
    
    if (match == YES){
        NSRange range = [candidate rangeOfString:string options:NSCaseInsensitiveSearch];
        [self loopySearchStringLength:candidate forSearchString:string forArray:contentMutableArray forRange:range];
        NSLog(@"range.location = %lu, range.length = %lu", (unsigned long)range.location, (unsigned long)range.length);
        
        NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
        [titleMutableArray addObject:psalterSearchResultsTitle];
        
        NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
        NSLog(@"searchRequestMArray = %@",contentMutableArray);
        // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
        
        //Episode 2
        NSString *candidate2 = [candidate substringFromIndex:range.location + range.length];
        NSLog(@"candidate2 = %@", candidate2);
        BOOL match2 = [myPredicate evaluateWithObject:candidate2];
        NSLog(match2 ? @"match2 = Yes" : @"match2 = No");
        
        if (match2 == YES){
            NSRange range = [candidate2 rangeOfString:string options:NSCaseInsensitiveSearch];
            [self loopySearchStringLength:candidate2 forSearchString:string forArray:contentMutableArray forRange:range];
            
            NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
            [titleMutableArray addObject:psalterSearchResultsTitle];
            
            NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
            NSLog(@"searchRequestMArray = %@",contentMutableArray);            // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
            
            //End of episode 2
            
            //Episode 3
            NSString *candidate3 = [candidate2 substringFromIndex:range.location + range.length];
            NSLog(@"candidate3 = %@", candidate3);
            BOOL match3 = [myPredicate evaluateWithObject:candidate3];
            NSLog(match3 ? @"match3 = Yes" : @"match3 = No");
            
            if (match3 == YES){
                NSRange range = [candidate3 rangeOfString:string options:NSCaseInsensitiveSearch];
                [self loopySearchStringLength:candidate3 forSearchString:string forArray:contentMutableArray forRange:range];
                
                NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                [titleMutableArray addObject:psalterSearchResultsTitle];
                NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                NSLog(@"searchRequestMArray = %@",contentMutableArray);
                // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                
                //End of episode 3
                
                //Episode 4
                NSString *candidate4 = [candidate3 substringFromIndex:range.location+range.length];
                NSLog(@"candidate4 = %@", candidate4);
                BOOL match4 = [myPredicate evaluateWithObject:candidate4];
                NSLog(match4 ? @"match4 = Yes" : @"match4 = No");
                
                if (match4 == YES){
                    NSRange range = [candidate4 rangeOfString:string options:NSCaseInsensitiveSearch];
                    [self loopySearchStringLength:candidate4 forSearchString:string forArray:contentMutableArray forRange:range];
                    
                    NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                    [titleMutableArray addObject:psalterSearchResultsTitle];
                    
                    NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                    NSLog(@"searchRequestMArray = %@",contentMutableArray);
                    // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                    
                    //End of episode 4
                    
                    //Episode 5
                    NSString *candidate5 = [candidate4 substringFromIndex:range.location+range.length];
                    NSLog(@"candidate5 = %@", candidate5);
                    BOOL match5 = [myPredicate evaluateWithObject:candidate5];
                    NSLog(match5 ? @"match5 = Yes" : @"match5 = No");
                    
                    if (match5 == YES){
                        NSRange range = [candidate5 rangeOfString:string options:NSCaseInsensitiveSearch];
                        [self loopySearchStringLength:candidate5 forSearchString:string forArray:contentMutableArray forRange:range];
                        
                        NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                        [titleMutableArray addObject:psalterSearchResultsTitle];
                        
                        NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                        NSLog(@"searchRequestMArray = %@",contentMutableArray);
                        // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                        
                        //End of episode 5
                        
                        //Episode 6
                        NSString *candidate6 = [candidate5 substringFromIndex:range.location+range.length];
                        NSLog(@"candidate6 = %@", candidate6);
                        BOOL match6 = [myPredicate evaluateWithObject:candidate6];
                        NSLog(match6 ? @"match6 = Yes" : @"match6 = No");
                        
                        if (match6 == YES){
                            NSRange range = [candidate6 rangeOfString:string options:NSCaseInsensitiveSearch];
                            [self loopySearchStringLength:candidate6 forSearchString:string forArray:contentMutableArray forRange:range];
                            
                            NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                            [titleMutableArray addObject:psalterSearchResultsTitle];
                            
                            NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                            NSLog(@"searchRequestMArray = %@",contentMutableArray);
                            // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                            
                            //End of episode 6
                            
                            //Episode 7
                            NSString *candidate7 = [candidate6 substringFromIndex:range.location+range.length];
                            NSLog(@"candidate7 = %@", candidate7);
                            BOOL match7 = [myPredicate evaluateWithObject:candidate7];
                            NSLog(match7 ? @"match7 = Yes" : @"match7 = No");
                            
                            if (match7 == YES){
                                NSRange range = [candidate7 rangeOfString:string options:NSCaseInsensitiveSearch];
                                [self loopySearchStringLength:candidate7 forSearchString:string forArray:contentMutableArray forRange:range];
                                
                                NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                [titleMutableArray addObject:psalterSearchResultsTitle];
                                
                                NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                
                                //End of episode 7
                                
                                //Episode 8
                                NSString *candidate8 = [candidate7 substringFromIndex:range.location+range.length];
                                NSLog(@"candidate8 = %@", candidate8);
                                BOOL match8 = [myPredicate evaluateWithObject:candidate8];
                                NSLog(match8 ? @"match8 = Yes" : @"match8 = No");
                                
                                if (match8 == YES){
                                    NSRange range = [candidate8 rangeOfString:string options:NSCaseInsensitiveSearch];
                                    [self loopySearchStringLength:candidate8 forSearchString:string forArray:contentMutableArray forRange:range];
                                    
                                    NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                    [titleMutableArray addObject:psalterSearchResultsTitle];
                                    
                                    NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                    NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                    // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                    
                                    //End of episode 8
                                    
                                    //Episode 9
                                    NSString *candidate9 = [candidate8 substringFromIndex:range.location+range.length];
                                    NSLog(@"candidate9 = %@", candidate9);
                                    BOOL match9 = [myPredicate evaluateWithObject:candidate9];
                                    NSLog(match9 ? @"match9 = Yes" : @"match9 = No");
                                    
                                    if (match9 == YES){
                                        NSRange range = [candidate9 rangeOfString:string options:NSCaseInsensitiveSearch];
                                        [self loopySearchStringLength:candidate9 forSearchString:string forArray:contentMutableArray forRange:range];
                                        
                                        NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                        [titleMutableArray addObject:psalterSearchResultsTitle];
                                        
                                        NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                        NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                        // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                        
                                        //End of episode 9
                                        
                                        //Episode 10
                                        NSString *candidate10 = [candidate9 substringFromIndex:range.location+range.length];
                                        NSLog(@"candidate10 = %@", candidate10);
                                        BOOL match10 = [myPredicate evaluateWithObject:candidate10];
                                        NSLog(match10 ? @"match10 = Yes" : @"match10 = No");
                                        
                                        if (match10 == YES){
                                            NSRange range = [candidate10 rangeOfString:string options:NSCaseInsensitiveSearch];
                                            [self loopySearchStringLength:candidate10 forSearchString:string forArray:contentMutableArray forRange:range];
                                            
                                            NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                            [titleMutableArray addObject:psalterSearchResultsTitle];
                                            
                                            NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                            NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                            // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                            
                                            //End of episode 10
                                            
                                            //Episode 11
                                            NSString *candidate11 = [candidate10 substringFromIndex:range.location+range.length];
                                            NSLog(@"candidate11 = %@", candidate11);
                                            BOOL match11 = [myPredicate evaluateWithObject:candidate11];
                                            NSLog(match11 ? @"match11 = Yes" : @"match11 = No");
                                            
                                            if (match11 == YES){
                                                NSRange range = [candidate11 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                [self loopySearchStringLength:candidate11 forSearchString:string forArray:contentMutableArray forRange:range];
                                                
                                                NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                [titleMutableArray addObject:psalterSearchResultsTitle];
                                                
                                                NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                
                                                //End of episode 11
                                                
                                                //Episode 12
                                                NSString *candidate12 = [candidate11 substringFromIndex:range.location+range.length];
                                                NSLog(@"candidate12 = %@", candidate12);
                                                BOOL match12 = [myPredicate evaluateWithObject:candidate12];
                                                NSLog(match12 ? @"match12 = Yes" : @"match12 = No");
                                                
                                                if (match12 == YES){
                                                    NSRange range = [candidate12 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                    [self loopySearchStringLength:candidate12 forSearchString:string forArray:contentMutableArray forRange:range];
                                                    
                                                    NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                    [titleMutableArray addObject:psalterSearchResultsTitle];
                                                    
                                                    NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                    NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                    // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                    
                                                    //End of episode 12
                                                    
                                                    //Episode 13
                                                    NSString *candidate13 = [candidate12 substringFromIndex:range.location+range.length];
                                                    NSLog(@"candidate13 = %@", candidate13);
                                                    BOOL match13 = [myPredicate evaluateWithObject:candidate13];
                                                    NSLog(match13 ? @"match13 = Yes" : @"match13 = No");
                                                    
                                                        if (match13 == YES){
                                                            NSRange range = [candidate13 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                            [self loopySearchStringLength:candidate13 forSearchString:string forArray:contentMutableArray forRange:range];
                                                            
                                                            NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                            [titleMutableArray addObject:psalterSearchResultsTitle];
                                                            
                                                            NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                            NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                            // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                            
                                                            //End of episode 13
                                                            
                                                            //Episode 14
                                                            NSString *candidate14 = [candidate13 substringFromIndex:range.location+range.length];
                                                            NSLog(@"candidate14 = %@", candidate14);
                                                            BOOL match14 = [myPredicate evaluateWithObject:candidate14];
                                                            NSLog(match14 ? @"match14 = Yes" : @"match14 = No");
                                                            
                                                            if (match14 == YES){
                                                                NSRange range = [candidate14 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                [self loopySearchStringLength:candidate14 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                
                                                                NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                
                                                                NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                
                                                                //End of episode 14
                                                                
                                                                //Episode 15
                                                                NSString *candidate15 = [candidate14 substringFromIndex:range.location+range.length];
                                                                NSLog(@"candidate15 = %@", candidate15);
                                                                BOOL match15 = [myPredicate evaluateWithObject:candidate15];
                                                                NSLog(match15 ? @"match15 = Yes" : @"match15 = No");
                                                                
                                                                if (match15 == YES){
                                                                    NSRange range = [candidate15 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                    [self loopySearchStringLength:candidate15 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                    
                                                                    NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                    [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                    
                                                                    NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                    NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                    // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                    
                                                                    //End of episode 15
                                                                    
                                                                    //Episode 16
                                                                    NSString *candidate16 = [candidate15 substringFromIndex:range.location+range.length];
                                                                    NSLog(@"candidate16 = %@", candidate16);
                                                                    BOOL match16 = [myPredicate evaluateWithObject:candidate16];
                                                                    NSLog(match16 ? @"match16 = Yes" : @"match16 = No");
                                                                    
                                                                    if (match16 == YES){
                                                                        NSRange range = [candidate16 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                        [self loopySearchStringLength:candidate16 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                        
                                                                        NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                        [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                        
                                                                        NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                        NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                        // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                        
                                                                        //End of episode 16
                                                                        
                                                                        //Episode 17
                                                                        NSString *candidate17 = [candidate16 substringFromIndex:range.location+range.length];
                                                                        NSLog(@"candidate17 = %@", candidate17);
                                                                        BOOL match17 = [myPredicate evaluateWithObject:candidate17];
                                                                        NSLog(match17 ? @"match17 = Yes" : @"match17 = No");
                                                                        
                                                                        if (match17 == YES){
                                                                            NSRange range = [candidate17 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                            [self loopySearchStringLength:candidate17 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                            
                                                                            NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                            [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                            
                                                                            NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                            NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                            // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                            
                                                                            //End of episode 17
                                                                            
                                                                            //Episode 18
                                                                            NSString *candidate18 = [candidate17 substringFromIndex:range.location+range.length];
                                                                            NSLog(@"candidate18 = %@", candidate18);
                                                                            BOOL match18 = [myPredicate evaluateWithObject:candidate18];
                                                                            NSLog(match18 ? @"match18 = Yes" : @"match18 = No");
                                                                            
                                                                            if (match18 == YES){
                                                                                NSRange range = [candidate18 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                                [self loopySearchStringLength:candidate18 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                                
                                                                                NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                                [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                                
                                                                                NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                                NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                                // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                                
                                                                                //End of episode 18
                                                                                
                                                                                //Episode 19
                                                                                NSString *candidate19 = [candidate18 substringFromIndex:range.location+range.length];
                                                                                NSLog(@"candidate19 = %@", candidate19);
                                                                                BOOL match19 = [myPredicate evaluateWithObject:candidate19];
                                                                                NSLog(match19 ? @"match19 = Yes" : @"match19 = No");
                                                                                
                                                                                if (match19 == YES){
                                                                                    NSRange range = [candidate19 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                                    [self loopySearchStringLength:candidate19 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                                    
                                                                                    NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                                    [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                                    
                                                                                    NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                                    NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                                    // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                                    
                                                                                    //End of episode 19
                                                                                    
                                                                                    //Episode 20
                                                                                    NSString *candidate20 = [candidate19 substringFromIndex:range.location+range.length];
                                                                                    NSLog(@"candidate20 = %@", candidate20);
                                                                                    BOOL match20 = [myPredicate evaluateWithObject:candidate20];
                                                                                    NSLog(match20 ? @"match20 = Yes" : @"match20 = No");
                                                                                    
                                                                                    if (match20 == YES){
                                                                                        NSRange range = [candidate20 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                                        [self loopySearchStringLength:candidate20 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                                        
                                                                                        NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                                        [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                                        
                                                                                        NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                                        NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                                        // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                                        
                                                                                        //End of episode 20
                                                                                        
                                                                                        //Episode 21
                                                                                        NSString *candidate21 = [candidate20 substringFromIndex:range.location+range.length];
                                                                                        NSLog(@"candidate21 = %@", candidate21);
                                                                                        BOOL match21 = [myPredicate evaluateWithObject:candidate21];
                                                                                        NSLog(match21 ? @"match21 = Yes" : @"match21 = No");
                                                                                        
                                                                                        if (match21 == YES){
                                                                                            NSRange range = [candidate21 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                                            [self loopySearchStringLength:candidate21 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                                            
                                                                                            NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                                            [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                                            
                                                                                            NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                                            NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                                            // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                                            
                                                                                            //End of episode 21
                                                                                            
                                                                                            //Episode 22
                                                                                            NSString *candidate22 = [candidate21 substringFromIndex:range.location+range.length];
                                                                                            NSLog(@"candidate22 = %@", candidate22);
                                                                                            BOOL match22 = [myPredicate evaluateWithObject:candidate22];
                                                                                            NSLog(match22 ? @"match22 = Yes" : @"match22 = No");
                                                                                            
                                                                                            if (match22 == YES){
                                                                                                NSRange range = [candidate22 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                                                [self loopySearchStringLength:candidate22 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                                                
                                                                                                NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                                                [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                                                
                                                                                                NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                                                NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                                                // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                                                
                                                                                                //End of episode 22
                                                                                                
                                                                                                //Episode 23
                                                                                                NSString *candidate23 = [candidate22 substringFromIndex:range.location+range.length];
                                                                                                NSLog(@"candidate23 = %@", candidate23);
                                                                                                BOOL match23 = [myPredicate evaluateWithObject:candidate23];
                                                                                                NSLog(match23 ? @"match23 = Yes" : @"match23 = No");
                                                                                                
                                                                                                if (match23 == YES){
                                                                                                    NSRange range = [candidate23 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                                                    [self loopySearchStringLength:candidate23 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                                                    
                                                                                                    NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                                                    [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                                                    
                                                                                                    NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                                                    NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                                                    // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                                                    
                                                                                                    //End of episode 23
                                                                                                    
                                                                                                    //Episode 24
                                                                                                    NSString *candidate24 = [candidate23 substringFromIndex:range.location+range.length];
                                                                                                    NSLog(@"candidate24 = %@", candidate24);
                                                                                                    BOOL match24 = [myPredicate evaluateWithObject:candidate24];
                                                                                                    NSLog(match24 ? @"match24 = Yes" : @"match24 = No");
                                                                                                    
                                                                                                    if (match24 == YES){
                                                                                                        NSRange range = [candidate24 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                                                        [self loopySearchStringLength:candidate24 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                                                        
                                                                                                        NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                                                        [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                                                        
                                                                                                        NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                                                        NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                                                        // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                                                        
                                                                                                        //End of episode 24
                                                                                                        
                                                                                                        //Episode 25
                                                                                                        NSString *candidate25 = [candidate24 substringFromIndex:range.location+range.length];
                                                                                                        NSLog(@"candidate25 = %@", candidate25);
                                                                                                        BOOL match25 = [myPredicate evaluateWithObject:candidate25];
                                                                                                        NSLog(match25 ? @"match25 = Yes" : @"match25 = No");
                                                                                                        
                                                                                                        if (match25 == YES){
                                                                                                            NSRange range = [candidate25 rangeOfString:string options:NSCaseInsensitiveSearch];
                                                                                                            [self loopySearchStringLength:candidate25 forSearchString:string forArray:contentMutableArray forRange:range];
                                                                                                            
                                                                                                            NSString *psalterSearchResultsTitle = [NSString stringWithFormat:@"Psalter %@",key];
                                                                                                            [titleMutableArray addObject:psalterSearchResultsTitle];
                                                                                                            
                                                                                                            NSLog(@"searchRequestTitleMArray = %@",titleMutableArray);
                                                                                                            NSLog(@"searchRequestMArray = %@",contentMutableArray);
                                                                                                            // NSLog(@"psalterSearchCandidate = %@", psalterSearchCandidate);
                                                                                                            
                                                                                                            //End of episode 25
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                            
                                                                                                        }
                                                                                                        
                                                                                                    }}}}}}}}}}}}}}}}}}}}}}}}}


- (void) loopySearchStringLength:(NSString *)newCandidate forSearchString:(NSString *)string forArray:(NSMutableArray *)contentMutableArray forRange:(NSRange)range
{
    if (range.location <= 10) {
        if(newCandidate.length >=100){
            NSString *searchResultString = [NSString stringWithFormat:@"...%@...",[[newCandidate substringFromIndex:0] substringToIndex:100]];
            
            [contentMutableArray addObjectsFromArray:@[searchResultString]];
            
            NSLog(@"searchResultString = %@, range.location = %lu", searchResultString, (unsigned long)range.location);
        } else {
            NSString *searchResultString = [NSString stringWithFormat:@"...%@",[newCandidate substringFromIndex:0]];
            [contentMutableArray addObjectsFromArray:@[searchResultString]];
            
            NSLog(@"searchResultString = %@, range.location = %lu", searchResultString, (unsigned long)range.location);
        }
        
        
    } else {
        if( newCandidate.length  <= range.location +90){
            NSString *searchResultString = [NSString stringWithFormat:@"...%@",
                                            [newCandidate substringFromIndex:range.location -10]];
            
            [contentMutableArray addObjectsFromArray:@[searchResultString]];
            
            
            NSLog(@"searchResultString = %@, range.location =%lu, psaltersearchcandidate.length = %lu, range.location +45 = %lu", searchResultString, (unsigned long)range.location, (unsigned long)newCandidate.length, (unsigned long)range.location +90);
            
        } else {
            NSString *searchResultString = [NSString stringWithFormat:@"...%@...",
                                            [[newCandidate substringFromIndex:range.location -10]
                                             substringToIndex:100]];
            
            [contentMutableArray addObjectsFromArray:@[searchResultString]];
            
            NSLog(@"searchResultString = %@, range.location =%lu, psaltersearchcandidate.length = %lu, range.location +45 = %lu", searchResultString, (unsigned long)range.location, (unsigned long)newCandidate.length, (unsigned long)range.location +45);
            
        }
        
    }
    
}







@end
