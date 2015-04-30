//
//  ZSSExercise.h
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, ZSSWorkout;

@interface ZSSExercise : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSSet *sets;
@property (nonatomic, retain) NSManagedObject *exerciseDefinition;
@property (nonatomic, retain) ZSSWorkout *workout;
@end

@interface ZSSExercise (CoreDataGeneratedAccessors)

- (void)addSetsObject:(NSManagedObject *)value;
- (void)removeSetsObject:(NSManagedObject *)value;
- (void)addSets:(NSSet *)values;
- (void)removeSets:(NSSet *)values;

@end
