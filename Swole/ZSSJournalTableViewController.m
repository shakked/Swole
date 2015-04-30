//
//  ZSSJournalTableViewController.m
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import "ZSSJournalTableViewController.h"
#import "Swole-Swift.h"
#import "ZSSMuscleGroupStore.h"

@interface ZSSJournalTableViewController ()

@property (nonatomic, strong) NSArray *workouts;

@end

@implementation ZSSJournalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ZSSHeaderView" owner:self options:nil] objectAtIndex:0];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.tableView.tableHeaderView.frame.size.height - 20);
    [self configureCells];
}

- (void)configureCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"ExerciseCell" bundle:nil] forCellReuseIdentifier:@"exerciseCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddCell" bundle:nil] forCellReuseIdentifier:@"addCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadWorkoutsDate:self.date];
    
    ZSSHeaderView *headerView = (ZSSHeaderView *)self.tableView.tableHeaderView;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE | MMM d, yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:self.date];
    [headerView.dateButton setTitle:stringFromDate forState:UIControlStateNormal];
}

- (void)loadWorkoutsDate:(NSDate *)date {
    self.workouts = [[ZSSMuscleGroupStore sharedStore] workoutsForDate:date];

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Workouts";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

@end
