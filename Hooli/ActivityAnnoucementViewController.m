//
//  ActivityAnnoucementViewController.m
//  Hooli
//
//  Created by Er Li on 3/21/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityAnnoucementViewController.h"
#import "ActivityCommentViewController.h"
@interface ActivityAnnoucementViewController ()

@end

@implementation ActivityAnnoucementViewController
@synthesize textView = _textView;
@synthesize content =_content;
@synthesize aObject = _aObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"公告";
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _textView = [[UITextView alloc]initWithFrame:self.view.frame];
    
    
    _textView.editable = NO;
    
    _textView.font = [UIFont systemFontOfSize:14.0f];
    
    if(_content){
        
        _textView.text = _content;
        
    }
    
//    ActivityCommentViewController *acCommentVC =[[ActivityCommentViewController alloc]initWithObject:_aObject];
//    
//    [acCommentVC.view setFrame:CGRectMake(0, 100, 320, 568)];
//    
//    [_textView addSubview:acCommentVC.view];
//    
    [self.view addSubview:_textView];

    
    // Do any additional setup after loading the view.
}




@end
