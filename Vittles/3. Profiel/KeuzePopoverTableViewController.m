//
//  KeuzePopoverTableViewController.m
//  Vittles
//
//  Created by Anne Everars on 24/06/14.
//  Copyright (c) 2014 Anne Everars. All rights reserved.
//

#import "KeuzePopoverTableViewController.h"
#import "CustomCell.h"

@interface KeuzePopoverTableViewController () {
    BOOL eerste;
    NSArray *eersteRij;
    NSArray *tweedeRij;
}

@end

@implementation KeuzePopoverTableViewController

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
    eerste = YES;
    eersteRij = [[NSArray alloc]initWithObjects:@"Bekijk profielfoto", @"Wijzig profielfoto", nil];
    tweedeRij = [[NSArray alloc]initWithObjects:@"Maak foto", @"Kies bestaande foto", nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CustomCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!Cell) {
        Cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(eerste) {
        Cell.textLabel.text = [eersteRij objectAtIndex:indexPath.row];
    }
    else {
        Cell.textLabel.text = [tweedeRij objectAtIndex:indexPath.row];
    }
    return Cell;
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(eerste) {
        if(indexPath.row==1) {
            //Wijzig profielfoto
            eerste = NO;
            [self.tableView reloadData];
        }
        else {
            //Bekijk profielfoto
        }
    }
    else {
        if(indexPath.row==1) {
            //Kies een bestaande foto
            [self.delegate KeuzePopoverTableViewControllerDidFinish:self withType:@"bestaande"];
        }
        else {
            //Maak een foto
            [self.delegate KeuzePopoverTableViewControllerDidFinish:self withType:@"nieuwe"];
        }
    }
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

@end
