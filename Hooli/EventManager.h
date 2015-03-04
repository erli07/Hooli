//
//  EventManager.h
//  Hooli
//
//  Created by Er Li on 3/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import <Parse/Parse.h>
@interface EventManager : NSObject

+(EventManager *)sharedInstance;

-(void)getAllEventsWithBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)getEventsWithFilterDictionary:(NSDictionary *)dictionary WithBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

-(void)uploadEventToCloud:(PFObject *)event withBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

@end
