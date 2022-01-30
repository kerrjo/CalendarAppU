//
//  MainPagingViewController.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/29/22.
//

import UIKit

/**
 Primary view for collanedat month view
 container view for page view controller
 */
class MainPagingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private weak var monthPageView: UIPageViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        monthPageView = segue.destination as? UIPageViewController
        monthPageView.dataSource = self
        beginPageViewController()
    }
    
    private func beginPageViewController() {
        guard let destination = storyboard?.instantiateViewController(withIdentifier: "MonthView") as? MainCalendarViewController else { return }
        
        let viewModel = MonthViewModel(cancelling: true)
        
        // ensure the view loads before installing
        let _ = destination.view
        
        destination.installedViewModel = viewModel
        monthPageView.setViewControllers([destination], direction: .forward, animated: false, completion: nil)
    }
}

extension MainPagingViewController: UIPageViewControllerDataSource {
    /**
     The Before datasource method takes the month and year from the source MainCalendarViewController
     instantiates a new viewModel from that information using the day 1
     and calls the `previousMonth()` calculation method before installing on a new MainCalendarViewController
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let source = viewController as? MainCalendarViewController else { return nil }
        guard let destination = storyboard?.instantiateViewController(withIdentifier: "MonthView") as? MainCalendarViewController else { return nil }
        
        let monthCalculator = MonthCalculation(m: source.viewModel.current, d: 1, y: source.viewModel.year)
        monthCalculator.previousMonth()
        
        let viewModel = MonthViewModel(with: monthCalculator, cancelling: true)
        
        // ensure the view loads before installing
        let _ = destination.view
        
        destination.installedViewModel = viewModel
        return destination
    }
    
    /**
     The After datasource method takes the month and year from the source MainCalendarViewController
     instantiates a new viewModel from that information using the day 1
     and calls the `nextMonth()` calculation method before installing on a new MainCalendarViewController
     */
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let source = viewController as? MainCalendarViewController else { return nil }
        guard let destination = storyboard?.instantiateViewController(withIdentifier: "MonthView") as? MainCalendarViewController else { return nil }
        
        let monthCalculator = MonthCalculation(m: source.viewModel.current, d: 1, y: source.viewModel.year)
        monthCalculator.nextMonth()
        
        let viewModel = MonthViewModel(with: monthCalculator, cancelling: true)
        
        // ensure the view loads before installing
        let _ = destination.view
        
        destination.installedViewModel = viewModel
        return destination
    }
}
