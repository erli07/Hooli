//
//  BidHisoryCell.m
//  Hooli
//
//  Created by Er Li on 2/24/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "BidHisoryCell.h"
#import "HLConstant.h"
static TTTTimeIntervalFormatter *timeFormatter;

@interface BidHisoryCell()


@end

@implementation BidHisoryCell

-(void)setNotification:(PFObject *)notification{

    [super setNotification:notification];
    
    NSString *activityString;
    
    if([[notification objectForKey:kHLNotificationTypeKey] isEqualToString:khlNotificationTypMakeOffer]){
        
        activityString  = [NSString stringWithFormat:@"bid %@ for this item",[notification objectForKey:kHLNotificationContentKey]];
        
    }

    if (self.user) {
        
        CGSize nameSize = [self.nameButton.titleLabel.text boundingRectWithSize:CGSizeMake(nameMaxWidth, CGFLOAT_MAX)
                                                                        options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                                        context:nil].size;
        NSString *paddedString = [BaseTextCell padString:activityString withFont:[UIFont systemFontOfSize:13.0f] toWidth:nameSize.width];
        
        [self.contentLabel setText:paddedString];
        
    } else { // Otherwise we ignore the padding and we'll add it after we set the user
        
        [self.contentLabel setText:activityString];
        
    }
        
    
}

@end
