//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>

#import "HLConstant.h"

#import "messages.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
NSString* StartPrivateChat(PFUser *user1, PFUser *user2)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *id1 = user1.objectId;
	NSString *id2 = user2.objectId;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSString *roomId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@", id1, id2] : [NSString stringWithFormat:@"%@%@", id2, id1];
	//---------------------------------------------------------------------------------------------------------------------------------------------
    if(user1 == user2){
        
        CreateMessageItem(user1, user2, roomId, user2[PF_USER_USERNAME]);

    }
    else{
        
        CreateMessageItem(user1, user2, roomId, user2[PF_USER_USERNAME]);
        CreateMessageItem(user2, user1, roomId, user1[PF_USER_USERNAME]);

    }
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return roomId;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void CreateMessageItem(PFUser *user,PFUser *chatter, NSString *roomId, NSString *description)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
	[query whereKey:PF_MESSAGES_FROM_USER equalTo:user];
	[query whereKey:PF_MESSAGES_ROOMID equalTo:roomId];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			if ([objects count] == 0)
			{
				PFObject *message = [PFObject objectWithClassName:PF_MESSAGES_CLASS_NAME];
				message[PF_MESSAGES_FROM_USER] = user;
				message[PF_MESSAGES_ROOMID] = roomId;
				message[PF_MESSAGES_DESCRIPTION] = description;
				message[PF_MESSAGES_TO_USER] = chatter;
				message[PF_MESSAGES_LASTMESSAGE] = @"";
				message[PF_MESSAGES_COUNTER] = @0;
				message[PF_MESSAGES_UPDATEDACTION] = [NSDate date];
				[message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
                    
                    if(succeeded){
                        
                        
                    }
					if (error != nil) NSLog(@"CreateMessageItem save error.");
				}];
			}
		}
		else NSLog(@"CreateMessageItem query error.");
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void DeleteMessageItem(PFObject *message)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[message deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
	{
		if (error != nil) NSLog(@"DeleteMessageItem delete error.");
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void UpdateMessageCounter(NSString *roomId, NSString *lastMessage)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
	[query whereKey:PF_MESSAGES_ROOMID equalTo:roomId];
	[query setLimit:1000];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			for (PFObject *message in objects)
			{
				PFUser *user = message[PF_MESSAGES_FROM_USER];
				if ([user.objectId isEqualToString:[PFUser currentUser].objectId] == NO)
					[message incrementKey:PF_MESSAGES_COUNTER byAmount:@1];
				//---------------------------------------------------------------------------------------------------------------------------------
				//message[PF_MESSAGES_CHATTER] = [PFUser currentUser];
				message[PF_MESSAGES_LASTMESSAGE] = lastMessage;
				message[PF_MESSAGES_UPDATEDACTION] = [NSDate date];
				[message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"UpdateMessageCounter save error.");
				}];
			}
		}
		else NSLog(@"UpdateMessageCounter query error.");
	}];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
void ClearMessageCounter(NSString *roomId)
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
	[query whereKey:PF_MESSAGES_ROOMID equalTo:roomId];
	[query whereKey:PF_MESSAGES_FROM_USER equalTo:[PFUser currentUser]];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			for (PFObject *message in objects)
			{
				message[PF_MESSAGES_COUNTER] = @0;
				[message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
				{
					if (error != nil) NSLog(@"ClearMessageCounter save error.");
				}];
			}
		}
		else NSLog(@"ClearMessageCounter query error.");
	}];
}
