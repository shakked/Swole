//
//  ZSSExerciseDefinitionTableViewController.swift
//  Swole
//
//  Created by Zachary Shakked on 4/30/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ZSSExerciseDefinitionTableViewController: UITableViewController {

    var muscleGroup : ZSSMuscleGroup!
    var workout : ZSSWorkout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() -> Void {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.muscleGroup.childMuscleGroups.count + 1
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return self.muscleGroup.name
        } else {
            let childMuscleGroup = Array(self.muscleGroup.childMuscleGroups)[section - 1] as! ZSSMuscleGroup
            return childMuscleGroup.name
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let muscleGroup = self.muscleGroup
            let primaryExerciseDefinitions : [ZSSExerciseDefinition] = Array(muscleGroup.primaryExercises) as! [ZSSExerciseDefinition]
            let primaryExerciseDefinition = primaryExerciseDefinitions[indexPath.row]
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel!.text = primaryExerciseDefinition.name
            println(primaryExerciseDefinition.name)
            return cell
        } else {
            let muscleGroup = Array(self.muscleGroup.childMuscleGroups)[indexPath.section - 1] as! ZSSMuscleGroup
            let primaryExerciseDefinition = Array(muscleGroup.primaryExercises)[indexPath.row] as! ZSSExerciseDefinition
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel!.text = primaryExerciseDefinition.name
            println(primaryExerciseDefinition.name)
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.muscleGroup.primaryExercises.count
        } else {
            let muscleGroup = Array(self.muscleGroup.childMuscleGroups)[section - 1] as! ZSSMuscleGroup
            return muscleGroup.primaryExercises.count
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var primaryExerciseDefinition : ZSSExerciseDefinition
        if indexPath.section == 0 {
            let muscleGroup = self.muscleGroup
            let primaryExerciseDefinitions : [ZSSExerciseDefinition] = Array(muscleGroup.primaryExercises) as! [ZSSExerciseDefinition]
            primaryExerciseDefinition = primaryExerciseDefinitions[indexPath.row]
        } else {
            let muscleGroup = Array(self.muscleGroup.childMuscleGroups)[indexPath.section - 1] as! ZSSMuscleGroup
            primaryExerciseDefinition = Array(muscleGroup.primaryExercises)[indexPath.row] as! ZSSExerciseDefinition
        }
        ZSSMuscleGroupStore.sharedStore().createExerciseWithExerciseDefinition(primaryExerciseDefinition, workout: workout)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
