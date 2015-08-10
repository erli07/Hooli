//
//  IntroViewController.m
//  Hooli
//
//  Created by Er Li on 1/6/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "IntroViewController.h"
#import "SMPageControl.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginWelcomeViewController.h"
#import "SignUpViewController.h"
//static NSString * const sampleDescription1 = @"欢迎光临!";
//static NSString * const sampleDescription2 = @"海外生活多孤单，海圈圈最懂你";
//static NSString * const sampleDescription3 = @"随心所欲，想po就po";
//static NSString * const sampleDescription4 = @"心动了吗? \n Let’s get started!";
static NSString * const sampleDescription1 = @"Welcome to Ezee!";
static NSString * const sampleDescription2 = @"Find your favorite events nearby";
static NSString * const sampleDescription3 = @"Sell your unused stuff";
static NSString * const sampleDescription4 = @"Excited? Let’s get started!";

@interface IntroViewController (){
    UIView *rootView;
}

@end

@implementation IntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    rootView = self.navigationController.view;
    [self showIntroWithCrossDissolve];

    // Do any additional setup after loading the view.
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.titleIconPositionY = 100;
    page1.title = sampleDescription1;
   // page1.desc = @"海圈圈, 你海外生活的好帮手";
    page1.desc = @"Discover the fun of life.";
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rsz_ariel"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.titleIconPositionY = 120;
    page2.title = sampleDescription2;
  //  page2.desc = @"无论是御宅族，社交达人还是户外爱好者，\n在这里你会找到最志同道合的小伙伴\n和意想不到的惊喜^_^";
    page2.desc = @"Life is fun! We help you to discover fun things to do!";
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crowd"]];

    EAIntroPage *page3 = [EAIntroPage page];
    page3.titleIconPositionY = 120;
    page3.title =sampleDescription3;
    page3.desc = @"Life is easy! We help you to get rid of unused stuff！";
   // page3.desc = @"告别封闭的小圈子，生活本就丰富多彩！";
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome_money"]];

    EAIntroPage *page4 = [EAIntroPage page];
    page4.titleIconPositionY = 50;
    page4.title = sampleDescription4;
   // page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"bg4"];
    page4.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"celebrate"]];

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:rootView.bounds andPages:@[page1,page2,page3,page4]];
    [intro setDelegate:self];
    
    [intro showInView:rootView animateDuration:0.3];
}

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    NSLog(@"introDidFinish callback");
    
    UIStoryboard *loginSb = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    SignUpViewController *signUpVC = [loginSb instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:signUpVC animated:NO];
    //    [self presentViewController:vc animated:YES completion:^{
    //
    //        NSLog(@"Submit success");
    //
    //    }];
//    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
//    [self presentViewController:vc animated:YES completion:^{
//        
//        NSLog(@"Submit success");
//        
//    }];
}


@end
