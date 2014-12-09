//
//  CCChatViewController.h
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 08-12-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import "JSQMessagesViewController.h"

@interface CCChatViewController : JSQMessagesViewController<JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout>

@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComplete;
@property (strong, nonatomic) NSMutableArray *chats;
@property (strong, nonatomic) PFObject *chatroom;


@end
