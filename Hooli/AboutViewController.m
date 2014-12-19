//
//  AboutViewController.m
//  Hooli
//
//  Created by Er Li on 12/12/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation AboutViewController
@synthesize webView = _webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_webView];
    NSString *fullURL = @"http://www.google.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
    // Do any additional setup after loading the view.
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
