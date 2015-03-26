


//
//  EventManager.m
//  Hooli
//
//  Created by Er Li on 3/4/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "EventManager.h"
#import "HLConstant.h"
@implementation EventManager

+(EventManager *)sharedInstance{
    
    static EventManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[EventManager alloc] init];
        
    });
    return _sharedInstance;
    
}



-(void)uploadEventToCloud:(PFObject *)event withBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
       
        if(succeeded){
            
            completionBlock(YES, nil);
        }
        
    }];
    
}

-(void)getAllEventsWithBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    
    
    
}


-(void)joinEvent:(PFObject *)eventObject
            user:(PFUser *)user
       withBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock{
    
    PFQuery *existQuery = [PFQuery queryWithClassName:kHLCloudEventMemberClass];
    [existQuery whereKey:kHLEventMemberKeyMember equalTo:user];
    [existQuery whereKey:kHLEventMemberKeyEvent equalTo:eventObject];
    [existQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if(object){
            
            completionBlock(NO, nil);

        }
        else{
            
            PFObject *eventMember = [PFObject objectWithClassName:kHLCloudEventMemberClass];
            [eventMember setObject:user forKey:kHLEventMemberKeyMember];
            [eventMember setObject:[PFObject objectWithoutDataWithClassName:kHLCloudEventClass objectId:eventObject.objectId] forKey:kHLEventMemberKeyEvent];
            [eventMember setObject:eventObject.objectId forKey:kHLEventMemberKeyEventId];
            [eventMember setObject:@"member" forKey:kHLEventMemberKeyMemberRole];
            
            PFACL *eventMemberACL = [PFACL ACLWithUser:[PFUser currentUser]];
            [eventMemberACL setPublicReadAccess:YES];
            eventMember.ACL = eventMemberACL;
            
            [eventMember saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if(succeeded){
                    
                    completionBlock(YES,nil);
                    
//                    PFQuery *deleteQuery = [PFQuery queryWithClassName:kHLCloudNotificationClass];
//                    [deleteQuery whereKey:kHLNotificationFromUserKey equalTo:user];
//                    [deleteQuery setCachePolicy:kPFCachePolicyNetworkOnly];
//                    [deleteQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                        
//                        if(object){
//                            
//                            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                                
//                                if(succeeded){
//                                   
//                                    completionBlock(YES, nil);
//                                    
//                                }
//                                
//                            }];
//                        }
//                        
//                    }];
                }
                
                
            }];
        }
    }];

}


@end
