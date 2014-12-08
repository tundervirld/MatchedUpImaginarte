//
//  CCSettingsViewController.h
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 07-12-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCSettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISlider *ageSlider;

@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;

@property (strong, nonatomic) IBOutlet UISwitch *singleSwitch;

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;

- (IBAction)logoutButtonPressed:(id)sender;
- (IBAction)editProfileButtonPressed:(id)sender;
@end
