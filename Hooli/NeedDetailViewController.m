//
//  NeedDetailViewController.m
//  Hooli
//
//  Created by Er Li on 12/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "NeedDetailViewController.h"
#import "MBProgressHUD.h"
#import "NeedsManager.h"
#import "ItemCommentViewController.h"
#import "HLTheme.h"
@interface NeedDetailViewController ()
@property (nonatomic) UILabel *priceLabel;
@property (nonatomic) UILabel *nameLbael;
@property (nonatomic) UIImageView *portraitImageView;
@property (nonatomic) UITextView *infoTextView;
@property (nonatomic) UIButton *offerButton;
@property (nonatomic) UIView *userInfoView;
@property (nonatomic) UIScrollView *parentView;

@end

@implementation NeedDetailViewController
@synthesize priceLabel,needId,portraitImageView,infoTextView,offerButton,userInfoView,parentView;


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLItemDetailsReloadContentSizeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLItemDetailsLiftCommentViewNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHLItemDetailsPutDownCommentViewNotification object:nil];
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.parentView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:self.parentView];
    
    [self.parentView setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liftCommentView:) name:kHLItemDetailsLiftCommentViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContentsize) name:kHLItemDetailsReloadContentSizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(putDownCommentView) name:kHLItemDetailsPutDownCommentViewNotification object:nil];
    
    [self configureElements];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self getNeedInfo];
    
}



-(void)getNeedInfo{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(self.needId){
        
        [[NeedsManager sharedInstance]fetchNeedByID:self.needId block:^(PFObject *object, NSError *error) {
            
            if(object){
                
                [self updateNeedInfoWithNeedObject:object];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }
            
        }];
        
    }
    
}

-(void)updateNeedInfoWithNeedObject:(PFObject *)object{
    
    
    PFUser *user = [object objectForKey:kHLNeedsModelKeyUser];
    
    PFFile *portraitImageFile = [user objectForKey:kHLUserModelKeyPortraitImage];
    
    NSData *imageData = [portraitImageFile getData];
    
    self.portraitImageView.image = [UIImage imageWithData:imageData];
    
    self.priceLabel.text = [NSString stringWithFormat:@"Budget: %@",[object objectForKey:kHLNeedsModelKeyPrice]];
    
    self.nameLbael.text = [user objectForKey:kHLUserModelKeyUserName];
    
    self.infoTextView.text = [object objectForKey:kHLNeedsModelKeyDescription];
    
    
    self.commentVC = [[ItemCommentViewController alloc]initWithObject:object];
        
    [self.commentVC.view setFrame:CGRectMake(0, self.offerButton.frame.origin.y + self.offerButton.frame.size.height + 20, 320, self.commentVC.tableView.contentSize.height)];
        
    [self.parentView addSubview:self.commentVC.view];

}

-(void)configureElements{
    
    self.userInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    
    [self.userInfoView setBackgroundColor:[UIColor lightGrayColor]];
    
    self.portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 50, 50)];
    
    self.portraitImageView.layer.cornerRadius = 50/2;
    
    self.portraitImageView.layer.masksToBounds = YES;
    
    self.nameLbael = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 100, 32)];
    
    [self.nameLbael setFont: [UIFont fontWithName:[HLTheme mainFont] size:14.0f]];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 32, 100, 32)];
    
    [self.priceLabel setFont: [UIFont fontWithName:[HLTheme mainFont] size:14.0f]];
    
    self.infoTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, self.userInfoView.frame.origin.y + self.userInfoView.frame.size.height, 320, 120)];
    
    [self.infoTextView setFont:[UIFont fontWithName:[HLTheme mainFont] size:11.0f]];
    
    self.offerButton = [[UIButton alloc]initWithFrame:CGRectMake(50, self.infoTextView.frame.origin.y + self.infoTextView.frame.size.height, 220, 44)];
    
    [self.offerButton addTarget:self action:@selector(offerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.offerButton setTitle:@"Offer" forState:UIControlStateNormal];
    
    [self.offerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.offerButton setBackgroundColor:[HLTheme mainColor]];
    
    self.offerButton.layer.cornerRadius = 10.0f;
    
    self.offerButton.layer.masksToBounds = YES;
    
    [self.userInfoView addSubview:self.portraitImageView];
    
    [self.userInfoView addSubview:self.nameLbael];
    
    [self.userInfoView addSubview:self.priceLabel];
    
    [self.parentView  addSubview:userInfoView];
    
    [self.parentView  addSubview:self.infoTextView];

    [self.parentView  addSubview:self.offerButton];
    
}

-(void)offerButtonPressed:(id)sender{
    
    
    
}


-(void)liftCommentView:(NSNotification*)note{
    
    NSDictionary* info = [note userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.parentView  setContentOffset:CGPointMake(0.0f, self.parentView .contentSize.height-kbSize.height - 74) animated:YES];
    
}

-(void)putDownCommentView{
    
    [self.parentView  setContentOffset:CGPointMake(0.0f, -64.0f) animated:YES];
    
}

-(void)dismissKeyboard{
    
    [self.commentVC.commentTextField resignFirstResponder];
    [self putDownCommentView];
    
}


-(void)reloadContentsize{
        
    [self.parentView setContentSize:CGSizeMake(320, self.parentView.frame.size.height  + self.commentVC.tableView.contentSize.height - 74)];
    
    [self.commentVC.view setFrame:CGRectMake(0, self.offerButton.frame.origin.y + self.offerButton.frame.size.height + 20, 320, self.commentVC.tableView.contentSize.height)];
    
    
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
