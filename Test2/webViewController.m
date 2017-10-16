//
//  webViewController.m
//  Test2
//
//  Created by Not For You to Use on 03/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "webViewController.h"

@interface webViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;

@end

@implementation webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.splitViewController){
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.URLString];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (IBAction)goForward:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (IBAction)refresh:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (IBAction)stop:(UIBarButtonItem *)sender {
    [self.webView stopLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (![self.webView canGoBack]) {
        self.backButton.enabled = NO;
        
    } else {
        self.backButton.enabled = YES;
    }
    
    if (![self.webView canGoForward]) {
        self.forwardButton.enabled = NO;
        
    } else {
        self.forwardButton.enabled = YES;
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

@end
