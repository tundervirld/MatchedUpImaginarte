//
//  CCMatchViewController.h
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 08-12-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCMatchViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *matchUserImageView;
@property (strong, nonatomic) IBOutlet UIImageView *currentUserImageView;
@property (strong, nonatomic) IBOutlet UIButton *viewChatsButton;
@property (strong, nonatomic) IBOutlet UIButton *keepSearchingButtton;
- (IBAction)viewChatsButtonPressed:(UIButton *)sender;
- (IBAction)keepSearchingButtonPressed:(UIButton *)sender;

@end
