//
//  MainCalendarViewController.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/26/22.
//

import UIKit

class MainCalendarViewController: UIViewController {

    var viewModel: MonthViewing {
        monthView.viewModel
    }

    @IBOutlet var buttonPrevious: UIButton!
    @IBOutlet var buttonNext: UIButton!
    
    var installedViewModel: MonthViewing? {
        didSet {
            monthView.installedViewModel = installedViewModel
            monthView.viewModel.startMonth()
            update()
        }
    }
    
    private var isPaging = true

    @IBOutlet var bottomSpacingConstraint: NSLayoutConstraint!
    @IBOutlet var topSpacingConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isPaging {
            buttonNext.isHidden = true
            buttonPrevious.isHidden = true
            // more opaque
            view.backgroundColor = .white.withAlphaComponent(0.92)
            topConstraint.constant = -50
            bottomConstraint.constant = -50
            topSpacingConstraint.constant = 20
            bottomSpacingConstraint.constant = 60
        } else {
            update()
        }
    }
    
    @IBOutlet var monthLabel: UILabel!
    
    func update() {
        monthLabel.text = monthView.viewModel.yearMonthTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isPaging {
            // nothing to do
        } else {
            monthView.viewModel.startMonth()
        }
    }
    
    private weak var monthView: MonthViewController!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        monthView = segue.destination as? MonthViewController
    }
}

extension MainCalendarViewController {

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
}
