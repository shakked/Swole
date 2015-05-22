//
//  ZSSMuscleGroupTableViewController.swift
//  Swole
//
//  Created by Zachary Shakked on 4/30/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

import UIKit

class ZSSMuscleGroupTableViewController: UITableViewController {

    var muscleGroups : [ZSSMuscleGroup]!
    var workout : ZSSWorkout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavBar()
        loadMuscleGroups()
    }
    
    func loadMuscleGroups() -> Void {
        self.muscleGroups = ZSSMuscleGroupStore.sharedStore().muscleGroups() as! [ZSSMuscleGroup]!
    }
    
    func configureNavBar() -> Void {
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelBarButton
    }
    
    func configureTableView() -> Void {
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func cancel() -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let muscleGroup = self.muscleGroups[indexPath.row]
        let edtvc = ZSSExerciseDefinitionTableViewController()
        edtvc.muscleGroup = muscleGroup
        edtvc.workout = self.workout
        self.navigationController!.pushViewController(edtvc, animated: true)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Muscle Groups"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        let muscleGroup = muscleGroups[indexPath.row]
        cell.textLabel!.text = muscleGroup.name
        cell.accessoryType = .DisclosureIndicator
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.muscleGroups.count
    }

}
