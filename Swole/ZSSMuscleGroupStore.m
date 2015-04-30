//
//  ZSSMuscleGroupStore.m
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import "ZSSMuscleGroupStore.h"
#import "ZSSMuscleGroup.h"
#import "ZSSExercise.h"
#import "ZSSExerciseDefinition.h"
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
}


- (void)loadMuscleGroupsAndExercises{
    ZSSMuscleGroup *chest = [ZSSMuscleGroup muscleGroupWithName:@"Chest"];
    ZSSMuscleGroup *legs = [ZSSMuscleGroup muscleGroupWithName:@"Legs"];
    ZSSMuscleGroup *arms = [ZSSMuscleGroup muscleGroupWithName:@"Arms"];
    ZSSMuscleGroup *shoulders = [ZSSMuscleGroup muscleGroupWithName:@"Shoulders"];
    ZSSMuscleGroup *back = [ZSSMuscleGroup muscleGroupWithName:@"Back"];
    ZSSMuscleGroup *cardio = [ZSSMuscleGroup muscleGroupWithName:@"Cardio"];
    ZSSMuscleGroup *core = [ZSSMuscleGroup muscleGroupWithName:@"Core"];
    
    ZSSMuscleGroup *upperChest = [ZSSMuscleGroup muscleGroupWithName:@"Upper Chest" parentMuscleGroups:@[chest]];
    ZSSMuscleGroup *middleChest = [ZSSMuscleGroup muscleGroupWithName:@"Middle Chest" parentMuscleGroups:@[chest]];
    ZSSMuscleGroup *lowerChest = [ZSSMuscleGroup muscleGroupWithName:@"Lower Chest" parentMuscleGroups:@[chest]];
    
    ZSSMuscleGroup *quads = [ZSSMuscleGroup muscleGroupWithName:@"Quads" parentMuscleGroups:@[legs]];
    ZSSMuscleGroup *calves = [ZSSMuscleGroup muscleGroupWithName:@"Calves" parentMuscleGroups:@[legs]];
    ZSSMuscleGroup *glutes = [ZSSMuscleGroup muscleGroupWithName:@"Glutes" parentMuscleGroups:@[legs]];
    ZSSMuscleGroup *hamstrings = [ZSSMuscleGroup muscleGroupWithName:@"Hamstrings" parentMuscleGroups:@[legs]];
    
    ZSSMuscleGroup *biceps = [ZSSMuscleGroup muscleGroupWithName:@"Biceps" parentMuscleGroups:@[arms]];
    ZSSMuscleGroup *triceps = [ZSSMuscleGroup muscleGroupWithName:@"Triceps" parentMuscleGroups:@[arms]];
    ZSSMuscleGroup *forearms = [ZSSMuscleGroup muscleGroupWithName:@"Forearms" parentMuscleGroups:@[arms]];

    ZSSMuscleGroup *traps = [ZSSMuscleGroup muscleGroupWithName:@"Traps" parentMuscleGroups:@[shoulders, back]];
    ZSSMuscleGroup *rearDelts = [ZSSMuscleGroup muscleGroupWithName:@"Rear Delts" parentMuscleGroups:@[shoulders]];
    ZSSMuscleGroup *lateralDelts = [ZSSMuscleGroup muscleGroupWithName:@"Lateral Delts" parentMuscleGroups:@[shoulders]];
    ZSSMuscleGroup *frontDelts = [ZSSMuscleGroup muscleGroupWithName:@"Front Delts" parentMuscleGroups:@[shoulders]];
    
    ZSSMuscleGroup *lats = [ZSSMuscleGroup muscleGroupWithName:@"Lats" parentMuscleGroups:@[back]];
    ZSSMuscleGroup *lowerBack = [ZSSMuscleGroup muscleGroupWithName:@"Lower Back" parentMuscleGroups:@[back]];
    ZSSMuscleGroup *upperBack = [ZSSMuscleGroup muscleGroupWithName:@"Upper Back" parentMuscleGroups:@[back]];
    
    ZSSMuscleGroup *abs = [ZSSMuscleGroup muscleGroupWithName:@"Abs" parentMuscleGroups:@[core]];
    ZSSMuscleGroup *obliques = [ZSSMuscleGroup muscleGroupWithName:@"Obliques" parentMuscleGroups:@[core]];
    
    ZSSExercise *barbellFlatBenchPress = [ZSSExerciseDefinition exerciseWithName:@"Barbell Flat Bench Press" primaryMuscleGroup:middleChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *basbellInclineBenchPres = [ZSSExerciseDefinition exerciseWithName:@"Barbell Incline Bench Press" primaryMuscleGroup:upperChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *dumbbellFlatBenchPress = [ZSSExerciseDefinition exerciseWithName:@"Dumbbell Flat Bench Press" primaryMuscleGroup:middleChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *inclinedumbbellPress = [ZSSExerciseDefinition exerciseWithName:@"Incline Dumbbell Press" primaryMuscleGroup:upperChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *declinedumbbellPress = [ZSSExerciseDefinition exerciseWithName:@"Decline Dumbbell Press" primaryMuscleGroup:lowerChest accessoryMuscleGroups:@[frontDelts, triceps]];
    
    ZSSExerciseDefinition *wideGripDips = [ZSSExerciseDefinition exerciseWithName:@"Wide Grip Dips" primaryMuscleGroup:chest accessoryMuscleGroups:@[triceps]];

    ZSSExerciseDefinition *machineInclinePress = [ZSSExerciseDefinition exerciseWithName:@"Machine Incline Press" primaryMuscleGroup:upperChest accessoryMuscleGroups:@[triceps]];
    
    ZSSExerciseDefinition *machineFlatPress = [ZSSExerciseDefinition exerciseWithName:@"Machine Flat Press" primaryMuscleGroup:middleChest accessoryMuscleGroups:@[triceps]];
    
    ZSSExerciseDefinition *machineDeclinePress = [ZSSExerciseDefinition exerciseWithName:@"Machine Decline Press" primaryMuscleGroup:lowerChest accessoryMuscleGroups:@[triceps]];
    
    ZSSExerciseDefinition *dumbbellFlatFlys = [ZSSExerciseDefinition exerciseWithName:@"Flat Dumbbell Flys" primaryMuscleGroup:middleChest accessoryMuscleGroups:@[]];
    ZSSExerciseDefinition *dumbbellInclineFlys = [ZSSExerciseDefinition exerciseWithName:@"Incline Dumbbell Flys" primaryMuscleGroup:upperChest accessoryMuscleGroups:@[]];
    ZSSExerciseDefinition *dumbbellDeclineFlys = [ZSSExerciseDefinition exerciseWithName:@"Decline Dumbbell Flys" primaryMuscleGroup:lowerChest accessoryMuscleGroups:@[]];
    
    ZSSExerciseDefinition *standingCableCrossovers = [ZSSExerciseDefinition exerciseWithName:@"Standing Cable Crossovers" primaryMuscleGroup:chest accessoryMuscleGroups:@[]];
}

@end
