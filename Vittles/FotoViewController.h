//
//  FotoViewController.h
//  Vittles
//
//  Created by Anne Everars on 8/07/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"

@interface FotoViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, retain) IBOutlet UIImageView * imageView;
@property (nonatomic, retain) NSString *type;
@property (nonatomic,retain) ProfileViewController *parent;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
