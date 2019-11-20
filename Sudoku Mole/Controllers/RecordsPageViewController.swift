//
//  RecordsPageViewController.swift
//  Sudoku Mole
//
//  Created by 소명훈 on 2019/11/14.
//  Copyright © 2019 cochipcho. All rights reserved.
//

import UIKit

class RecordsPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let firstVC = levelViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(forwardVC),name:NSNotification.Name(rawValue: "forwardVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reverseVC),name:NSNotification.Name(rawValue: "reverseVC"), object: nil)
    }
    
    var pages = [UIViewController]()
    
    internal lazy var levelViewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let easyViewController = storyboard.instantiateViewController(withIdentifier: "easyVC")
        let normalViewController = storyboard.instantiateViewController(withIdentifier: "normalVC")
        let hardViewController = storyboard.instantiateViewController(withIdentifier: "hardVC")
        let expertViewController = storyboard.instantiateViewController(withIdentifier: "expertVC")
        viewControllers.append(easyViewController)
        viewControllers.append(normalViewController)
        viewControllers.append(hardViewController)
        viewControllers.append(expertViewController)
        return viewControllers
    }()
    
    @objc func forwardVC() {
        if GameViewController.index == 3 {
            GameViewController.index = 0
        } else {
            GameViewController.index += 1
        }
        pages.append(levelViewControllers[GameViewController.index])
        setViewControllers(pages, direction: .forward, animated: true, completion: nil)
        self.pages.remove(at: 0)
    }
    
    @objc func reverseVC() {
        if GameViewController.index == 0 {
            GameViewController.index = 3
        } else {
            GameViewController.index -= 1
        }
        pages.append(levelViewControllers[GameViewController.index])
        setViewControllers(pages, direction: .reverse, animated: true, completion: nil)
        self.pages.remove(at: 0)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = levelViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return levelViewControllers[3] }
        guard levelViewControllers.count > previousIndex else { return nil }
        return levelViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = levelViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        let viewControllersCount = levelViewControllers.count
        guard viewControllersCount != nextIndex else { return levelViewControllers[0] }
        guard viewControllersCount > nextIndex else { return levelViewControllers[0] }
        return levelViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        GameViewController.index = levelViewControllers.firstIndex(of: pageContentViewController)!
    }
    
}
