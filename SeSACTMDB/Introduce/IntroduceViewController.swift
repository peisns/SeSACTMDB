//
//  IntroduceViewController.swift
//  SeSACTMDB
//
//  Created by Brother Model on 2022/08/18.
//

import UIKit

class IntroduceViewController: UIPageViewController {

    var introduceChildList: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        createPageViewController()
        configurePageViewController()
    }

    func createPageViewController() {
        let child01vc = IntroduceChild01ViewController()
        let child02vc = IntroduceChild02ViewController()
        let child03vc = IntroduceChild03ViewController()
        
        introduceChildList = [child01vc, child02vc, child03vc]
    }
    
    func configurePageViewController() {
        delegate = self
        dataSource = self
        
        guard let first = introduceChildList.first else { return }
        setViewControllers([first], direction: .forward, animated: true)
    }
}

extension IntroduceViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = introduceChildList.firstIndex(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        return previousIndex < 0 ? nil : introduceChildList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = introduceChildList.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        return nextIndex >= introduceChildList.count ? nil : introduceChildList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return introduceChildList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = viewControllers?.first, let index = introduceChildList.firstIndex(of: first) else { return 0 }
        return index
    }
    
    
}
