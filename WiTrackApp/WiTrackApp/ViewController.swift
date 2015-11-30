//
//  ViewController.swift
//  WiTrackApp
//
//  Created by Jamar on 11/28/15.
//  Copyright © 2015 Jamar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        var initialContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DisplayOnlyViewController") // self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController")
        
        var viewControllers = [initialContentViewController!]
        
        self.pageViewController.setViewControllers(viewControllers as [UIViewController]?, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController is PositionViewController {
            return self.storyboard?.instantiateViewControllerWithIdentifier("DisplayOnlyViewController")
        } else if viewController is DisplayOnlyViewController {
            return nil
        } else {
            return self.storyboard?.instantiateViewControllerWithIdentifier("PositionViewController")
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        if viewController is PositionViewController {
            return self.storyboard?.instantiateViewControllerWithIdentifier("HeightViewController")
        } else if viewController is DisplayOnlyViewController{
            return self.storyboard?.instantiateViewControllerWithIdentifier("PosViewController")
        } else {
            return nil
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    @IBAction func LogoutButtonTap(sender: AnyObject) {
        let nextViewController : LogoutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LogoutViewController") as! LogoutViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.window!.rootViewController = nextViewController
    }
    
    
}

