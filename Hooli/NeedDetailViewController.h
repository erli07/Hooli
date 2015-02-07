//
//  NeedDetailViewController.h
//  Hooli
//
//  Created by Er Li on 12/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLConstant.h"
#import "ItemCommentViewController.h"

@interface NeedDetailViewController : UIViewController

@property(nonatomic, strong) NSString *needId;
@property (nonatomic, strong) ItemCommentViewController *commentVC;

@end
