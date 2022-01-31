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
        if isPaging {
            view.backgroundColor = .white.withAlphaComponent(0.92)
            hideNavigationButtons()
        } else {
            updateTitleMonth()
        }
    }
    var isPaging = false
    
    // nonpaging
    
    var viewModel: MonthViewing { monthView.viewModel }

    // paging

    var installedViewModel: MonthViewing? {
        didSet {
            monthView.installedViewModel = installedViewModel
            monthView.viewModel.startMonth()
            updateTitleMonth()
        }
    }


    @IBOutlet var buttonPrevious: UIButton!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var buttonNext: UIButton!

    @IBOutlet var bottomSpacingConstraint: NSLayoutConstraint!
    @IBOutlet var topSpacingConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!

    private func hideNavigationButtons() {
        buttonNext.isHidden = true
        buttonPrevious.isHidden = true
        topConstraint.constant = -50
        bottomConstraint.constant = -50
        topSpacingConstraint.constant = 20
        bottomSpacingConstraint.constant = 60
    }
    
    func updateTitleMonth() { monthLabel.text = monthView.viewModel.yearMonthTitle }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isPaging == false {
            monthView.viewModel.startMonth()
        }
    }
    
    private weak var monthView: MonthViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        monthView = segue.destination as? MonthViewController
        monthView?.pagingEnabled = isPaging
    }
}

/// Action buttons not  needed for paging, but for button navigation
///
extension MainCalendarViewController {

    @IBAction func previousAction(_ sender: Any) {
        monthView.viewModel.previous()
        updateTitleMonth()
    }

    @IBAction func nextAction(_ sender: Any) {
        monthView.viewModel.next()
        updateTitleMonth()
    }
}
