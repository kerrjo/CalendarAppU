//
//  MainCalendarViewController.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/26/22.
//

import UIKit

class MainCalendarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        monthLabel.text = monthView.viewModel.yearMonthTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        monthView.viewModel.startMonth()
    }

    @IBOutlet var monthLabel: UILabel!

    @IBAction func previousAction(_ sender: Any) {
        print(#function)
        monthView.viewModel.previous()
        monthLabel.text = monthView.viewModel.yearMonthTitle
    }
    
    @IBAction func nextAction(_ sender: Any) {
        print(#function)
        monthView.viewModel.next()
        monthLabel.text = monthView.viewModel.yearMonthTitle
    }
    
    private weak var monthView: MonthViewController!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        monthView = segue.destination as? MonthViewController
    }
}
