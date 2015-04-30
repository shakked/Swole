//
//  ZSSWorkout.h
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, ZSSMuscleGroup;

@interface ZSSWorkout : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *targetedMuscleGroups;
@property (nonatomic, retain) NSSet *exercises;
@end

@interface ZSSWorkout (CoreDataGeneratedAccessors)

- (void)addTargetedMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)removeTargetedMuscleGroupsObject:(ZSSMuscleGroup *)value;
- (void)addTargetedMuscleGroups:(NSSet *)values;
- (void)removeTargetedMuscleGroups:(NSSet *)values;

- (void)addExercisesObject:(NSManagedObject *)value;
- (void)removeExercisesObject:(NSManagedObject *)value;
- (void)addExercises:(NSSet *)values;
- (void)removeExercises:(NSSet *)values;

@end
