//
//  CreateActivityViewController.h
//  Hooli
//
//  Created by Er Li on 3/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//
#import "PostFormViewController.h"
#import <UIKit/UIKit.h>
typedef enum{
    
    HL_EVENT_DETAIL_NAME = 1,
    HL_EVENT_DETAIL_DESCRIPTION,
    HL_EVENT_DETAIL_LOCATION,
    HL_EVENT_DETAIL_DATE

    
} EventDetailType;

@interface CreateActivityViewController : PostFormViewController

@end
