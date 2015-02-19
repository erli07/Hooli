//
//  LoginWelcomeViewController.m
//  Hooli
//
//  Created by Er Li on 2/18/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "LoginWelcomeViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "HLSettings.h"
@interface LoginWelcomeViewController ()

@end

@implementation LoginWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationItem.hidesBackButton = YES;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    int selectedIndex = [[HLSettings sharedInstance]currentPageIndex];
    
    self.title = [[[HLSettings sharedInstance]getTitlesArray]objectAtIndex:selectedIndex];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"logIn"]){
        
        LoginViewController *vc = segue.destinationViewController;
        vc.hidesBottomBarWhenPushed = YES;
        
    }
    else if([segue.identifier isEqualToString:@"signUp"]){
        
        SignUpViewController *vc = segue.destinationViewController;
        vc.hidesBottomBarWhenPushed = YES;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



- (IBAction)signUp:(id)sender {
}

- (IBAction)logIn:(id)sender {
}
@end
