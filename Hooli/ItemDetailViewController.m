//
//  ItemDetailViewController.m
//  Hooli
//
//  Created by Er Li on 10/25/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "DataSource.h"
#import "HLTheme.h"
#import "AccountManager.h"
@interface ItemDetailViewController ()
@property (nonatomic, strong) NSArray *info;

@end

@implementation ItemDetailViewController
@synthesize itemID;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    [self configureUIElements];
    // Do any additional setup after loading the view.
}

-(void)configureUIElements{
    
    self.title = @"Item Detail";
    self.info = [DataSource details];
    
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:[UIImage imageNamed:@"button-pressed"] forState:UIControlStateHighlighted];
    [self.addToCartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.pageControl setPageIndicatorImage:[UIImage imageNamed:@"pageControl-dot"]];
    [self.pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"pageControl-dot-selected"]];
    self.pageControl.numberOfPages = self.info.count;
    
    for (UIView *subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    self.scrollView.delegate = self;
    
    CGFloat scrollContentWidth = 0;
    CGFloat scrollHeight = self.scrollView.bounds.size.height; // -20;
    CGFloat padding = (self.scrollView.bounds.size.width - scrollHeight) / 2;
    
    for (NSDictionary *image in self.info) {
        CGRect frame = CGRectMake(scrollContentWidth + padding + 33, (self.scrollView.bounds.size.height - scrollHeight)/2, 200, scrollHeight);
        
        UIImageView *preview = [[UIImageView alloc] initWithFrame:frame];
        preview.image = [UIImage imageNamed:[image objectForKey: @"image"]];
        scrollContentWidth += self.scrollView.bounds.size.width;
        
        [self.scrollView addSubview:preview];
    }
    [self.parentScrollView setScrollEnabled:YES];
    [self.parentScrollView setContentSize:self.contentView.frame.size];
    
    self.scrollView.contentSize = CGSizeMake(scrollContentWidth, scrollHeight);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * (2 - 1), 0);
    
    [self scrollViewDidEndDecelerating:self.scrollView];
    

    UIImage* buttonImage = [[UIImage imageNamed:@"button"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    UIImage* buttonPressedImage = [[UIImage imageNamed:@"button-pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    [self.addToCartButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.addToCartButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    self.addToCartButton.titleLabel.font = [UIFont fontWithName:[HLTheme boldFont] size:18.0f];
    
    self.userNameLabel.font = [UIFont fontWithName:[HLTheme mainFont] size:15.0f];
    self.itemDescription.font = [UIFont fontWithName:[HLTheme boldFont] size:15.0f];

    [[AccountManager sharedInstance]setUserProfilePicture:self.profilePicture];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2;
    self.profilePicture.layer.masksToBounds = YES;
    self.userNameLabel.text = [[AccountManager sharedInstance]getUserName];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControl.currentPage = ceil(scrollView.contentOffset.x / self.scrollView.bounds.size.width);
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addToCart:(id)sender {
    
    
}
@end
