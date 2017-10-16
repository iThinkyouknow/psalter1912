//
//  ViewController.m
//  Test2
//
//  Created by Not For You to Use on 25/03/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "ViewController.h"
#import "SearchModel.h"
#import "AudioPlayer.h"
#import "BibleContentVC.h"
#import "PsalterModel.h"
#import "SplitViewSelectionTVC.h"
#import "PsalterStatistics.h"
#import "Settings.h"

@interface ViewController () <UITextViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate>
@property NSArray *psalterNumbers;
@property (strong) NSComparator stringSorter;
@property (weak, nonatomic) IBOutlet UITextView *psalterText;
@property (weak, nonatomic) IBOutlet UITextField *psalterInput;
@property (weak, nonatomic) IBOutlet UINavigationItem *psalterViewTitle;
@property (nonatomic) int senderInt;
@property (nonatomic, strong) UIBarButtonItem *rightFixed;
@property (nonatomic, strong) UIToolbar *keyboardDoneButtonView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTV;
@property (strong, nonatomic) UINavigationBar *searchResultsNavBar;
@property (strong, nonatomic) NSString *searchRequest;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolBar;
@property (strong, nonatomic) SearchModel *searchModel;
@property (weak, nonatomic) IBOutlet UIView *extraInfoView;
@property (weak, nonatomic) IBOutlet UIView *tapToCancelView;
@property (weak, nonatomic) IBOutlet UITextView *referencesTextV;
@property (weak, nonatomic) IBOutlet UILabel *playTimerLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapOnce;
@property (strong, nonatomic) AudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *extraInfoButton;
@property (nonatomic, strong) PsalterModel *psalterModel;
@property (nonatomic, readwrite) NSInteger psalmRef;
@property (nonatomic, readwrite) NSInteger scoreRef;
@property (nonatomic, readwrite) NSInteger psalterRef;
@property (weak, nonatomic) IBOutlet UIImageView *psalterTitleImage;
@property (nonatomic, strong) NSString *psalmRefString;
@property (nonatomic) CGFloat defaultFontSize;
@property (nonatomic, strong) NSTimer *timerForSingCount;
@property (nonatomic) BOOL shouldAddCount;

@property (nonatomic, strong) PsalterStatistics *statistics;
@property (weak, nonatomic) IBOutlet UILabel *timesSungLabel;





@end

@implementation ViewController

@synthesize searchResultsNavBar = _searchResultsNavBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.splitViewController){
        
        self.navigationBar.topItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationBar.topItem.leftItemsSupplementBackButton = YES;
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    self.searchButton.tintColor = [UIColor whiteColor];
    self.psalterModel = [[PsalterModel alloc] init];
    self.searchModel = [[SearchModel alloc]init];
    [self registerForKeyboardNotifications];
    [self registerForOrientationNotification];
    [self setAccessoryView];
    
    self.psalterInput.delegate = self;
    
    self.searchResultsTV.delegate = self;
    self.searchResultsTV.dataSource = self;
    self.defaultFontSize = [Settings defaultFontSize];
    self.psalterText.font = [UIFont systemFontOfSize:self.defaultFontSize];
    self.statistics = [[PsalterStatistics alloc] init];
    
    self.shouldAddCount = YES;
    
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [self becomeFirstResponder];
    
//        [self.psalterModel getPsalterContentForPsalmRefString:self.psalmRefString];
        [self loadPage];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.timerForSingCount invalidate];
}



#pragma mark UI Methods
- (UINavigationBar *)searchResultsNavBar
{
    if (!_searchResultsNavBar) {
        
        _searchResultsNavBar = [[UINavigationBar alloc ]initWithFrame:CGRectMake(self.navigationBar.bounds.origin.x,
                                                                                 self.navigationBar.bounds.origin.y,
                                                                                 self.view.bounds.size.width,
                                                                                 self.navigationBar.bounds.size.height)];
        
        UINavigationItem *searchTitleView = [[UINavigationItem alloc] init];
        
        searchTitleView.title= [NSString stringWithFormat:@"%lu Match(es)", (unsigned long)[self.searchModel.psalterSearchResults count]];
        
        _searchResultsNavBar.titleTextAttributes = self.navigationBar.titleTextAttributes;
        [_searchResultsNavBar setItems:@[searchTitleView]];
        
        if([_searchResultsNavBar respondsToSelector:@selector(barTintColor)]){
            
            _searchResultsNavBar.barTintColor = self.navigationBar.barTintColor;
            
        } else {
            
            _searchResultsNavBar.tintColor = self.navigationBar.tintColor;
            
        }
        
        _searchResultsNavBar.alpha = self.navigationBar.alpha;
        
    }
    
    return _searchResultsNavBar;
}



- (void)navigationBarAddSubviewForSearch
{
    self.navigationBar.autoresizesSubviews = YES;
    
    [self.navigationBar addSubview:self.searchResultsNavBar];
    
}


- (void)navigationBarSetSubviewForSearch
{
    
    [_searchResultsNavBar setFrame:CGRectMake(self.navigationBar.bounds.origin.x,
                                              self.navigationBar.bounds.origin.y,
                                              self.view.bounds.size.width,
                                              self.navigationBar.bounds.size.height)];
    
    UINavigationItem *searchTitleView = [[UINavigationItem alloc] init];
    searchTitleView.title= [NSString stringWithFormat:@"%lu Match(es)", (unsigned long)[self.searchModel.psalterSearchResults count]];
    
    
    [_searchResultsNavBar setItems:@[searchTitleView]];
}


- (UIBarButtonItem *)rightFixed{
    if (_rightFixed == nil){
        _rightFixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                    target:self action:nil];
    } return _rightFixed;
}

- (void)animationToShowHideTableView:(UITableView *)tableView show:(BOOL)show
{
    CATransition *transition2 = nil;
    transition2 = [CATransition animation];
    transition2.duration = 0.5f;//kAnimationDuration
    transition2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition2.type = show ? kCAFillModeForwards : kCAFillModeBackwards;
    transition2.delegate = self;
    tableView.alpha = show? 0.95 : 0;
    
    [tableView.layer addAnimation:transition2 forKey:nil];
    
    tableView.hidden = show ? NO : YES;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)animationToShowHideExtraInfoView:(UIView *)view show:(BOOL)show
{
    self.extraInfoView.layer.cornerRadius = 0.025 * self.extraInfoView.bounds.size.width;
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.2f;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = show ? kCAFillModeForwards : kCAFillModeBackwards;
    transition.delegate = self;
    view.alpha = show? 0.95 : 0;
    
    [view.layer addAnimation:transition forKey:nil];
    
    view.hidden = show ? NO : YES;
    self.tapToCancelView.hidden = show ? NO:YES;
}

- (void) animationForLoadingText {
    CATransition *transition = nil;
    transition = [CATransition animation];
    transition.duration = 0.5f;//kAnimationDuration
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    //transition.subtype =kCATransitionFromTop;
    transition.delegate = self;
    [self.psalterText.layer addAnimation:transition forKey:nil];
}

- (void)loadPage {
    if(self.psalterModel.psalterContent != nil){
        
        //titlename, psalm, meter, content
        self.psalterText.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n\n%@", self.psalterModel.psalterTitle,self.psalterModel.psalterTitleName, self.psalterModel.psalterPsalmNumberString, self.psalterModel.psalterMeter, self.psalterModel.psalterContent];
        
        [self formattPage];
        
        self.psalterViewTitle.title = self.psalterModel.psalterTitle;
        self.psalmRef = self.psalterModel.psalmRefInt;
        
        self.psalterRef = [[self.psalterViewTitle.title stringByReplacingOccurrencesOfString:@"Psalter " withString:@""] integerValue];
        self.scoreRef = [self.psalterModel getScorePageForPsalter:self.psalterRef];

        
        if(![self.psalterText.text isEqualToString:@""]){
            self.psalterTitleImage.hidden = YES;
            
            [self animationForLoadingText];
        }
        
        [self.psalterText setContentOffset:CGPointMake(0, 0) animated:NO];
        
        
        //start timer and all
        [self updateSingCount];
        
        if (self.extraInfoView.isHidden == NO) {
            
            [self updateExtraInfoView];
        }
        
        if (self.player){
            [self handleMusic];
        }
    }
}

- (void)updateSingCount {
    [self.timerForSingCount invalidate];
    
    if (self.shouldAddCount) {
    self.timerForSingCount = [NSTimer scheduledTimerWithTimeInterval:14.0 target:self selector:@selector(singCountUpdated) userInfo:nil repeats:NO];
    }
}

- (void)singCountUpdated {
    [self.statistics updateDictionaryFor:self.navigationBar.topItem.title];
    [self updateExtraInfoView];
    self.shouldAddCount = NO;
}


- (void)formattPage {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString *mutAttStr = [self.psalterText.attributedText mutableCopy];
    
    NSUInteger length = [mutAttStr length];
    NSRange range = NSMakeRange(0, length);
    
    
    range = [[mutAttStr string] rangeOfString:self.psalterModel.psalterTitle options:0 range:range];
    
    
    if (range.location != NSNotFound) {
        [mutAttStr
         setAttributes: @{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.psalterText.font.pointSize * 1.5],
                          NSParagraphStyleAttributeName:paragraphStyle,
                          NSForegroundColorAttributeName: [UIColor whiteColor]}
         range:range];
        
        range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
        
        NSUInteger location = range.location;
        
        range = [[mutAttStr string] rangeOfString:self.psalterModel.psalterPsalmNumberString options:0 range:range];
        
        [mutAttStr
         setAttributes: @{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.psalterText.font.pointSize * 1.2],
                          NSParagraphStyleAttributeName:paragraphStyle,
                          NSForegroundColorAttributeName: [UIColor whiteColor]}
         range:NSMakeRange(location, range.length + range.location)];
        
        range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
        
        range = [[mutAttStr string] rangeOfString:self.psalterModel.psalterMeter options:0 range:range];
        [mutAttStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.psalterText.font.pointSize * 0.7],
                                   NSParagraphStyleAttributeName:paragraphStyle,
                                   NSForegroundColorAttributeName: [UIColor whiteColor]
                                   }
                           range:range];
        
        
        range = NSMakeRange(0, 0);
        
    }
    self.psalterText.attributedText = mutAttStr;
}



#pragma mark Input Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}


- (IBAction)psalterInputEnd {
    
    
    //Search Logic
    if(self.searchButton.tintColor == [UIColor cyanColor]){
        
        if(self.psalterInput.text.length >= 3){
            
            self.searchRequest = self.psalterInput.text;
            [self.searchModel searchWithSearchString:self.searchRequest];
            
        } else {
            
            [self showSearchRequestWarning];
            
        }
        if ([self.searchModel.psalterSearchResults count] > 0) {
            
            self.psalterTitleImage.hidden = YES;
            [self navigationBarSetSubviewForSearch];
            
            if(self.searchResultsTV.hidden == YES){
                [self navigationBarAddSubviewForSearch];
                [self animationToShowHideTableView:self.searchResultsTV show:YES];
                [self.searchResultsTV reloadData];
                
            } else {
                [self.searchResultsTV reloadData];
            }
            
        } else {
            
        }
        //end of Search Logic
        
        //Start of Normal Logic
    } else {
        [self.psalterModel getPsalterContentForPsalterNumberString:self.psalterInput.text];
        
        if (self.psalterModel.shouldShowWarning == NO) {
        
        
        self.shouldAddCount = YES;
        [self loadPage];
        
        
        self.searchResultsTV.hidden = YES;
        [self.searchResultsTV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        
        
        } else {
            
            [self showPsalterNotAvailableWarning];
        }
        
        self.psalterInput.text = nil;
        
    }
}


- (IBAction)psalterInputBegin:(id)sender {
    self.psalterInput.text = nil;
    if(self.searchButton.tintColor == [UIColor cyanColor]) {
        
        self.psalterInput.keyboardType = UIKeyboardTypeDefault;
        
    } else if (self.searchButton.tintColor == [UIColor whiteColor]) {
        
        self.psalterInput.keyboardType = UIKeyboardTypeNumberPad;
        
    }
}


- (IBAction)swipeLeft:(id)sender
{
    //Do your action here-
    NSString *psalterNumberString = [self.psalterViewTitle.title stringByReplacingOccurrencesOfString:@"Psalter " withString:@""];
    
    [self.psalterModel getPsalterContentForSwipeLeft:psalterNumberString];
    self.shouldAddCount = YES;
    [self loadPage];
    
    
    
    
}


- (IBAction)swipeRight:(id)sender
{
    NSString *psalterNumberString = [self.psalterViewTitle.title stringByReplacingOccurrencesOfString:@"Psalter " withString:@""];
    [self.psalterModel getPsalterContentForSwipeRight:psalterNumberString];
    self.shouldAddCount = YES;
    [self loadPage];
    
    
    
}

- (IBAction)doneClicked:(id)sender
{
    [self.psalterInput endEditing:YES];
    [self psalterInputEnd];
}

- (IBAction)searchButtonTapped:(UIBarButtonItem *)sender {
    if (self.searchButton.tintColor == [UIColor whiteColor]) {
        self.searchButton.tintColor = [UIColor cyanColor];
        self.psalterInput.placeholder = @"Search";
        self.psalterInput.keyboardType = UIKeyboardTypeDefault;
        [self.psalterInput setReturnKeyType:UIReturnKeySearch];
        self.psalterInput.enablesReturnKeyAutomatically = NO;
        [self setAccessoryView];
        
        if ([self.searchModel.psalterSearchResults count]) {
            [self animationToShowHideTableView:self.searchResultsTV show:YES];
            [self navigationBarAddSubviewForSearch];
            
            if(self.psalterInput.isFirstResponder == YES){
                
                if(self.psalterInput.text !=nil){
                    self.psalterInput.text = nil;
                    [self.psalterInput resignFirstResponder];
                    [self.psalterInput becomeFirstResponder];
                    
                } else {
                    [self.psalterInput resignFirstResponder];
                    [self.psalterInput becomeFirstResponder];
                }
            }
            
        } else {
            
            if(self.psalterInput.text !=nil){
                self.psalterInput.text = nil;
                [self.psalterInput resignFirstResponder];
                [self.psalterInput becomeFirstResponder];
                
            } else {
                [self.psalterInput resignFirstResponder];
                [self.psalterInput becomeFirstResponder];
            }
        }
        
        
    } else if (self.searchButton.tintColor == [UIColor cyanColor]) {
        
        self.searchButton.tintColor = [UIColor whiteColor];
        self.psalterInput.placeholder = [NSString stringWithFormat:@"Key in Psalter # here (1-%d)", self.psalterModel.psalterCount];
        self.psalterInput.keyboardType = UIKeyboardTypeNumberPad;
        [self setAccessoryView];
        [_searchResultsNavBar removeFromSuperview];
        
        
        
        
        if([self.psalterInput isFirstResponder] == YES){
            if(self.psalterInput.text !=nil){
                self.psalterInput.text = nil;
                [self.psalterInput resignFirstResponder];
                [self.psalterInput becomeFirstResponder];
            } else {
                [self.psalterInput resignFirstResponder];
                [self.psalterInput becomeFirstResponder];
            }
        } else {
            
            [self animationToShowHideTableView:self.searchResultsTV show:NO];
            
        }
        
    }
}

- (BOOL)textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(self.searchButton.tintColor == [UIColor whiteColor]){
        
        //return yes or no after comparing the characters
        
        if(range.length + range.location > theTextField.text.length)
        {
            return NO;
        }
        
        // allow backspace
        if (!string.length)
        {
            return YES;
        }
        
        if ([string intValue] || [string isEqualToString:@"0"])
        {
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}

//delegate method
- (void)getPsalterDetailsWithPsalmRef:(NSString *)psalmRef{
    [self.psalterModel getPsalterContentForPsalmRefString:psalmRef];
    
    if (![self.psalmRefString isEqualToString:psalmRef]) {
        self.shouldAddCount = YES;
    }
    
    
    self.psalmRefString = psalmRef;
    [self loadPage];
    
    
}

- (void)getPsalterDetailsWithScoreRef:(NSInteger)scoreRef {
   
    
    NSInteger currentPsalterRef = self.psalterRef;
    
    
    [self.psalterModel getPsalterContentWithScorePage:scoreRef];
    
   
    
    if (currentPsalterRef != [[self.psalterModel.psalterTitle stringByReplacingOccurrencesOfString:@"Psalter " withString:@""] integerValue]) {
        self.shouldAddCount = YES;
    }
    
     [self loadPage];
    
   
    

}


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        int i = arc4random_uniform(435);
        NSString *randomIntString = [NSString stringWithFormat:@"%d", i];
        [self.psalterModel getPsalterContentForPsalterNumberString:randomIntString];
        [self animationForLoadingText];
        self.shouldAddCount = YES;
        [self loadPage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
        
    }
}


#pragma mark Tap & Zoom Gestures
- (IBAction)zoomGesture:(UIPinchGestureRecognizer *)sender
{
    
    CGFloat tempFontSize = self.psalterText.font.pointSize * sender.scale;
    
    if (sender.state == UIGestureRecognizerStateChanged && (![self.psalterText.text isEqualToString:@""])) {
        
        if(tempFontSize > self.defaultFontSize / 2 && tempFontSize < self.defaultFontSize * 5) {
            
            self.psalterText.font = [UIFont fontWithName:self.psalterText.font.fontName
                                                    size:tempFontSize];
            self.psalterText.attributedText = self.psalterText.attributedText;
            
            
            sender.scale = 1;
            
        }else {
            
            nil;
            
        }
        
        
    }else if (sender.state == UIGestureRecognizerStateEnded && (![self.psalterText.text isEqualToString:@""])){
        
        if(tempFontSize <10.0f){
            self.psalterText.font = [UIFont fontWithName:self.psalterText.font.fontName
                                                    size:10.0f];
            
        }else if (tempFontSize > self.defaultFontSize * 4){
            self.psalterText.font = [UIFont fontWithName:self.psalterText.font.fontName
                                                    size:self.defaultFontSize * 4];
            
            
        }else {
            self.psalterText.font = [UIFont fontWithName:self.psalterText.font.fontName
                                                    size:tempFontSize];
            
        }
     [self formattPage];
    }
    
}


- (IBAction)tapForZoom:(UITapGestureRecognizer *)sender {
    if((self.psalterText.font.pointSize <= self.defaultFontSize * 2) && (![self.psalterText.text isEqualToString:@""])){
        self.psalterText.font = [UIFont fontWithName:self.psalterText.font.fontName
                                                size:self.psalterText.font.pointSize*2];
        
        
    } else if ((self.psalterText.font.pointSize > self.defaultFontSize * 2) && (![self.psalterText.text isEqualToString:@""])){
        self.psalterText.font = [UIFont fontWithName:self.psalterText.font.fontName
                                                size:self.defaultFontSize];
        
    }
    [self formattPage];
}

#pragma mark Notifications

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)registerForOrientationNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)didChangeOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    [self navigationBarSetSubviewForSearch];
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        self.rightFixed.width = self.view.bounds.size.width *0.06f;
        
    } else {
        
        self.rightFixed.width = self.view.bounds.size.width *0.01f;
    }
}


- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect aRect = self.view.frame;
    aRect.origin.y = 0.0 - kbSize.height + self.tabBarController.tabBar.bounds.size.height;
    [UIView animateWithDuration:0.01f animations:^{
        self.view.frame = aRect;}];
    
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGRect aRect = self.view.frame;
    aRect.origin.y = 0;
    [UIView animateWithDuration:0.01f animations:^{
        self.view.frame = aRect;
    }];
    
}

- (void)setAccessoryView
{
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.translucent = YES;
    [keyboardDoneButtonView sizeToFit];
    
    if(self.searchButton.tintColor == [UIColor whiteColor]){
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Go Forth!"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(doneClicked:)];
        [keyboardDoneButtonView setItems:@[flexible, doneButton, self.rightFixed]];
        self.psalterInput.inputAccessoryView = keyboardDoneButtonView;
        
    } else if(self.searchButton.tintColor == [UIColor cyanColor]){
        
        self.psalterInput.inputAccessoryView = nil;
    }
}

#pragma mark Table View Goodness
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchModel.psalterSearchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.searchResultsTV dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    if([self.searchModel.psalterSearchResults count] > 0){
        
        
        cell.textLabel.text = [self.searchModel.psalterSearchResults objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.searchModel.psalterSearchTitleResults objectAtIndex:indexPath.row];
        
        
        NSRange range = [cell.textLabel.text rangeOfString:self.searchRequest
                                                   options:NSCaseInsensitiveSearch];
        
        NSMutableAttributedString *highlightedString = [cell.textLabel.attributedText mutableCopy];
        [highlightedString setAttributes:@{NSForegroundColorAttributeName:[UIColor cyanColor]}
                                   range:range];
        cell.textLabel.attributedText = highlightedString;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *psalterKey = [[self.searchModel.psalterSearchTitleResults objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"Psalter " withString:@""];
    [self.psalterModel getPsalterContentForPsalterNumberString:psalterKey];
    self.shouldAddCount = YES;
    [self loadPage];
    
    
    [self animationToShowHideTableView:self.searchResultsTV show:NO];
    [_searchResultsNavBar removeFromSuperview];
    self.searchButton.tintColor = [UIColor whiteColor];
    [self setAccessoryView];
    self.psalterInput.placeholder = [NSString stringWithFormat:@"Key in Psalter # here (1-%d)", self.psalterModel.psalterCount];
    self.psalterInput.text = nil;
    [self.psalterInput resignFirstResponder];
    
    
}

#pragma mark AlertView

- (void)showSearchRequestWarning {
    NSString *alertTitle = @"Unfruitful Search Request";
    NSString *alertMessage = @"Only search requests of more than 2 characters will be accepted. \n(Don't waste my energy producing unhelpful search results! 😡)  Apologize!";
    NSString *alertOkButtonText = @"I'm Sorry!";
    
    if(self.psalterInput.text.length >0 ) {
        if ([UIAlertController class] == nil) { //[UIAlertController class] returns nil on iOS 7 and older. You can use whatever method you want to check that the system version is iOS 8+
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:alertMessage
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:alertOkButtonText, nil];
            [alertView show];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                                     message:alertMessage
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            //Add buttons to the alert controller by creating UIAlertActions:
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:alertOkButtonText
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil]; //Use a block here to handle a press on this button
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}


- (void)showPsalterNotAvailableWarning {
    
    NSString *alertTitle = @"Psalter Not Available";
    NSString *alertMessage = [NSString stringWithFormat:@"Come On! \nDon't you know that there are only Psalters 1 - %d available?  \nApologize Now!" , self.psalterModel.psalterCount];
    NSString *alertOkButtonText = @"I'm Sorry!";
    
    if(self.psalterInput.text.length >0) {
        if ([UIAlertController class] == nil) { //[UIAlertController class] returns nil on iOS 7 and older. You can use whatever method you want to check that the system version is iOS 8+
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:alertMessage
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:alertOkButtonText, nil];
            [alertView show];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                                     message:alertMessage
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            //Add buttons to the alert controller by creating UIAlertActions:
            UIAlertAction *actionOk = [UIAlertAction actionWithTitle:alertOkButtonText
                                                               style:UIAlertActionStyleDefault
                                                             handler:nil]; //Use a block here to handle a press on this button
            [alertController addAction:actionOk];
            [self presentViewController:alertController animated:YES completion:nil];
        }}
    
}

#pragma mark extraInfoView


- (IBAction)infoButtonTapped:(id)sender {
    if(self.extraInfoView.hidden){
        [self animationToShowHideExtraInfoView:self.extraInfoView show:YES];
        [self updateExtraInfoView];
        [self handleMusic];
        
    }
    
    else if (self.extraInfoView.isHidden == NO) {
        [self animationToShowHideExtraInfoView:self.extraInfoView show:NO];
    }
    
}

- (void)handleMusic {
    BOOL wasPlaying = self.player.isPlaying;
    
    if ((self.player == nil) || (![self.navigationBar.topItem.title isEqualToString:self.player.currentPsalterName])){
        
        self.player = [[AudioPlayer alloc]init];
        [self.player loadMusic:self.navigationBar.topItem.title];
        
    }
    
    self.slider.maximumValue = self.player.maxTime;
    
    if (wasPlaying){
        [self.player play];
    }
    
    
}

- (void)updateExtraInfoView {
    [self.psalterModel getPsalterCrossRefForPsalter:self.navigationBar.topItem.title];
    
    if (self.psalterModel.psalterCrossRef != nil) {
        self.referencesTextV.text = [NSString stringWithFormat:@"References:\n%@", self.psalterModel.psalterCrossRef];
    }
    
    
    
    self.timesSungLabel.text = [NSString stringWithFormat:@"Count: %ld", (long)[self.statistics psalterSingCount:self.navigationBar.topItem.title]];
    
}


- (IBAction)tapOnceToCancel:(UITapGestureRecognizer *)sender {
    if(self.extraInfoView.isHidden == NO){
        [self animationToShowHideExtraInfoView:self.extraInfoView show:NO];
    }
}


- (IBAction)playButtonTapped:(id)sender {
    self.slider.maximumValue = self.player.maxTime;
    //[self.player playAtTime:self.slider.value];
    [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
}

- (IBAction)pauseButtonTapped:(id)sender {
    [self stopTimer];
    
    if(self.player.isPlaying == NO){
        [self.player setTime:0.0];
        self.playTimerLabel.text = [NSString stringWithFormat:@"%@", self.player.currentTime];
        self.slider.value = self.player.currentTimeFloat;
        
    }
    
    [self.player pause];
}


- (IBAction)slide:(UISlider *)sender {
    self.playTimerLabel.text = [NSString stringWithFormat:@"%@", self.player.currentTime];
    [self stopTimer];
    
    if (self.player.isPlaying == YES){
        
        [self.player pause];
        [self.player setTime:[sender value]];
        [self.player play];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        
    }
    
    [self.player setTime:[sender value]];
    
}



#pragma mark extraInfoView - Timer

- (void)timerFired:(NSTimer *)timer{
    self.playTimerLabel.text = [NSString stringWithFormat:@"%@", self.player.currentTime];
    self.slider.value = self.player.currentTimeFloat;
    
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
    
}


#pragma mark Need to Work On!





#pragma mark Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
