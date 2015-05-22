//
//  ZSSWorkout.h
//  Swole
//
//  Created by Zachary Shakked on 5/22/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, ZSSExercise, ZSSMuscleGroup, ZSSUser;

@interface ZSSWorkout : NSManagedObject

@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSSet *exercises;
@property (nonatomic, retain) NSSet *targetedMuscleGroups;
@property (nonatomic, retain) NSManagedObject *workoutTemplate;
@property (nonatomic, retain) ZSSUser *author;
@end

@interface ZSSWorkout (CoreDataGeneratedAccessors)

- (void)addExercisesObject:(ZSSExercise *)value;
- (void)removeExercisesObject:(ZSSExercise *)value;
- (void)addExercises:(NSSet *)values;
- (void)removeExercises:(NSSet *)values;

- (void)addTargetedMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)removeTargetedMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)addTargetedMuscleGroups:(NSSet *)values;
- (void)removeTargetedMuscleGroups:(NSSet *)values;

@end
