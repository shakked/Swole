//
//  ZSSMuscleGroupStore.m
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  I am a huge faggot and like to eat shit. 
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import "ZSSMuscleGroupStore.h"
#import "ZSSMuscleGroup.h"
#import "ZSSExercise.h"
#import "ZSSExerciseDefinition.h"
#import "ZSSWorkout.h"
@import CoreData;

@interface ZSSMuscleGroupStore()

@property (nonatomic, strong) NSMutableArray *privateMuscleGroups;
@property (nonatomic, strong) NSMutableArray *privateExerciseDefinitions;
@property (nonatomic, strong) NSMutableArray *privateWorkouts;
@property (nonatomic, strong) NSMutableArray *privateExercises;
@property (nonatomic, strong) NSMutableArray *privateSets;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;


@end

@implementation ZSSMuscleGroupStore


+ (instancetype)sharedStore {
    static ZSSMuscleGroupStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (BOOL)saveCoreDataChanges {
    
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (BOOL)shouldCreateInitialMuscleGroupsAndExerciseDefinitions{
    if (self.privateExerciseDefinitions.count == 0 && self.privateMuscleGroups.count == 0) {
        return YES;
    } else if (self.privateExerciseDefinitions.count == 0 && self.privateMuscleGroups.count != 0) {
        [self throwMuscleGroupAndExerciseDefinitionException];
    } else if (self.privateExerciseDefinitions.count != 0 && self.privateMuscleGroups.count == 0) {
        [self throwMuscleGroupAndExerciseDefinitionException];
    }
    return NO;
}

- (void)throwMuscleGroupAndExerciseDefinitionException {
    @throw [NSException exceptionWithName:@"MuscleGroupAndExerciseDefinitionException" reason:@"Either privateMuscleGroups xor privateExerciseDefinitions has 0 elemnts." userInfo:@{@"muscleGroups": self.privateMuscleGroups,
                                                                               @"exerciseDefinitions": self.privateExerciseDefinitions}];
}

- (ZSSMuscleGroup *)createNewMuscleGroup {
    ZSSMuscleGroup *muscleGroup = [NSEntityDescription insertNewObjectForEntityForName:@"ZSSMuscleGroup"
                                                                inManagedObjectContext:self.context];
    [self.privateMuscleGroups addObject:muscleGroup];
    return muscleGroup;
}

- (ZSSExerciseDefinition *)createNewExerciseDefinition {
    ZSSExerciseDefinition *exerciseDefinition = [NSEntityDescription insertNewObjectForEntityForName:@"ZSSExerciseDefinition"
                                                                              inManagedObjectContext:self.context];
    [self.privateExerciseDefinitions addObject:exerciseDefinition];
    return exerciseDefinition;
}

- (ZSSWorkout *)createNewWorkout {
    ZSSWorkout *workout = [NSEntityDescription insertNewObjectForEntityForName:@"ZSSWorkout"
                                                        inManagedObjectContext:self.context];
    [self.privateWorkouts addObject:workout];
    return workout;
}

- (ZSSExercise *)createNewExercise {
    ZSSExercise *exercise = [NSEntityDescription insertNewObjectForEntityForName:@"ZSSExercise"
                                                  inManagedObjectContext:self.context];
    [self.privateExercises addObject:exercise];
    return exercise;
}

- (ZSSSet *)createNewSet {
    ZSSSet *set = [NSEntityDescription insertNewObjectForEntityForName:@"ZSSSet"
                                                inManagedObjectContext:self.context];
    [self.privateSets addObject:set];
    return set;
}

#pragma mark - Retrieval Methods

- (NSArray *)workoutsForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSMutableArray *workouts = [[NSMutableArray alloc] init];
    for (ZSSWorkout *workout in self.privateWorkouts) {
        if ([calendar isDate:workout.date inSameDayAsDate:date]) {
            [workouts addObject:workout];
        }
    }
    return workouts;
}

- (NSArray *)muscleGroups {
    return self.privateMuscleGroups;
}


- (instancetype)initPrivate {

    self = [super init];
    
    if (self) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSInferMappingModelAutomaticallyOption: @YES
                                  };
        BOOL successOfAdding = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:options
                                                         error:&error] != nil;
        if (successOfAdding == NO)
        {
            // Check if the database is there.
            // If it is there, it most likely means that model has changed significantly.
            if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path])
            {
                // Delete the database
                [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
                // Trying to add a database to the coordinator again
                successOfAdding = [psc addPersistentStoreWithType: NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:nil
                                                            error:&error] != nil;
                if (successOfAdding == NO)
                {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        
        [self loadAllItems];
    }
    
    if ([self shouldCreateInitialMuscleGroupsAndExerciseDefinitions]) {
        [self loadMuscleGroupsAndExercises];
    }
    return self;
}

- (NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (void)loadAllItems {
    
    if (!self.privateMuscleGroups) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZSSMuscleGroup"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateMuscleGroups = [[NSMutableArray alloc] initWithArray:result];
    }
    
    if (!self.privateExerciseDefinitions) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZSSExerciseDefinition"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateExerciseDefinitions = [[NSMutableArray alloc] initWithArray:result];
    }
    
    if (!self.privateWorkouts) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZSSWorkout"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateWorkouts = [[NSMutableArray alloc] initWithArray:result];
    }
    
    if (!self.privateExercises) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZSSExercise"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateExercises = [[NSMutableArray alloc] initWithArray:result];
    }

    if (!self.privateSets) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZSSSet"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateSets = [[NSMutableArray alloc] initWithArray:result];
    }
   
}

- (ZSSMuscleGroup *)muscleGroupWithName:(NSString *)name {
    ZSSMuscleGroup *muscleGroup = [self createNewMuscleGroup];
    muscleGroup.name = name;
    
    return muscleGroup;
}

- (ZSSMuscleGroup *)muscleGroupWithName:(NSString *)name parentMuscleGroups:(NSArray *)parentMuscleGroups {
    ZSSMuscleGroup *muscleGroup = [self createNewMuscleGroup];
    muscleGroup.name = name;
    [muscleGroup addParentMuscleGroups:[NSSet setWithArray:parentMuscleGroups]];
    return muscleGroup;
}

- (ZSSExerciseDefinition *)exerciseWithName:(NSString *)name
                         primaryMuscleGroup:(ZSSMuscleGroup *)muscleGroup
                      accessoryMuscleGroups:(NSArray *)accessoryMuscleGroups {
    ZSSExerciseDefinition *exerciseDefinition = [self createNewExerciseDefinition];
    exerciseDefinition.primaryMuscleGroup = muscleGroup;
    exerciseDefinition.name = name;
    [exerciseDefinition addAccessoryMuscleGroup:[NSSet setWithArray:accessoryMuscleGroups]];
    return exerciseDefinition;
}

- (void)createWorkoutWithName:(NSString *)name {
    ZSSWorkout *workout = [self createNewWorkout];
    workout.name = name;
    NSDate *now = [NSDate date];
    workout.date = now;
    workout.startTime = now;
}

- (void)createExerciseWithExerciseDefinition:(ZSSExerciseDefinition *)exerciseDefinition
                                     workout:(ZSSWorkout *)workout {
    ZSSExercise *exercise = [self createNewExercise];
    exercise.time = [NSDate date];
    exercise.exerciseDefinition = exerciseDefinition;
    exercise.workout = workout;
    
}

- (void)loadMuscleGroupsAndExercises{
    ZSSMuscleGroup *chest = [self muscleGroupWithName:@"Chest"];
    
    ZSSMuscleGroup *legs = [self muscleGroupWithName:@"Legs"];
    ZSSMuscleGroup *arms = [self muscleGroupWithName:@"Arms"];
    ZSSMuscleGroup *shoulders = [self muscleGroupWithName:@"Shoulders"];
    ZSSMuscleGroup *back = [self muscleGroupWithName:@"Back"];
    ZSSMuscleGroup *cardio = [self muscleGroupWithName:@"Cardio"];
    ZSSMuscleGroup *core = [self muscleGroupWithName:@"Core"];
    
    ZSSMuscleGroup *upperChest = [self muscleGroupWithName:@"Upper Chest" parentMuscleGroups:@[chest]];
    ZSSMuscleGroup *middleChest = [self muscleGroupWithName:@"Middle Chest" parentMuscleGroups:@[chest]];
    ZSSMuscleGroup *lowerChest = [self muscleGroupWithName:@"Lower Chest" parentMuscleGroups:@[chest]];
    
    ZSSMuscleGroup *quads = [self muscleGroupWithName:@"Quads" parentMuscleGroups:@[legs]];
    ZSSMuscleGroup *calves = [self muscleGroupWithName:@"Calves" parentMuscleGroups:@[legs]];
    ZSSMuscleGroup *glutes = [self muscleGroupWithName:@"Glutes" parentMuscleGroups:@[legs]];
    ZSSMuscleGroup *hamstrings = [self muscleGroupWithName:@"Hamstrings" parentMuscleGroups:@[legs]];
    
    ZSSMuscleGroup *biceps = [self muscleGroupWithName:@"Biceps" parentMuscleGroups:@[arms]];
    ZSSMuscleGroup *triceps = [self muscleGroupWithName:@"Triceps" parentMuscleGroups:@[arms]];
    ZSSMuscleGroup *forearms = [self muscleGroupWithName:@"Forearms" parentMuscleGroups:@[arms]];

    ZSSMuscleGroup *traps = [self muscleGroupWithName:@"Traps" parentMuscleGroups:@[shoulders, back]];
    ZSSMuscleGroup *rearDelts = [self muscleGroupWithName:@"Rear Delts" parentMuscleGroups:@[shoulders]];
    ZSSMuscleGroup *lateralDelts = [self muscleGroupWithName:@"Lateral Delts" parentMuscleGroups:@[shoulders]];
    ZSSMuscleGroup *frontDelts = [self muscleGroupWithName:@"Front Delts" parentMuscleGroups:@[shoulders]];
    
    ZSSMuscleGroup *lats = [self muscleGroupWithName:@"Lats" parentMuscleGroups:@[back]];
    ZSSMuscleGroup *lowerBack = [self muscleGroupWithName:@"Lower Back" parentMuscleGroups:@[back]];
    ZSSMuscleGroup *upperBack = [self muscleGroupWithName:@"Upper Back" parentMuscleGroups:@[back]];
    
    ZSSMuscleGroup *abs = [self muscleGroupWithName:@"Abs" parentMuscleGroups:@[core]];
    ZSSMuscleGroup *obliques = [self muscleGroupWithName:@"Obliques" parentMuscleGroups:@[core]];
    
    ZSSExerciseDefinition *barbellFlatBenchPress = [self exerciseWithName:@"Barbell Flat Bench Press" primaryMuscleGroup:middleChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *basbellInclineBenchPres = [self exerciseWithName:@"Barbell Incline Bench Press" primaryMuscleGroup:upperChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *dumbbellFlatBenchPress = [self exerciseWithName:@"Dumbbell Flat Bench Press" primaryMuscleGroup:middleChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *inclinedumbbellPress = [self exerciseWithName:@"Incline Dumbbell Press" primaryMuscleGroup:upperChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *declinedumbbellPress = [self exerciseWithName:@"Decline Dumbbell Press" primaryMuscleGroup:lowerChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *wideGripDips = [self exerciseWithName:@"Wide Grip Dips" primaryMuscleGroup:chest accessoryMuscleGroups:@[triceps]];

    ZSSExerciseDefinition *machineInclinePress = [self exerciseWithName:@"Machine Incline Press" primaryMuscleGroup:upperChest accessoryMuscleGroups:@[triceps]];
    
    ZSSExerciseDefinition *machineFlatPress = [self exerciseWithName:@"Machine Flat Press" primaryMuscleGroup:middleChest accessoryMuscleGroups:@[triceps]];
    
    ZSSExerciseDefinition *machineDeclinePress = [self exerciseWithName:@"Machine Decline Press" primaryMuscleGroup:lowerChest accessoryMuscleGroups:@[triceps]];
    
    ZSSExerciseDefinition *dumbbellFlatFlys = [self exerciseWithName:@"Flat Dumbbell Flys" primaryMuscleGroup:middleChest accessoryMuscleGroups:@[]];
    ZSSExerciseDefinition *dumbbellInclineFlys = [self exerciseWithName:@"Incline Dumbbell Flys" primaryMuscleGroup:upperChest accessoryMuscleGroups:@[]];
    ZSSExerciseDefinition *dumbbellDeclineFlys = [self exerciseWithName:@"Decline Dumbbell Flys" primaryMuscleGroup:lowerChest accessoryMuscleGroups:@[]];
    
    ZSSExerciseDefinition *standingCableCrossovers = [self exerciseWithName:@"Standing Cable Crossovers" primaryMuscleGroup:chest accessoryMuscleGroups:@[]];
    
}

@end
