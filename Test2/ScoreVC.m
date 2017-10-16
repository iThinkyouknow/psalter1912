//
//  ScoreVC.m
//  The Psalter
//
//  Created by Not For You to Use on 28/09/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "ScoreVC.h"
#import "PsalterModel.h"
#import "ScoreView.h"
#import "ScoreModel.h"

@interface ScoreVC () <UIScrollViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) PsalterModel *psalterModel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (nonatomic) BOOL shouldShowWarning;
@property (nonatomic) BOOL shouldShowWarningForScore;


@property (nonatomic) CGRect rect;

@property (nonatomic, strong) ScoreView *scoreView;
@property (nonatomic, readwrite) NSInteger scorePage;


@end

@implementation ScoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(!self.psalterModel) {
        
        self.psalterModel = [[PsalterModel alloc] init];
        
    }
    
    if (self.splitViewController){
        self.navBar.topItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navBar.topItem.leftItemsSupplementBackButton = YES;
        self.navBar.topItem.title = nil;
    }

    
    self.textField.placeholder = @"Key in Psalter # here (1-413)";
    
    self.scrollView.delegate = self;
    self.textField.delegate = self;
    
    
    self.rect = [ScoreModel pdfRect:16];
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.rect.size.height * (self.view.bounds.size.width/self.rect.size.width));
    
    
    
    CGRect scrollRect = self.scrollView.bounds;
    
    self.scoreView = [[ScoreView alloc] initWithFrame:CGRectMake(scrollRect.origin.x,
                                                                 scrollRect.origin.y,
                                                                 self.scrollView.contentSize.width,
                                                                 self.scrollView.contentSize.height)];
    
    
    [self gestureRecognizersForView:self.scoreView];
    
    [self.scrollView addSubview:self.scoreView];
    
    [self.view addSubview:self.scrollView];
    
    [self registerForKeyboardNotifications];
    [self registerForOrientationNotification];
    [self setAccessoryView];
    
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.shouldShowWarning) {
        [self showPsalterNotAvailableWarning];
    } else if (self.shouldShowWarningForScore) {
        [self showPsalterNotAvailableWarningForScore];
        [self loadPage];
    } else {
        [self loadPage];
    }

}


-(void)viewDidLayoutSubviews {
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.rect.size.height * (self.view.bounds.size.width/self.rect.size.width));
    
    self.scoreView.frame = CGRectMake(self.scrollView.bounds.origin.x,
                                      self.scrollView.bounds.origin.y,
                                      self.scrollView.contentSize.width,
                                      self.scrollView.contentSize.height);
    
    if (self.isViewLoaded && self.view.window) {
        if (self.shouldShowWarning) {
            [self showPsalterNotAvailableWarning];
        } else if (self.shouldShowWarningForScore) {
            [self showPsalterNotAvailableWarningForScore];
            [self loadPage];
        } else {
            [self loadPage];
        }
    }
}

- (void)loadPage {
    
    self.scoreView.pageInt = self.scorePage;
    [self.scoreView setNeedsDisplay];
}


- (void)gestureRecognizersForView:(UIView *)view {
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(swipedLeft:)];
    swipeGestureLeft.numberOfTouchesRequired = 1;
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]
                                                   initWithTarget:self
                                                   action:@selector(swipedRight:)];
    swipeGestureRight.numberOfTouchesRequired = 1;
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    
    tapGesture.numberOfTapsRequired = 2;
    
    [view addGestureRecognizer:swipeGestureLeft];
    [view addGestureRecognizer:swipeGestureRight];
    [view addGestureRecognizer: tapGesture];
    
    
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.scoreView;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView
                       withView:(UIView *)view
                        atScale:(CGFloat)scale
{
    
}





#pragma mark INPUT METHODS
- (void)swipedLeft:(UISwipeGestureRecognizer *)swipeRecognizer {
    
    self.scorePage = ++self.scoreView.pageInt;
    [self loadPage];
    
}


- (void)swipedRight:(UISwipeGestureRecognizer *)swipeRecognizer {
    
    if (self.scoreView.pageInt > 1) {
        self.scorePage = --self.scoreView.pageInt;
        [self loadPage];
       
    } else {
        
    }
}

- (void)tapped:(UITapGestureRecognizer *)tapRecognizer {
    
    CGFloat zScale = self.scrollView.zoomScale;
    
    if (zScale >= 1 && zScale <= 4) {
        
        zScale *= 2.0f;
        
    } else {
        
        zScale = 1.0f;
    }
    
    self.scrollView.zoomScale = zScale;
}



- (IBAction)scoreSelected:(UITextField *)sender {
   
    
    if(self.textField.text.length) {
        NSInteger selectedInt = [sender.text integerValue];
        [self handleShouldHaveWarningForPsalter:selectedInt];
    }
    
    self.textField.text = nil;
    
}




#pragma mark DELEGATE METHODS
- (void)loadScorePageForPsalter:(NSInteger)psalterRef {
    
    
    if (!self.psalterModel) {
        
        self.psalterModel = [[PsalterModel alloc] init];
        
    }
    
    [self handleShouldHaveWarningForPsalter:psalterRef];
}


#pragma mark ALERT VIEW
- (void)showPsalterNotAvailableWarning {
    NSString *alertTitle = @"Psalter Not Available";
    NSString *alertMessage = [NSString stringWithFormat:@"Come On! \nDon't you know that there are only Psalters 1 - %d available?  \nApologize Now!" , self.psalterModel.psalterCount];
    NSString *alertOkButtonText = @"I'm Sorry!";
    
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
    self.shouldShowWarning = NO;
   
}


- (void)showPsalterNotAvailableWarningForScore {
    NSString *alertTitle = @"Score Not Found";
    NSString *alertMessage = @"";
    NSString *alertOkButtonText = @"Come on! Don't get beat up over this!";
    
    
        NSInteger randInteger = arc4random_uniform(5);
        NSInteger randInteger2 = arc4random_uniform(5);
        
        if (randInteger == 1) {
            
            alertMessage = @"I am very very sorry but the scanned document does not have this score.\nSuch is life. Sometimes I am given lemons that cannot be made into lemonade and what can I do about it? 😥";
            
            
        } else if (randInteger == 2) {
            alertMessage = @"Yikes! You don't know how much regret I have in my heart that the scanned document just does not have this score.\nSometimes the best of intentions don't yield perfect results and what can I do about it?  😥";
            
        } else if (randInteger == 3) {
            alertMessage = @"No matter how hard I looked, I could not find the score that you are looking for. It must have been not included in the scanned document\n I'm exasperated and sweating but that does not change the outcome 😥";
            
        } else {
            alertMessage = @"This is a problem from of old. How can an app find a score not included in the scanned document?\nNone of my electrical signals can produce that out of the millions of 1s and 0s.\nI'm at the brink of breaking down. 😥";
            
        }
        
        if (randInteger2 == 1) {
            alertOkButtonText = @"Aww, you poor app, let me give you a hug";
        } else if (randInteger2 == 2) {
            alertOkButtonText = @"It's okay, someday will be a better day";
        } else if (randInteger2 == 3) {
            alertOkButtonText = @"I totally forgive you";
        } else {
            alertOkButtonText = @"It's okay, you are still the best app in my heart";
        }
        
    
    
    if ([UIAlertController class] == nil) { //[UIAlertController class] returns nil on iOS 7 and older. You can use whatever method you want to check that the system version is iOS 8+
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:alertOkButtonText, nil];
        [alertView show];
        
    } else {
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
    
    self.shouldShowWarningForScore = NO;
   

}


- (void)handleShouldHaveWarningForPsalter:(NSInteger)psalterRef {
    
    
    NSInteger pageChosen = [self.psalterModel getScorePageForPsalter:psalterRef];
    
    if (self.psalterModel.shouldShowWarningForScore == YES) {
        
        self.scorePage = pageChosen;
        self.shouldShowWarningForScore = YES;
        
    } else if (self.psalterModel.shouldShowWarning == YES) {
            
        self.shouldShowWarning = YES;
        
    } else {
        
        self.scorePage = pageChosen;
        
    }
    
   
    
}


#pragma mark KEYBOARD METHODS
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    
    
    return YES;
}

- (BOOL)textField: (UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
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


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
    
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Go Forth!"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:@[flexible, doneButton, [self rightFixed]]];
    self.textField.inputAccessoryView = keyboardDoneButtonView;
    
    
}

- (IBAction)doneClicked:(id)sender
{
    [self.textField endEditing:YES];
    [self scoreSelected:self.textField];
}

- (UIBarButtonItem *)rightFixed {
    
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                         target:self action:nil];
}

#pragma mark ORIENTATION NOTIFICATIONS
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
    
    
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        [self rightFixed].width = self.view.bounds.size.width *0.06f;
        
    } else {
        
        [self rightFixed].width = self.view.bounds.size.width *0.01f;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
