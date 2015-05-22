//
//  ZSSMuscleGroup.h
//  Swole
//
//  Created by Zachary Shakked on 5/22/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, ZSSExerciseDefinition, ZSSMuscleGroup, ZSSWorkout;

@interface ZSSMuscleGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *accessoryExercises;
@property (nonatomic, retain) NSSet *childMuscleGroups;
@property (nonatomic, retain) NSSet *parentMuscleGroups;
@property (nonatomic, retain) NSSet *primaryExercises;
@property (nonatomic, retain) NSSet *workouts;
@property (nonatomic, retain) NSSet *workoutTemplates;
@end

@interface ZSSMuscleGroup (CoreDataGeneratedAccessors)

- (void)addAccessoryExercisesObject:(ZSSExerciseDefinition *)value;
- (void)removeAccessoryExercisesObject:(ZSSExerciseDefinition *)value;
- (void)addAccessoryExercises:(NSSet *)values;
- (void)removeAccessoryExercises:(NSSet *)values;

- (void)addChildMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)removeChildMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)addChildMuscleGroups:(NSSet *)values;
- (void)removeChildMuscleGroups:(NSSet *)values;

- (void)addParentMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)removeParentMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)addParentMuscleGroups:(NSSet *)values;
- (void)removeParentMuscleGroups:(NSSet *)values;

- (void)addPrimaryExercisesObject:(ZSSExerciseDefinition *)value;
- (void)removePrimaryExercisesObject:(ZSSExerciseDefinition *)value;
- (void)addPrimaryExercises:(NSSet *)values;
- (void)removePrimaryExercises:(NSSet *)values;

- (void)addWorkoutsObject:(ZSSWorkout *)value;
- (void)removeWorkoutsObject:(ZSSWorkout *)value;
- (void)addWorkouts:(NSSet *)values;
- (void)removeWorkouts:(NSSet *)values;

- (void)addWorkoutTemplatesObject:(NSManagedObject *)value;
- (void)removeWorkoutTemplatesObject:(NSManagedObject *)value;
- (void)addWorkoutTemplates:(NSSet *)values;
- (void)removeWorkoutTemplates:(NSSet *)values;

@end
