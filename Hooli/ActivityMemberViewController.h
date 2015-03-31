//
//  ActivityMemberViewController.h
//  Hooli
//
//  Created by Er Li on 3/18/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <Parse/Parse.h>

@protocol HLActivitySelectMemberDelegate <NSObject>

//- (void)didSelectEventLocation:(CLLocation *)eventLocation;
-(void)didSelectMember:(PFUser *) member;

-(void)didUpdateMembers:(NSArray *)membersArray;

@end

@interface ActivityMemberViewController : PFQueryTableViewController
@property (nonatomic, strong) PFObject *aObject;
@property (nonatomic, weak) id<HLActivitySelectMemberDelegate> delegate;

- (id)initWithObject:(PFObject *)_object;
@end
