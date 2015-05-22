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
#import "ZSSWorkout.h"
#import "ZSSExercise.h"
#import "ZSSExerciseDefinition.h"

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
    [self.tableView registerNib:[UINib nibWithNibName:@"AddCell" bundle:nil] forCellReuseIdentifier:@"setCell"];

}

- (void)viewWillAppear:(BOOL)animated {
    [self loadWorkoutsDate:self.date];
    [self.tableView reloadData];
    
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
    if (self.workouts.count > 0) {
        return self.workouts.count + 1;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"";
    } else {
        ZSSWorkout *workout = self.workouts[section - 1];
        return workout.name;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        ZSSWorkout *workout = self.workouts[section - 1];
        return workout.exercises.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AddCell *addCell = [self.tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
        addCell.addLabel.text = @"Add a Workout";
        return addCell;
    } else if (indexPath.row == 0) {
        AddCell *addCell = [self.tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
        addCell.addLabel.text = @"Add an Exercise";
        return addCell;
    } else {
        ZSSWorkout *workout = self.workouts[indexPath.section - 1];
        ZSSExercise *exercise = workout.exercises.allObjects[indexPath.row - 1];
        ExerciseCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"exerciseCell" forIndexPath:indexPath];
        cell.exerciseName.text = exercise.exerciseDefinition.name;
        return cell;
    }
}

- (NSInteger)getExerciseIndexFromIndexPath:(NSIndexPath *)indexPath andHeaderIndexes:(NSArray *)headerIndexes {
    for (NSInteger i = 0; (i + 1) < headerIndexes.count;i++) {
        NSInteger headerI = ((NSNumber *)headerIndexes[i]).integerValue;
        NSInteger headerI1 = ((NSNumber *)headerIndexes[i + 1]).integerValue;
        if (indexPath.row > headerI && indexPath.row < headerI1) {
            return i;
        }
    }
    return -1;
}


//    if (indexPath.section == 0) {
//        AddCell *cell = (AddCell *)[tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
//        cell.addLabel.text = @"+ Add a Workout";
//        return cell;
//    } else {
//        if (indexPath.row == 0) {
//            AddCell *cell = (AddCell *)[tableView dequeueReusableCellWithIdentifier:@"addCell" forIndexPath:indexPath];
//            cell.addLabel.text = @"+ Add an Exercise";
//            return cell;
//        }
//        ZSSWorkout *workout = self.workouts[indexPath.section - 1];
//        ZSSExercise *exercise = (ZSSExercise *)[workout.exercises allObjects][indexPath.row - 1];
//        ExerciseCell *cell = (ExerciseCell *)[tableView dequeueReusableCellWithIdentifier:@"exerciseCell" forIndexPath:indexPath];
//        cell.exerciseName.text = exercise.exerciseDefinition.name;
//        return cell;
//    }


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    } else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self showCreateWorkout];
    } else {
        if (indexPath.row == 0) {
            ZSSMuscleGroupTableViewController *mtvc = [[ZSSMuscleGroupTableViewController alloc] init];
            mtvc.workout = self.workouts[indexPath.section - 1];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mtvc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}

- (void)showCreateWorkout {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create a New Workout"
                                                                   message:@"Enter the name of your Workout"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [self addWorkoutForAlert:alert];
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Workout Name";
    }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)addWorkoutForAlert:(UIAlertController *)alert {
    UITextField *textField = (UITextField *)alert.textFields.firstObject;
    NSString *workoutName = textField.text;
    if (workoutName.length == 0) {
        workoutName = @"Workout 1";
    }
    
    [[ZSSMuscleGroupStore sharedStore] createWorkoutWithName:workoutName];
    [self loadWorkoutsDate:[NSDate date]];
    [self.tableView reloadData];
}

- (NSArray *)getHeadersIndexesForWorkout:(ZSSWorkout *)workout {
    
    NSMutableArray *exerciseHeaders = [[NSMutableArray alloc] init];
    
    if (workout.exercises.count > 0) {
        int i = 0;
        int exerciseIndex = 0;
        while (i < workout.exercises.count) {
            [exerciseHeaders addObject:[NSNumber numberWithInt:exerciseIndex]];
            ZSSExercise *exercise = workout.exercises.allObjects[i];
            exerciseIndex += exercise.sets.count;
            i++;
        }
    }
    return exerciseHeaders;
}


@end
