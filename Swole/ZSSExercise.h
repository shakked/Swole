//
//  ZSSExercise.h
//  Swole
//
//  Created by Zachary Shakked on 5/22/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZSSExerciseDefinition, ZSSSet, ZSSWorkout;

@interface ZSSExercise : NSManagedObject

@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) ZSSExerciseDefinition *exerciseDefinition;
@property (nonatomic, retain) NSSet *sets;
@property (nonatomic, retain) ZSSWorkout *workout;
@end

@interface ZSSExercise (CoreDataGeneratedAccessors)

- (void)addSetsObject:(ZSSSet *)value;
- (void)removeSetsObject:(ZSSSet *)value;
- (void)addSets:(NSSet *)values;
- (void)removeSets:(NSSet *)values;

@end
