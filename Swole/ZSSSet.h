//
//  ZSSSet.h
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ZSSExercise;

@interface ZSSSet : NSManagedObject

@property (nonatomic, retain) NSNumber * reps;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) ZSSExercise *exercise;

@end
