//
//  CCHomeViewController.m
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 07-12-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import "CCHomeViewController.h"
#import "CCTestUser.h"
#import "CCProfileViewController.h"

@interface CCHomeViewController ()

@end

@implementation CCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //create test USer
    [CCTestUser saveTestUserToParse];
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kCCPhotoClassKey];

    //leave until later
    [query whereKey:kCCPhotoUserKey notEqualTo:[PFUser currentUser]];
    
    [query includeKey:kCCPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", [error description]);
        }else
            self.photos = objects;
            [self queryForCurrentPhotoIndex];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Mehtods
- (void)queryForCurrentPhotoIndex
{
    if ([self.photos count] > 0) {
        self.photo = self.photos[self.currentPhotoIndex];
        PFFile *file = self.photo[kCCPhotoPictureKey];
        [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.photoImageView.image = image;
                [self updateView];
            }else{
                NSLog(@"%@", [error description]);
            }
            
            PFQuery *queryForLike = [PFQuery queryWithClassName:kCCActivityClassKey];
            [queryForLike whereKey:kCCActivityTypeKey  equalTo:kCCActivityTypeLikeKey];
            [queryForLike whereKey:kCCActivityPhotoKey equalTo:self.photo];
            [queryForLike whereKey:kCCActivityFromUserKey equalTo:[PFUser currentUser]];
            
            PFQuery *queryForDislike = [PFQuery queryWithClassName:kCCActivityClassKey];
            [queryForDislike whereKey:kCCActivityTypeKey equalTo:kCCActivityTypeDislikeKey];
            [queryForDislike whereKey:kCCActivityPhotoKey equalTo:self.photo];
            [queryForDislike whereKey:kCCActivityFromUserKey equalTo:[PFUser currentUser]];
            
            PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
            [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error){
                    self.activities = [objects mutableCopy];
                    if ([self.activities count] == 0) {
                        self.isLikedByCurrentUser = NO;
                        self.isDislikedByCurrentUser = NO;
                    } else {
                        PFObject *activity = self.activities[0];
                        if ([activity[kCCActivityTypeKey] isEqualToString:kCCActivityTypeLikeKey]){
                            self.isLikedByCurrentUser = YES;
                            self.isDislikedByCurrentUser = NO;
                        }
                        else if ([activity[kCCActivityTypeKey] isEqualToString:kCCActivityTypeDislikeKey]){
                            self.isLikedByCurrentUser = NO;
                            self.isDislikedByCurrentUser = YES;
                        }
                        else {
                            //Some other type of activity
                        }
                    }
                    self.likeButton.enabled = YES;
                    self.dislikeButton.enabled = YES;
                    self.infoButton.enabled = YES;
                }
            }];
        }];
    }
}
- (void)updateView
{
    self.firstNameLabel.text = self.photo[kCCPhotoUserKey][kCCUserProfileKey][kCCUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.photo[kCCPhotoUserKey][kCCUserProfileKey][kCCUserProfileAgeKey]];
    self.tagLineLabel.text = self.photo[kCCPhotoUserKey][kCCUserTagLineKey];
}

-(void)setupNextPhoto
{
    if (self.currentPhotoIndex + 1 <self.photos.count)
    {
        self.currentPhotoIndex ++;
        [self queryForCurrentPhotoIndex];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No More Users to View" message:@"Check Back Later for more People!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)saveLike {
    PFObject *likeActivity = [PFObject objectWithClassName:kCCActivityClassKey];
    [likeActivity setObject:kCCActivityTypeLikeKey forKey:kCCActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kCCActivityFromUserKey];
    [likeActivity setObject:[self.photo objectForKey:kCCPhotoUserKey] forKey:kCCActivityToUserKey];
    [likeActivity setObject:self.photo forKey:kCCActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject: likeActivity];
        [self setupNextPhoto];
    }];
}
- (void)checkLike
{
    if (self.isLikedByCurrentUser){
        [self setupNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser){
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else [self saveLike];
}

- (void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kCCActivityClassKey];
    [dislikeActivity setObject:kCCActivityTypeDislikeKey forKey:kCCActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kCCActivityFromUserKey];
    [dislikeActivity setObject:[self.photo objectForKey:kCCPhotoUserKey] forKey:kCCActivityToUserKey];
    [dislikeActivity setObject:self.photo forKey:kCCActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        [self.activities addObject: dislikeActivity];
        [self setupNextPhoto];
    }];

}
- (void)checkDislike
{
    if (self.isDislikedByCurrentUser){
        [self setupNextPhoto];
        return;
    }
    else if (self.isLikedByCurrentUser){
        for (PFObject *activity in self.activities) {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }else{
        [self saveDislike];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"homeToProfileSegue"]){
        CCProfileViewController *profileVC = segue.destinationViewController;
        profileVC.photo = self.photo;
    }
    
}

- (IBAction)likeButtonPressed:(UIButton *)sender{
    [self checkLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender{
    [self checkDislike];
}


- (IBAction)infoButtonPressed:(UIButton *)sender{
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}


@end
