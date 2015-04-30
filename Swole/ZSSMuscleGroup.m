//
//  ZSSMuscleGroup.m
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import "ZSSMuscleGroup.h"
#import "ZSSMuscleGroupStore.h"

@implementation ZSSMuscleGroup

@dynamic name;
@dynamic parentMuscleGroups;
@dynamic childMuscleGroups;
@dynamic primaryExercises;
@dynamic accessoryExercises;
@dynamic workouts;

+ (instancetype)muscleGroupWithName:(NSString *)name {
    ZSSMuscleGroup *muscleGroup = [[ZSSMuscleGroupStore sharedStore] createNewMuscleGroup];
    muscleGroup.name = name;
    return muscleGroup;
}

+ (instancetype)muscleGroupWithName:(NSString *)name parentMuscleGroups:(NSArray *)parentMuscleGroups {
    ZSSMuscleGroup *muscleGroup = [[ZSSMuscleGroupStore sharedStore] createNewMuscleGroup];
    muscleGroup.name = name;
    [muscleGroup addParentMuscleGroups:[NSSet setWithArray:parentMuscleGroups]];
    return muscleGroup;
}

@end
