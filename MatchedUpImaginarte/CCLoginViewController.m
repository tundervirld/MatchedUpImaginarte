//
//  CCLoginViewController.m
//  MatchedUpImaginarte
//
//  Created by Roger Reyes on 30-11-14.
//  Copyright (c) 2014 com.inzpiral. All rights reserved.
//

#import "CCLoginViewController.h"


@interface CCLoginViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) NSMutableData * imageData;

@end

@implementation CCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated

{
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self updateUserInformation];
        NSLog(@"the user is already signed in ");
        [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
    }
    
}



#pragma mark - IbActions

- (IBAction)loginButtonPressed:(UIButton *)sender {
//    FBLoginView *loginView = [[FBLoginView alloc] init];
//    loginView.center = self.view.center;
//    [self.view addSubview:loginView];
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
   // NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        [_activityIndicator stopAnimating]; // Hide loading indicator
        self.activityIndicator.hidden = YES;
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            //[self _presentUserDetailsViewControllerAnimated:YES];
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginToHomeSegue" sender:self];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
    self.activityIndicator.hidden = NO;
    
}

#pragma marks - Set Data user for Facebook
- (void)updateUserInformation {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSMutableDictionary *userProfile = [NSMutableDictionary new ];
            
            userProfile[@"facebookID"] = userData[@"id"];
            userProfile[kCCUserProfileNameKey] = userData[@"name"];
            userProfile[kCCUserProfileFirstNameKey]  = userData[@"first_name"];
            userProfile[kCCUserProfileLocation]  = userData[@"location"][@"name"];
            userProfile[kCCUserProfileGender]  = userData[@"gender"];
            userProfile[kCCUserProfileBirthday]  = userData[@"birthday"];
            
            //get age
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateStyle:NSDateFormatterShortStyle];
            
            NSDate *date = [formatter dateFromString:userData[@"birthday"]];
            
            NSDate *now = [NSDate date];
            
            NSTimeInterval seconds = [now timeIntervalSinceDate: date];
            
            int age = seconds / 31536000;
            if (age) {
                userProfile[kCCUserProfileAgeKey] = @(age);
            }
            //End get date
            
            
            //userProfile[@"interested_in"]  = userData[@"interested_in"];
            //userProfile[kCCUserProfileAgeKey]  = userData[@"age"];
            if(userData[@"relationship_status"]){
                userProfile[kCCUserProfileRelationshipStatusKey]  = userData[@"relationship_status"];}
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", userProfile[@"facebookID"]]];
            //https://graph.facebook.com/271117166345905/picture?type=large&return_ssl_resources=1
            if ([pictureURL absoluteString]) {
                userProfile[kCCUserProfilePictureURL] = [pictureURL absoluteString];
            }

            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            
            // Run network request asynchronously
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 if (connectionError == nil && data != nil) {
                     // Set the image in the header imageView
                     self.headerImageView.image = [UIImage imageWithData:data];
                 }
             }];
            
            // Now add the data to the UI elements
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            
            [[PFUser currentUser] saveInBackground];
            
            [self requestImage];
            
        }else{
            NSLog(@"Error in Facebook Request %@", [error description]);
        }
    }];
}

- (void)requestImage
{
    
    PFQuery *query = [PFQuery queryWithClassName:kCCPhotoClassKey];
    
    [query whereKey:kCCPhotoUserKey equalTo:[PFUser currentUser]];
    
    //Use count instead
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (number == 0){
            PFUser *user = [PFUser currentUser];
            self.imageData = [[NSMutableData alloc] init];
            
            NSURL *profilePictureURL = [NSURL URLWithString:user[kCCUserProfileKey][kCCUserProfilePictureURL]];
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
            
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            if (!urlConnection) {
                NSLog(@"Failed to download picture");
            }
        }
    }];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    // As chuncks of the image are received, we build our data file
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // All data has been downloaded, now we can set the image in the header image view
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];
}

-(void)uploadPFFileToParse:(UIImage *)image{
    // JPEG to decrease file size and enable faster uploads & downloads
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    
    if(!imageData){
        NSLog(@"imageData was not found.");
        return;
    }
    
    PFFile *photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *photo = [PFObject objectWithClassName:kCCPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kCCPhotoUserKey];
            [photo setObject:photoFile forKey:kCCPhotoPictureKey];
            
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                NSLog(@"Photo Save SuccessFully");
            }];
        }
    }];
    
}
@end
