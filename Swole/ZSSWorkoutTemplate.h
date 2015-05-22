//
//  ZSSWorkoutTemplate.h
//  Swole
//
//  Created by Zachary Shakked on 5/22/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZSSExercise, ZSSMuscleGroup, ZSSUser, ZSSWorkout;

@interface ZSSWorkoutTemplate : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ZSSUser *author;
@property (nonatomic, retain) NSSet *exampleWorkouts;
@property (nonatomic, retain) NSSet *exercises;
@property (nonatomic, retain) NSSet *targetedMuscleGroups;
@end

@interface ZSSWorkoutTemplate (CoreDataGeneratedAccessors)

- (void)addExampleWorkoutsObject:(ZSSWorkout *)value;
- (void)removeExampleWorkoutsObject:(ZSSWorkout *)value;
- (void)addExampleWorkouts:(NSSet *)values;
- (void)removeExampleWorkouts:(NSSet *)values;

- (void)addExercisesObject:(ZSSExercise *)value;
- (void)removeExercisesObject:(ZSSExercise *)value;
- (void)addExercises:(NSSet *)values;
- (void)removeExercises:(NSSet *)values;

- (void)addTargetedMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)removeTargetedMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)addTargetedMuscleGroups:(NSSet *)values;
- (void)removeTargetedMuscleGroups:(NSSet *)values;

@end
