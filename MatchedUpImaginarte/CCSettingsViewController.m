//
//  CCSettingsViewController.m
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 07-12-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import "CCSettingsViewController.h"

@interface CCSettingsViewController ()

@end

@implementation CCSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ageSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kCCAgeMaxKey];
    self.menSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kCCMenEnabledKey];
    self.womenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kCCWomenEnabledKey];
    self.singleSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kCCSingleEnabledKey];

    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singleSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    //setup UI
    self.ageLabel.text = [NSString stringWithFormat:@"%i",(int)self.ageSlider.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)logoutButtonPressed:(id)sender{
    [PFUser logOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)editProfileButtonPressed:(id)sender{
}

#pragma mark - Helper
-(void)valueChanged:(id)sender

{
    if (sender == self.ageSlider)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:self.ageSlider.value forKey:kCCAgeMaxKey];
        self.ageLabel.text = [NSString stringWithFormat:@"%i",(int)self.ageSlider.value];
    }
    else if (sender == self.menSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.menSwitch.isOn forKey:kCCMenEnabledKey];
    }
    else if (sender == self.womenSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.womenSwitch.isOn forKey:kCCWomenEnabledKey];
    }
    else if (sender == self.singleSwitch)
    {
        [[NSUserDefaults standardUserDefaults] setBool:self.singleSwitch.isOn forKey:kCCSingleEnabledKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
