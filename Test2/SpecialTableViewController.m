//
//  SpecialTableViewController.m
//  Test2
//
//  Created by Not For You to Use on 03/06/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "SpecialTableViewController.h"
#import "ArticlesTableViewController.h"
#import "CreditsVC.h"
#import "StatisticsVC.h"

@interface SpecialTableViewController ()

@end

@implementation SpecialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.splitViewController){
        self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        self.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = cell.contentView.backgroundColor;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[tableView headerViewForSection:indexPath.section].textLabel.text isEqualToString:@"WEBSITE"] || [[tableView headerViewForSection:indexPath.section].textLabel.text isEqualToString:@"Website"]) {
        
        if ([[tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"Website"]){
           
            NSString *urlString = @"http://psalterapp.weebly.com";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([segue.identifier isEqualToString:@"articlesSegue"]) {
        ArticlesTableViewController *aTVC = segue.destinationViewController;
        
        aTVC.navigationItem.title = cell.textLabel.text;
        
    } else if ([segue.identifier isEqualToString:@"creditsSegue"]){
        CreditsVC *cVC = segue.destinationViewController;
        cVC.navigationItem.title = cell.textLabel.text;
    } else if ([segue.identifier isEqualToString:@"statisticsSegue"]){
        StatisticsVC *sVC = segue.destinationViewController;
        sVC.navigationItem.title = cell.textLabel.text;

    }
}




@end
