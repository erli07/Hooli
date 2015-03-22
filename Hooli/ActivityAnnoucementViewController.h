//
//  ActivityAnnoucementViewController.h
//  Hooli
//
//  Created by Er Li on 3/21/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ActivityAnnoucementViewController : UIViewController

@property (nonatomic) UITextView *textView;

@property (nonatomic) NSString *content;

@property (nonatomic, strong) PFObject *aObject;


@end
