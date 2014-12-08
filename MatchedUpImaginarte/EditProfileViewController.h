//
//  EditProfileViewController.h
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 07-12-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;

@property (strong, nonatomic) IBOutlet UITextView *tagLineTextView;

- (IBAction)saveBarButtonItemPressed:(id)sender;
@end
