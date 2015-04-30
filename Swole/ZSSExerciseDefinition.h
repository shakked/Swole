//
//  ZSSExerciseDefinition.h
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZSSExercise, ZSSMuscleGroup;

@interface ZSSExerciseDefinition : NSManagedObject

@property (nonatomic, retain) NSString * explanation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * tutorialURL;
@property (nonatomic, retain) NSSet *accessoryMuscleGroup;
@property (nonatomic, retain) ZSSMuscleGroup *primaryMuscleGroup;
@property (nonatomic, retain) NSSet *exampleExercises;
@end

@interface ZSSExerciseDefinition (CoreDataGeneratedAccessors)

- (void)addAccessoryMuscleGroupObject:(ZSSMuscleGroup *)value;
- (void)removeAccessoryMuscleGroupObject:(ZSSMuscleGroup *)value;
- (void)addAccessoryMuscleGroup:(NSSet *)values;
- (void)removeAccessoryMuscleGroup:(NSSet *)values;

- (void)addExampleExercisesObject:(ZSSExercise *)value;
- (void)removeExampleExercisesObject:(ZSSExercise *)value;
- (void)addExampleExercises:(NSSet *)values;
- (void)removeExampleExercises:(NSSet *)values;

+ (instancetype)exerciseWithName:(NSString *)name
//                     explanation:(NSString *)explanation
//                     tutorialURL:(NSString *)tutorialURL
                         primaryMuscleGroup:(ZSSMuscleGroup *)muscleGroup
                      accessoryMuscleGroups:(NSArray *)accessoryMuscleGroups;
@end
