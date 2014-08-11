//
//  MenuUitklapbaarViewController.m
//  Vittles
//
//  Created by Anne Everars on 26/02/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "MenuUitklapbaarViewController.h"
#import "ECSlidingViewController.h"

@interface MenuUitklapbaarViewController ()

@property (strong, nonatomic) NSArray *menuNames;
@property (strong, nonatomic) NSArray *menuIcons;

@end

@implementation MenuUitklapbaarViewController

@synthesize menuNames;
@synthesize menuIcons;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.menuNames = [NSArray arrayWithObjects:@"", @"Hoofdpagina", @"Profiel", @"Voedingsdagboek", @"Activiteitenlogboek", @"Vooruitgang", @"Doelstellingen", @"Nieuwsoverzicht", @"Tips", @"Instellingen", nil];
    self.menuNames = [NSArray arrayWithObjects:@"", @"Hoofdpagina", @"Profiel", @"Voedingsdagboek", @"Activiteitenlogboek", @"Vooruitgang", @"Doelstellingen", @"Tips", @"Instellingen", nil];
    
    //self.menuIcons = [NSArray arrayWithObjects: @"", @"main.png", @"profile.png", @"food.png", @"activity.png", @"report.png", @"goal.png", @"news.png", @"tips.png", @"settings.png", nil];
    
    self.menuIcons = [NSArray arrayWithObjects: @"", @"main.png", @"profile.png", @"food.png", @"activity.png", @"report.png", @"goal.png", @"tips.png", @"settings.png", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.menuNames objectAtIndex:indexPath.row]];
    UIImage *theImage = [UIImage imageNamed:[self.menuIcons objectAtIndex:indexPath.row]];
    cell.imageView.image = theImage;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=0){
        NSString *identifier = [NSString stringWithFormat:@"%@", [self.menuNames objectAtIndex:indexPath.row]];
    
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
    }];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
