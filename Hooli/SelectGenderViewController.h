//
//  SelectGenderViewController.h
//  Hooli
//
//  Created by Er Li on 2/25/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HLSelectGenderDelegate <NSObject>

@optional
- (void)didSelectGender:(NSString *)gender;

@end

@interface SelectGenderViewController : UITableViewController

@property (nonatomic, weak) id<HLSelectGenderDelegate> delegate;

@end
