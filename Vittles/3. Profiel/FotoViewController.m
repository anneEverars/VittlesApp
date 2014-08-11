//
//  FotoViewController.m
//  Vittles
//
//  Created by Anne Everars on 8/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "FotoViewController.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface FotoViewController () {
    BOOL cancel;
}

@end

@implementation FotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    cancel = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    if(!self.imageView.image && !cancel){
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        if([self.type isEqualToString:@"bestaande"]) {
            [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        } else if([self.type isEqualToString:@"nieuwe"]) {
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
    }
    if(cancel) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //[picker dismissViewControllerAnimated:YES completion:nil];
	UIImage *finalImage =[info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.clipsToBounds = YES;
    self.imageView.image = finalImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    cancel = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    UIImage *image = self.imageView.image;
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.05f);
    [self uploadImage:imageData];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.parent refreshProfilepicture:image];
    }];
}

-(void)uploadImage:(NSData *)imageData {
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
            PFUser *user = [PFUser currentUser];
            [query whereKey:@"user" equalTo:user];
            NSArray *results = [query findObjects];
            if([results count] > 0){
                PFObject *userPhoto = [results objectAtIndex:0];
                userPhoto[@"imageFile"] = imageFile;
                [userPhoto save];
            }
            else {
                PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
                [userPhoto setObject:imageFile forKey:@"imageFile"];
                userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
                PFUser *user = [PFUser currentUser];
                [userPhoto setObject:user forKey:@"user"];
                [userPhoto save];
            }
        }
        else{
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
@end
