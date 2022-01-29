//
//  MainPagingViewController.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/29/22.
//

import UIKit

class MainPagingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    private weak var monthPageView: UIPageViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        monthPageView = segue.destination as? UIPageViewController
        monthPageView.dataSource = self
        
        if let destination = storyboard?.instantiateViewController(withIdentifier: "MonthView") as? MainCalendarViewController {
            let viewModel = MonthViewModel(cancelling: true)
            let _ = destination.view
            destination.installedViewModel = viewModel
            monthPageView.setViewControllers([destination], direction: .forward, animated: false, completion: nil)
        }
    }
}

extension MainPagingViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let source = viewController as? MainCalendarViewController else { return nil }
        let monthCalculator = MonthCalculation(m: source.viewModel.current, d: 1, y: source.viewModel.year)
        monthCalculator.previousMonth()
        let viewModel = MonthViewModel(with: monthCalculator, cancelling: true)
        print(viewModel.current, viewModel.monthName, viewModel.year)
        if let destination = storyboard?.instantiateViewController(withIdentifier: "MonthView") as? MainCalendarViewController {
            let _ = destination.view
            destination.installedViewModel = viewModel
            return destination
        }
        print(viewModel.current, viewModel.monthName, viewModel.year)
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let source = viewController as? MainCalendarViewController else { return nil }
        let monthCalculator = MonthCalculation(m: source.viewModel.current, d: 1, y: source.viewModel.year)
        monthCalculator.nextMonth()
        let viewModel = MonthViewModel(with: monthCalculator, cancelling: true)
        
        if let destination = storyboard?.instantiateViewController(withIdentifier: "MonthView") as? MainCalendarViewController {
            let _ = destination.view
            destination.installedViewModel = viewModel
            return destination
        }
        print(viewModel.current, viewModel.monthName, viewModel.year)
        return nil
        
    }
}
