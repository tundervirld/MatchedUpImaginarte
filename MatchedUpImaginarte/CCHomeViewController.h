//
//  CCHomeViewController.h
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 07-12-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMatchViewController.h"

@interface CCHomeViewController : UIViewController<CCMatchViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;

@property (strong, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;

@property (strong, nonatomic) NSArray *photos;

@property (strong, nonatomic) PFObject *photo;

@property (nonatomic) int currentPhotoIndex;

@property (nonatomic) BOOL isLikedByCurrentUser;

@property (nonatomic) BOOL isDislikedByCurrentUser;

@property (strong, nonatomic) NSMutableArray *activities;

- (IBAction)likeButtonPressed:(UIButton *)sender;

- (IBAction)dislikeButtonPressed:(UIButton *)sender;

- (IBAction)infoButtonPressed:(UIButton *)sender;

@end
