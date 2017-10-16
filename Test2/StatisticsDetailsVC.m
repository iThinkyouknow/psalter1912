//
//  StatisticsDetailsVC.m
//  The Psalter
//
//  Created by Not For You to Use on 18/08/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "StatisticsDetailsVC.h"
#import "PsalterStatistics.h"

@interface StatisticsDetailsVC () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL ascendingForLastSung;
@property (nonatomic, strong) PsalterStatistics *statistics;
@property (nonatomic) CGFloat defaultFontSize;
@end

@implementation StatisticsDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ascendingForLastSung = NO;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.defaultFontSize = 18;
    
    self.statistics = [[PsalterStatistics alloc] init];
    [self.statistics getStatsForPsalter:self.navigationItem.title type:@"Last Sung" ascending:self.ascendingForLastSung];
    [self showWarning:[self.statistics.psalterStatsArray count]];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.statistics.psalterStatsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    
    if ([self.statistics.psalterStatsArray[indexPath.row] isKindOfClass:[NSDate class]]) {
        
        NSDate *dateLastSung = self.statistics.psalterStatsArray[indexPath.row];
        cell.textLabel.text = [NSDateFormatter localizedStringFromDate:dateLastSung dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
        
        double min = 60;
        double hour = 60 * min;
        double day = hour * 24;
        
        double timeInterval = -dateLastSung.timeIntervalSinceNow;
        
        
        
        NSDateComponents *dateComps = [[NSCalendar currentCalendar]
                                       components: (kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond)
                                       fromDate:dateLastSung
                                       toDate:[NSDate date]
                                       options:0];
        
        NSString *detailText;
        
        if (timeInterval < min) {
            
            detailText = [NSString stringWithFormat:@"%ld seconds ago...", (long)dateComps.second];
            
        } else if (timeInterval < hour) {
            
            detailText = [NSString stringWithFormat:@"%ld min & %ld sec ago...", (long)dateComps.minute, (long)dateComps.second];
            
        } else if (timeInterval < day) {
            detailText = [NSString stringWithFormat:@"About %ld hour(s) ago", (long)dateComps.hour];
            
        } else if ((dateComps.year == 0) && (dateComps.month == 0)) {
            detailText = [NSString stringWithFormat:@"About %ld day(s) ago", (long)dateComps.day];
            
        } else if (dateComps.year == 0) {
            detailText = [NSString stringWithFormat:@"About %ld month(s) ago", (long)dateComps.month];
            
        } else {
            detailText = [NSString stringWithFormat:@"About %ld year(s) ago ago", (long)dateComps.year];
        }
        
        cell.detailTextLabel.text = detailText;
        
    } else {
        
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:self.defaultFontSize * 1];
        cell.textLabel.text = self.statistics.psalterStatsArray[indexPath.row];
        
        
    }
        
    return cell;
}

- (void)showWarning:(NSInteger)count {
    
    NSString *alertTitle;
    NSString *alertMessage;
    NSString *alertOkButtonText;
    
    if (count <= 5) {
        
        if ([[self.statistics.psalterStatsArray firstObject] isKindOfClass:[NSDate class]]) {
            alertTitle = @"Improvement Needed!";
            alertMessage = @"Surely, you can sing me more often!\nI believe you can do it!";
            alertOkButtonText = @"Thank you for the encouragement!";
            
            if ([UIAlertController class] == nil) { //[UIAlertController class] returns nil on iOS 7 and older. You can use whatever method you want to check that the system version is iOS 8+
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                    message:alertMessage
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:alertOkButtonText, nil];
                [alertView show];
                
            }
            else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                                         message:alertMessage
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                //Add buttons to the alert controller by creating UIAlertActions:
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:alertOkButtonText
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:nil]; //Use a block here to handle a press on this button
                [alertController addAction:actionOk];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            
            
        } else {
            alertTitle = @"Shoo! Nothing to see here!";
            alertMessage = @"You have been neglecting me, haven't you? 😤\nStop that! Do the right thing:\nSing me now!";
            alertOkButtonText = @"I will sing you, I promise!";
            
            if ([UIAlertController class] == nil) { //[UIAlertController class] returns nil on iOS 7 and older. You can use whatever method you want to check that the system version is iOS 8+
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                    message:alertMessage
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:alertOkButtonText, nil];
                [alertView show];
                
            }
            else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle
                                                                                         message:alertMessage
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                //Add buttons to the alert controller by creating UIAlertActions:
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:alertOkButtonText
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action){
                                                                     [self.navigationController popViewControllerAnimated:YES];
                                                                 }]; //Use a block here to handle a press on this button
                [alertController addAction:actionOk];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = cell.contentView.backgroundColor;
}
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

- (IBAction)lastSungPressed:(UISegmentedControl *)sender {
    
    self.ascendingForLastSung = sender.selectedSegmentIndex == 0 ? YES : NO;
    
    
    [self.statistics getStatsForPsalter:self.navigationItem.title type:@"Last Sung" ascending:self.ascendingForLastSung];
    [self.tableView reloadData];
    [self.tableView scrollsToTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
