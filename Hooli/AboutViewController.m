//
//  AboutViewController.m
//  Hooli
//
//  Created by Er Li on 12/12/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "AboutViewController.h"
#import "HLSettings.h"
#import "HLTheme.h"
@interface AboutViewController ()
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic) UILabel *versionLabel;
@property (nonatomic) UILabel *buildLabel;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *rightsLabel;
@property (nonatomic) UIButton *followButton;
@end

@implementation AboutViewController
@synthesize webView = _webView;
@synthesize versionLabel = _versionLabel;
@synthesize buildLabel = _buildLabel;
@synthesize rightsLabel = _rightsLabel;
@synthesize nameLabel = _nameLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *versionNumber = [HLSettings releaseNumber];
    NSString *buildNumber = [HLSettings buildNumber];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.title = @"About";
    
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 90, 260, 30)];
    _nameLabel.text = [NSString stringWithFormat:@"Name: 海圈圈"];
    _nameLabel.font = font;
    
    _versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 120, 260, 30)];
    _versionLabel.text = [NSString stringWithFormat:@"Version: %@", versionNumber];
    _versionLabel.font = font;
    
    _buildLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 150, 260, 30)];
    _buildLabel.text = [NSString stringWithFormat:@"Build: %@", buildNumber];
    _buildLabel.font = font;
    
    _rightsLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 180, 260, 60)];
    _rightsLabel.text = @"Designed and developed by Er Li. All rights reserved.";
    _rightsLabel.numberOfLines = 2;
    _rightsLabel.font = font;
    
    _followButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _followButton.frame = CGRectMake(20, 210, 150, 30);
    [_followButton addTarget:self action:@selector(followMe) forControlEvents:UIControlEventTouchUpInside];
    [_followButton setTitle:@"Follow me @Twitter" forState:UIControlStateNormal];
    _followButton.tintColor = [HLTheme mainColor];

    
    [self.view addSubview:_nameLabel];
    [self.view addSubview:_buildLabel];
    [self.view addSubview:_versionLabel];
    [self.view addSubview:_rightsLabel];
    [self.view addSubview:_followButton];
    
//    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
//    [self.view addSubview:_webView];
//    NSString *fullURL = @"http://www.google.com";
//    NSURL *url = [NSURL URLWithString:fullURL];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    [_webView loadRequest:requestObj];
    // Do any additional setup after loading the view.
}

-(void)followMe{
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/AwesomeErLi"]];
    
}


@end
