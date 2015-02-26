//
//  EditProfileDetailViewController.m
//  Hooli
//
//  Created by Er Li on 2/15/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "EditProfileDetailViewController.h"

@interface EditProfileDetailViewController ()<UITextFieldDelegate>
@property (nonatomic) UITextField *textField;
@end

@implementation EditProfileDetailViewController
@synthesize delegate = _delegate;
@synthesize profileTypeIndex = _profileTypeIndex;
@synthesize textField = _textField;
@synthesize content = _content;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(40, 84, 240, 44)];
    
    
    
    _textField.text = _content;
    
    _textField.delegate = self;
    
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    
    _textField.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:_textField];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [_textField becomeFirstResponder];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [[[FormManager sharedInstance]profileDetailArray]replaceObjectAtIndex:_profileTypeIndex withObject:textField.text];
        
    [self.navigationController popViewControllerAnimated:YES];
}

@end
