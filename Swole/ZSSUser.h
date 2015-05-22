//
//  ZSSUser.h
//  Swole
//
//  Created by Zachary Shakked on 5/22/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, ZSSWorkout;

@interface ZSSUser : NSManagedObject

@property (nonatomic, retain) NSSet *workouts;
@property (nonatomic, retain) NSSet *workoutTemplates;
@end

@interface ZSSUser (CoreDataGeneratedAccessors)

- (void)addWorkoutsObject:(ZSSWorkout *)value;
- (void)removeWorkoutsObject:(ZSSWorkout *)value;
- (void)addWorkouts:(NSSet *)values;
- (void)removeWorkouts:(NSSet *)values;

- (void)addWorkoutTemplatesObject:(NSManagedObject *)value;
- (void)removeWorkoutTemplatesObject:(NSManagedObject *)value;
- (void)addWorkoutTemplates:(NSSet *)values;
- (void)removeWorkoutTemplates:(NSSet *)values;

@end
