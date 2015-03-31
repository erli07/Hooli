//
//  imageButton.m
//  Hooli
//
//  Created by Er Li on 3/28/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "imageButton.h"

@implementation imageButton

@synthesize buttonState = _buttonState;

-(id)init{
    
    if(!self){
        self = [super init];
        
        [self addTarget:self action:(@selector(buttonPressed)) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

-(void)buttonPressed{
    
    if([_buttonState isEqualToString:@""]){
        
        
    }
    else{
        
        
    }
    
}

- (void)drawRect:(CGRect)rect {


}


@end
