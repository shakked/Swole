//
//  ZSSExerciseDefinition.m
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import "ZSSExerciseDefinition.h"
#import "ZSSExercise.h"
#import "ZSSMuscleGroup.h"
#import "ZSSMuscleGroupStore.h"


@implementation ZSSExerciseDefinition

@dynamic explanation;
@dynamic name;
@dynamic tutorialURL;
@dynamic accessoryMuscleGroup;
@dynamic primaryMuscleGroup;
@dynamic exampleExercises;

+ (instancetype)exerciseWithName:(NSString *)name
                     //explanation:(NSString *)explanation
                     //tutorialURL:(NSString *)tutorialURL
              primaryMuscleGroup:(ZSSMuscleGroup *)muscleGroup
           accessoryMuscleGroups:(NSArray *)accessoryMuscleGroups {
    ZSSExerciseDefinition *exerciseDefinition = [[ZSSMuscleGroupStore sharedStore] createNewExerciseDefinition];
//    exerciseDefinition.explanation = explanation;
  //  exerciseDefinition.tutorialURL = tutorialURL;
    exerciseDefinition.primaryMuscleGroup = muscleGroup;
    [exerciseDefinition addAccessoryMuscleGroup:[NSSet setWithArray:accessoryMuscleGroups]];
    return exerciseDefinition;
}


@end
