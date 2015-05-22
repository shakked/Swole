//
//  ZSSJournalParentViewController.swift
//  Swole
//
//  Created by Zachary Shakked on 4/29/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

@objc class ZSSJournalParentViewController: UIViewController, UIPageViewControllerDataSource {

    var pageController : UIPageViewController!
    var screenShots : [UIImage]! = []
    var backgroundColor : UIColor!
    var titleTexts : [String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageViewController()
        configureViews()
    }

    func configurePageViewController() -> Void {
        self.pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        self.pageController.dataSource = self
        self.pageController.view.frame = self.view.bounds
        
        let initialViewController : ZSSJournalTableViewController = self.viewControllerAtIndexAndDate(0, date: NSDate())
        var viewControllers : [ZSSJournalTableViewController] = [initialViewController]
        self.pageController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.addChildViewController(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMoveToParentViewController(self)
    }
    
    func configureViews() -> Void {
        configureNav()
    }
    
    func configureNav() -> Void {
        let navBar = self.navigationController!.navigationBar
        navBar.translucent = false
        navBar.barTintColor = UIColor(rgba: "#e74c3c")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ZSSJournalTableViewController).index
        var date = (viewController as! ZSSJournalTableViewController).date
        date = date.dateByAddingTimeInterval(-60*24*60)
        index--
        return self.viewControllerAtIndexAndDate(index, date: date)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ZSSJournalTableViewController).index
        var date = (viewController as! ZSSJournalTableViewController).date
        date = date.dateByAddingTimeInterval(60*24*60)
        
        index++
        return self.viewControllerAtIndexAndDate(index, date: date)
    }
    
    func viewControllerAtIndexAndDate(index: Int, date: NSDate) -> ZSSJournalTableViewController {
        let childViewController = ZSSJournalTableViewController()
        childViewController.index = index
        childViewController.date = date
        self.view.backgroundColor = backgroundColor
        return childViewController
    }


}
