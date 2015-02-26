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

static NSString * const sampleDescription1 = @"Welcome to use Hooli!\n An app to help you shop freely.";
static NSString * const sampleDescription2 = @"First, you will get $200\n free credits for shopping.";
static NSString * const sampleDescription3 = @"Spend your free credits for the items you want. Or list your unused items to earn more credits!";
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
    page1.titleIconPositionY = 50;
    page1.title = sampleDescription1;
  //  page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"bg1"];
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"open"]];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.titleIconPositionY = 120;
    page2.title = sampleDescription2;
   // page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"bg2"];
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"money"]];

    EAIntroPage *page3 = [EAIntroPage page];
    page3.titleIconPositionY = 120;
    page3.title =sampleDescription3;
   // page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"bg3"];
    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gift"]];

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
    UIStoryboard *mainSb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = [mainSb instantiateViewControllerWithIdentifier:@"HomeTabBar"];
    [self presentViewController:vc animated:YES completion:^{
        
        NSLog(@"Submit success");
        
    }];
}


@end
