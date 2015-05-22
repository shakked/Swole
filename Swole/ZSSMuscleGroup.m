//
//  ZSSMuscleGroup.m
//  Swole
//
//  Created by Zachary Shakked on 5/22/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import "ZSSMuscleGroup.h"
#import "NSManagedObject.h"
#import "ZSSExerciseDefinition.h"
#import "ZSSMuscleGroup.h"
#import "ZSSWorkout.h"


@implementation ZSSMuscleGroup

@dynamic name;
@dynamic accessoryExercises;
@dynamic childMuscleGroups;
@dynamic parentMuscleGroups;
@dynamic primaryExercises;
@dynamic workouts;
@dynamic workoutTemplates;

@end
