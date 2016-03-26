//
//  LevelSelectorPageViewController.swift
//  FinalProject
//
//  Created by Melvin Tan Jun Keong on 23/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//

import UIKit
import Darwin

class LevelSelectorPageViewController: UIViewController, UIPageViewControllerDataSource,
    UIPageViewControllerDelegate {
    
    private let filesArchive = FilesArchive()
    var numberOfItemsPerPage: Int?
    var totalNumberOfItems: Int {
        return filesArchive.getFileNames().count
    }
    var totalNumberOfPages: Int?
    private var pageViewController: UIPageViewController?
    var currentStoryboard: UIStoryboard?
    var previousViewController: UIViewController?
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        setupPageControl()
    }
    
    private func createPageViewController() {
        let pageController = self.currentStoryboard!.instantiateViewControllerWithIdentifier(
            "LevelSelectorPageViewController") as! UIPageViewController
        pageController.dataSource = self
        
        if totalNumberOfPages > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers = [firstController]
            pageController.setViewControllers(startingViewControllers,
                direction: UIPageViewControllerNavigationDirection.Forward,
                animated: false,
                completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! LevelSelectorViewController
        
        if itemController.pageIndex! > 0 {
            return getItemController(itemController.pageIndex!-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! LevelSelectorViewController
        
        if itemController.pageIndex!+1 < totalNumberOfPages {
            return getItemController(itemController.pageIndex!+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> LevelSelectorViewController? {
        
        if itemIndex < totalNumberOfPages {
            let pageItemController = self.currentStoryboard!.instantiateViewControllerWithIdentifier(
                "LevelSelectorViewController") as! LevelSelectorViewController
            pageItemController.pageIndex = itemIndex
            let remainder = totalNumberOfItems % numberOfItemsPerPage!
            var numberOfFileNamesInPage: Int {
                if itemIndex == totalNumberOfPages! - 1 && remainder != 0 {
                    return remainder
                } else {
                    return numberOfItemsPerPage!
                }
            }
            var fileNames: [String] = []
            for fileNumberInPage in 0..<numberOfFileNamesInPage {
                let index = itemIndex * numberOfItemsPerPage! + fileNumberInPage
                if index < totalNumberOfItems {
                    fileNames.append(filesArchive.getFileNames()[index])
                }
            }
            pageItemController.fileNames = fileNames
            pageItemController.previousViewController = previousViewController
            pageItemController.pageViewController = self
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return totalNumberOfPages!
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}