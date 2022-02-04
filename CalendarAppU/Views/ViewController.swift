//
//  ViewController.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/26/22.
//

import UIKit

class ViewController: UIViewController {
    
    private weak var calendarNonPaging: MainCalendarViewController?
    private weak var calendarPaging: MainPagingViewController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let view = segue.destination as? MainCalendarViewController {
            calendarNonPaging = view
        } else if let view = segue.destination as? MainPagingViewController {
            calendarPaging = view
        }
    }
}
