//
// Copyright (c) 2015 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>
#import "ProgressHUD.h"
#import "HLConstant.h"
#import "ChatConstant.h"
#import "messages.h"
#import "utilities.h"
#import "HLUtilities.h"
#import "MessagesView.h"
#import "MessagesCell.h"
#import "ChatView.h"
#import "SelectSingleView.h"
#import "SelectMultipleView.h"
#import "AddressBookView.h"
#import "FacebookFriendsView.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface MessagesView()
{
	NSMutableArray *messages;
	UIRefreshControl *refreshControl;
    
}
@property (nonatomic, strong) UIView *blankView;

@property (strong, nonatomic) IBOutlet UITableView *tableMessages;
@property (strong, nonatomic) IBOutlet UIView *viewEmpty;

@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation MessagesView

@synthesize tableMessages, viewEmpty, blankView;

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kHLLoadMessageObjectsNotification object:nil];
    
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	{
		[self.tabBarItem setImage:[UIImage imageNamed:@"tab_messages"]];
		self.tabBarItem.title = @"Messages";
		//-----------------------------------------------------------------------------------------------------------------------------------------
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
	}
	return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	self.title = @"Messages";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMessages) name:kHLLoadMessageObjectsNotification object:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"messages_compose"]
																	  style:UIBarButtonItemStylePlain target:self action:@selector(actionCompose)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[tableMessages registerNib:[UINib nibWithNibName:@"MessagesCell" bundle:nil] forCellReuseIdentifier:@"MessagesCell"];
	tableMessages.tableFooterView = [[UIView alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(loadMessages) forControlEvents:UIControlEventValueChanged];
	[tableMessages addSubview:refreshControl];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	messages = [[NSMutableArray alloc] init];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	viewEmpty.hidden = YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
    
    if([HLUtilities checkIfUserLoginWithCurrentVC:self]){
        
        [self loadMessages];
    }
    
    
//	if ([PFUser currentUser] != nil)
//	{
//		[self loadMessages];
//	}
//    else{
//        
//    
//        
//    }
}

-(void)showEmptyPage{
    
    viewEmpty.hidden = NO;
    
//    self.blankView = [[UIView alloc] initWithFrame:self.view.frame];
//    [self.blankView setBackgroundColor:[UIColor whiteColor]];
//    UILabel *noContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 44)];
//    noContentLabel.text = @"No content at the moment";
//    noContentLabel.textColor = [UIColor lightGrayColor];
//    noContentLabel.font = [UIFont systemFontOfSize:17.0f];
//    noContentLabel.textAlignment = NSTextAlignmentCenter;
//    [self.blankView addSubview:noContentLabel];
}

#pragma mark - Backend methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadMessages
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *queryMember = [PFQuery queryWithClassName:kHLCloudEventMemberClass];
    [queryMember whereKey:kHLEventMemberKeyMember equalTo:[PFUser currentUser]];
    
	PFQuery *queryOne = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
    [queryOne whereKey:PF_MESSAGES_USER equalTo:[PFUser currentUser]];
    [queryOne whereKeyDoesNotExist:@"event"];

    PFQuery *queryTwo = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
    [queryTwo whereKey:@"groupId" matchesKey:@"eventId" inQuery:queryMember];

    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryOne,queryTwo]];
    
	[query whereKey:PF_MESSAGES_USER equalTo:[PFUser currentUser]];
	[query includeKey:PF_MESSAGES_LASTUSER];
    [query includeKey:PF_MESSAGES_TOUSER];
    [query includeKey:PF_MESSAGES_EVENT];
	[query orderByDescending:PF_MESSAGES_UPDATEDACTION];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	{
		if (error == nil)
		{
			[messages removeAllObjects];
			[messages addObjectsFromArray:objects];
			[tableMessages reloadData];
			[self updateEmptyView];
			[self updateTabCounter];
		}
		else [ProgressHUD showError:@"Network error."];
		[refreshControl endRefreshing];
	}];
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateEmptyView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	viewEmpty.hidden = ([messages count] != 0);
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)updateTabCounter
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	int total = 0;
	for (PFObject *message in messages)
	{
		total += [message[PF_MESSAGES_COUNTER] intValue];
	}
	UITabBarItem *item = self.tabBarController.tabBar.items[1];
	item.badgeValue = (total == 0) ? nil : [NSString stringWithFormat:@"%d", total];
}

#pragma mark - User actions

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionChat:(NSString *)groupId
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	ChatView *chatView = [[ChatView alloc] initWith:groupId];
	chatView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:chatView animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCleanup
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[messages removeAllObjects];
	[tableMessages reloadData];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UITabBarItem *item = self.tabBarController.tabBar.items[1];
	item.badgeValue = nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionCompose
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
			   otherButtonTitles:@"Single recipient", @"Multiple recipients", @"Address Book", @"Facebook Friends", nil];
	[action showFromTabBar:[[self tabBarController] tabBar]];
}

#pragma mark - UIActionSheetDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------


#pragma mark - SelectSingleDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSelectSingleUser:(PFUser *)user2
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFUser *user1 = [PFUser currentUser];
	NSString *groupId = StartPrivateChat(user1, user2);
	[self actionChat:groupId];
}

#pragma mark - SelectMultipleDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSelectMultipleUsers:(NSMutableArray *)users
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *groupId = StartMultipleChat(users);
	[self actionChat:groupId];
}

#pragma mark - AddressBookDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSelectAddressBookUser:(PFUser *)user2
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFUser *user1 = [PFUser currentUser];
	NSString *groupId = StartPrivateChat(user1, user2);
	[self actionChat:groupId];
}

#pragma mark - FacebookFriendsDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didSelectFacebookUser:(PFUser *)user2
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFUser *user1 = [PFUser currentUser];
	NSString *groupId = StartPrivateChat(user1, user2);
	[self actionChat:groupId];
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [messages count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	MessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagesCell" forIndexPath:indexPath];
	[cell bindData:messages[indexPath.row]];
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return NO;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	DeleteMessageItem(messages[indexPath.row]);
	[messages removeObjectAtIndex:indexPath.row];
	[tableMessages deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self updateEmptyView];
	[self updateTabCounter];
}

#pragma mark - Table view delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	PFObject *message = messages[indexPath.row];
	[self actionChat:message[PF_MESSAGES_GROUPID]];
}

@end
