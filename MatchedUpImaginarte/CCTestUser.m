//
//  CCTestUser.m
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 07-12-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import "CCTestUser.h"

@implementation CCTestUser

+(void)saveTestUserToParse
{
    
    PFUser *newUser = [PFUser user];
    newUser.username = @"user1";
    newUser.password = @"password1";
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        NSLog(@"sign up %@", error);
        NSDictionary *profile = @{@"age" : @28, @"birthday" : @"11/22/1985", @"firstName" : @"Julie", @"gender" : @"female", @"location" : @"Berlin, Germany", @"name" : @"Juanito Perez"};
        [newUser setObject:profile forKey:@"profile"];
        [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            UIImage *profileImage = [UIImage imageNamed:@"TestUserPicture.jpg"];
            NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.5);
            PFFile *photoFile = [PFFile fileWithData:imageData];
            [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded){
                    PFObject *photo = [PFObject objectWithClassName:kCCPhotoClassKey];
                    [photo setObject:newUser forKey:kCCPhotoUserKey];
                    [photo setObject:photoFile forKey:kCCPhotoPictureKey];
                    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        NSLog(@"Photo saved successfully");
                    }];
                }
            }];
        }];
    }];
}
@end
