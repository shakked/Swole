//
//  ZSSMuscleGroup.h
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, ZSSMuscleGroup;

@interface ZSSMuscleGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *parentMuscleGroups;
@property (nonatomic, retain) NSSet *childMuscleGroups;
@property (nonatomic, retain) NSSet *primaryExercises;
@property (nonatomic, retain) NSSet *accessoryExercises;
@property (nonatomic, retain) NSSet *workouts;
@end

@interface ZSSMuscleGroup (CoreDataGeneratedAccessors)

- (void)addParentMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)removeParentMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)addParentMuscleGroups:(NSSet *)values;
- (void)removeParentMuscleGroups:(NSSet *)values;

- (void)addChildMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)removeChildMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)addChildMuscleGroups:(NSSet *)values;
- (void)removeChildMuscleGroups:(NSSet *)values;

- (void)addPrimaryExercisesObject:(NSManagedObject *)value;
- (void)removePrimaryExercisesObject:(NSManagedObject *)value;
- (void)addPrimaryExercises:(NSSet *)values;
- (void)removePrimaryExercises:(NSSet *)values;

- (void)addAccessoryExercisesObject:(NSManagedObject *)value;
- (void)removeAccessoryExercisesObject:(NSManagedObject *)value;
- (void)addAccessoryExercises:(NSSet *)values;
- (void)removeAccessoryExercises:(NSSet *)values;

- (void)addWorkoutsObject:(NSManagedObject *)value;
- (void)removeWorkoutsObject:(NSManagedObject *)value;
- (void)addWorkouts:(NSSet *)values;
- (void)removeWorkouts:(NSSet *)values;

+ (instancetype)muscleGroupWithName:(NSString *)name;
+ (instancetype)muscleGroupWithName:(NSString *)name parentMuscleGroups:(NSArray *)parentMuscleGroups;


@end
