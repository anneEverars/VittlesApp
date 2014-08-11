#import "MasterViewController.h"
#import "PersoonlijkeInstellingenViewController.h"
#import "NotificatieViewController.h"
#import <Parse/Parse.h>

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.splitViewController setDelegate:self];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIStoryboard *storyboard = [self storyboard];
        DetailViewController *newController = nil;
        if([indexPath row]==0) {
            newController = [storyboard instantiateViewControllerWithIdentifier:@"persoonlijkeInst"];
        }
        else if ([indexPath row]==1) {
            newController = [storyboard instantiateViewControllerWithIdentifier:@"notificaties"];
        }
        else if ([indexPath row]==2) {
            newController = [storyboard instantiateViewControllerWithIdentifier:@"Feedback"];
        }
        else if ([indexPath row]==3) {
            newController = [storyboard instantiateViewControllerWithIdentifier:@"Over"];
        }
        else if([indexPath row]==5) {
            [PFUser logOut];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"welkom"];
            [self presentViewController:vc animated:YES completion:nil];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
        UINavigationController *navController = [[[self splitViewController ] viewControllers ] lastObject ];
        DetailViewController *oldController = [[navController viewControllers] firstObject];
        NSArray *newStack = [NSArray arrayWithObjects:newController, nil];
        [navController setViewControllers:newStack];
        UIBarButtonItem *splitViewButton = [[oldController navigationItem] leftBarButtonItem];
        UIPopoverController *popoverController = [oldController masterPopoverController];
        [newController setSplitViewButton:splitViewButton forPopoverController:popoverController];
        if (!UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
            [popoverController dismissPopoverAnimated:YES];
        }
    }
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    UINavigationController *navController = [[[self splitViewController]viewControllers]lastObject];
    DetailViewController *vc = [[navController viewControllers]firstObject];
    [vc setSplitViewButton:barButtonItem forPopoverController:popoverController];
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    UINavigationController *navController = [[[self splitViewController]viewControllers]lastObject];
    DetailViewController *vc = [[navController viewControllers] firstObject];
    [vc setSplitViewButton:nil forPopoverController:nil];
}

@end
