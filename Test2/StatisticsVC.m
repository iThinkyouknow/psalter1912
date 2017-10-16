//
//  StatisticsVC.m
//  The Psalter
//
//  Created by Not For You to Use on 17/08/16.
//  Copyright (c) 2016 Not For You to Use. All rights reserved.
//

#import "StatisticsVC.h"
#import "PsalterStatistics.h"
#import "StatisticsDetailsVC.h"


@interface StatisticsVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) PsalterStatistics *statistics;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL ascendingForNumber;
@property (nonatomic) BOOL ascendingForCount;


@end

@implementation StatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.ascendingForCount = NO;
    self.ascendingForNumber = NO;
    
    if ([self.tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
    self.tableView.sectionIndexBackgroundColor = self.view.backgroundColor;
    }
    
    self.tableView.sectionIndexTrackingBackgroundColor = nil;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.statistics = [[PsalterStatistics alloc] init];
    [self.statistics getStatsForType:@"Count" ascending:self.ascendingForCount];
    [self.tableView reloadData];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     //Return the number of sections.
    double countDouble = [self.statistics psalterCount];
    double division = countDouble / 50;
    NSInteger integer = ceil(division);
    
    return integer;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSInteger numberOfSections = tableView.numberOfSections;
    NSInteger numberOfRows = 1;
    
    if (section == numberOfSections - 1) {
        
        numberOfRows = [self.statistics psalterCount] - 50 * (tableView.numberOfSections - 1);
        
    } else {
        
        numberOfRows = 50;
        
    }
    
    return numberOfRows;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...

    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    
    NSInteger numberOfRowsPerSection = 50;
    
    cell.textLabel.text = self.statistics.psalterStatsArray[numberOfRowsPerSection * indexPath.section + indexPath.row];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Count: %ld",(long)[self.statistics psalterSingCount:cell.textLabel.text]];
    
    return cell;
}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] init];
    
    for(NSInteger i= 1; i <= tableView.numberOfSections; i++ ){
        NSString *str = [NSString stringWithFormat:@"%ld", (long)i];
        [mutArray addObject:str];
    }
    
    return mutArray;
    
}

- (IBAction)segmentedControlPressed:(UISegmentedControl *)sender {
    
    NSString *type = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    
    
    if (sender.selectedSegmentIndex == 0) {
        self.ascendingForCount = !self.ascendingForCount;
        [self.statistics getStatsForType:type ascending:self.ascendingForCount];
        
    } else {
        self.ascendingForNumber = !self.ascendingForNumber;
        [self.statistics getStatsForType:type ascending:self.ascendingForNumber];
        
    }
    [self.tableView reloadData];
    [self.tableView scrollsToTop];
   
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = cell.contentView.backgroundColor;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    StatisticsDetailsVC *destVC = segue.destinationViewController;
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    destVC.navigationItem.title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
