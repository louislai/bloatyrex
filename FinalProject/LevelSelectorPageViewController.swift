//
//  LevelSelectorPageViewController.swift
//  FinalProject
//
//  Created by Melvin Tan Jun Keong on 23/3/16.
//  Copyright © 2016 nus.cs3217.2016Group6. All rights reserved.
//
//  Handles the displaying of the different pages of levels in the level selector.
//

import UIKit
import Darwin

class LevelSelectorPageViewController: UIViewController, UIPageViewControllerDataSource,
    UIPageViewControllerDelegate, UISearchBarDelegate {

    var numberOfItemsPerPage: Int?
    var package: String?
    private let filesArchive = FilesArchive()
    private var totalNumberOfItems: Int {
        if searchActive {
            return filtered.count
        } else {
            return data.count
        }
    }
    private var totalNumberOfPages: Int {
        if totalNumberOfItems == LevelSelectorPageViewControllerConstants.noItems {
            return LevelSelectorPageViewControllerConstants.singlePage
        } else {
            return Int(ceil(Double(totalNumberOfItems) / Double(numberOfItemsPerPage!)))
        }
    }
    private var pageViewController: UIPageViewController?
    var previousViewController: UIViewController?
    var searchBar: UISearchBar?
    private var searchActive: Bool = false
    private var data: [String] {
        if previousViewController is PackageSelectorViewController {
            return filesArchive.getFileNamesFromPackage(package!)
        } else {
            return filesArchive.getFileNames()
        }
    }
    var filtered: [String] = []
    var navigationBar: UINavigationBar?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        setupPageControl()

        if previousViewController is LevelDesigningViewController {
            searchBar = UISearchBar(frame:
                LevelSelectorPageViewControllerConstants.levelDesignSelectorSearchBarFrame)
            searchBar?.placeholder = LevelSelectorPageViewControllerConstants.searchingText
            view.addSubview(searchBar!)
            searchBar?.delegate = self

            navigationBar = UINavigationBar(frame:
                LevelSelectorPageViewControllerConstants.levelDesignSelectorNavigationBarFrame)
            navigationBar?.backgroundColor = UIColor.whiteColor()
            resetNavigationBar()
            self.view.addSubview(navigationBar!)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if previousViewController is LevelDesigningViewController {
            if filtered.count == LevelSelectorPageViewControllerConstants.noItems &&
                (searchBar?.text?.isEmpty)! {
                searchActive = false
            } else {
                searchActive = true
            }
        }
        resetViewControllers()
        setupPageControl()
    }

    private func createPageViewController() {
        let pageController = self.storyboard!
            .instantiateViewControllerWithIdentifier(
                GlobalConstants.Identifier.levelSelectorPageViewController
            ) as! UIPageViewController
        pageController.dataSource = self
        pageController.view.frame = LevelSelectorPageViewControllerConstants.pageControllerFrame

        if totalNumberOfPages > LevelSelectorPageViewControllerConstants.noPages {
            let firstController =
                getItemController(LevelSelectorPageViewControllerConstants.firstItem)!
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

    private func resetViewControllers() {
        if totalNumberOfPages > LevelSelectorPageViewControllerConstants.noPages {
            let firstController =
                getItemController(LevelSelectorPageViewControllerConstants.firstItem)!
            let startingViewControllers = [firstController]
            pageViewController!.setViewControllers(startingViewControllers,
                direction: UIPageViewControllerNavigationDirection.Forward,
                animated: false,
                completion: nil)
        }
    }

    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.blackColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.brownColor()
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

        let itemController = viewController as! LevelSelectorViewController

        if itemController.pageIndex! > LevelSelectorPageViewControllerConstants.firstPage {
            return getItemController(itemController.pageIndex! - 1)
        }

        return nil
    }

    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {

        let itemController = viewController as! LevelSelectorViewController

        if itemController.pageIndex! + 1 < totalNumberOfPages {
            return getItemController(itemController.pageIndex! + 1)
        }

        return nil
    }

    private func getItemController(itemIndex: Int) -> LevelSelectorViewController? {

        if itemIndex < totalNumberOfPages {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier(
                    GlobalConstants.Identifier.levelSelectorViewController
                ) as! LevelSelectorViewController
            pageItemController.pageIndex = itemIndex
            let remainder = totalNumberOfItems % numberOfItemsPerPage!
            var numberOfFileNamesInPage: Int {
                if itemIndex == totalNumberOfPages - 1 && remainder !=
                    LevelSelectorPageViewControllerConstants.noItems {
                    return remainder
                } else {
                    return numberOfItemsPerPage!
                }
            }
            var fileNames: [String] = []
            for fileNumberInPage in 0..<numberOfFileNamesInPage {
                let index = itemIndex * numberOfItemsPerPage! + fileNumberInPage
                if index < totalNumberOfItems {
                    if searchActive {
                        fileNames.append(filtered[index])
                    } else {
                        fileNames.append(data[index])
                    }
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
        return totalNumberOfPages
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    // MARK: - Search Bar

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if filtered.count == LevelSelectorPageViewControllerConstants.noItems &&
            searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
        }
        viewDidAppear(false)
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }

    // - MARK: - Navigation Bar

    func resetNavigationBar() {
        navigationItem.title = LevelSelectorPageViewControllerConstants.headerText
        navigationItem.leftBarButtonItems = nil
        navigationItem.rightBarButtonItem = nil

        navigationBar?.items = [navigationItem]
    }
}
