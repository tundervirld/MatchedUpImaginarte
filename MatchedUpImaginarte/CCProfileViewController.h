//
//  CCProfileViewController.h
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 07-12-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;

@property(strong, nonatomic) PFObject *photo;
@end
