//
//  ZSSMuscleGroupStore.h
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZSSExercise;
@class ZSSMuscleGroup;
@class ZSSExerciseDefinition;
@class ZSSSet;
@class ZSSWorkout;

@interface ZSSMuscleGroupStore : NSObject

+ (instancetype)sharedStore;
- (BOOL)saveCoreDataChanges;

- (ZSSMuscleGroup *)createNewMuscleGroup;
- (ZSSExerciseDefinition *)createNewExerciseDefinition;
- (ZSSWorkout *)createNewWorkout;
- (ZSSExercise *)createNewExercise;
- (ZSSSet *)createNewSet;

- (NSArray *)workoutsForDate:(NSDate *)date;
- (NSArray *)muscleGroups;

- (void)createWorkoutWithName:(NSString *)name;
- (void)createExerciseWithExerciseDefinition:(ZSSExerciseDefinition *)exerciseDefinition
                                     workout:(ZSSWorkout *)workout;


@end
