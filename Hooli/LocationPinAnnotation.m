//
//  LocationPinAnnotation.m
//  Hooli
//
//  Created by Er Li on 3/14/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "LocationPinAnnotation.h"

@implementation LocationPinAnnotation
@synthesize coordinate;

- (id) initWithCoords:(CLLocationCoordinate2D) coords {
    
    self = [super init];
    
    if (self != nil) {
        
        coordinate = coords;
        
    }
    return self;
}

- (NSString *)subtitle{
    return subtitletext;
}
- (NSString *)title{
    return titletext;
}

-(void)setTitle:(NSString*)strTitle {
    self.titletext = strTitle;
}

-(void)setSubTitle:(NSString*)strSubTitle {
    self.subtitletext = strSubTitle;
}


@end
