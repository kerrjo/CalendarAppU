//
//  DayView.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/27/22.
//

import UIKit


class DayView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    var day: Int = 0
    var holidayText: String = "" {
        didSet {
            holidayLabel.text = holidayText
        }
    }

    init(day: Int) {
        super.init(frame: .zero)
        if day == 0 {
            backgroundColor = .gray.withAlphaComponent(0.5)
        } else {
            backgroundColor = .lightGray.withAlphaComponent(0.5)
        }
        self.day = day
        
        dayLabel = UILabel()
        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1).isActive = true

        holidayLabel = UILabel()
        addSubview(holidayLabel)
        holidayLabel.translatesAutoresizingMaskIntoConstraints = false
        holidayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        holidayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1).isActive = true
        holidayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1).isActive = true
        holidayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        holidayLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 0).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: holidayLabel.topAnchor, constant: 0).isActive = true

        holidayLabel.numberOfLines = 3
        holidayLabel.adjustsFontSizeToFitWidth = true
        holidayLabel.minimumScaleFactor = 0.5

        let dayText = day > 0 ? "\(day)" : ""
        dayLabel.text = dayText
        holidayLabel.text = nil
    }
    
    var dayLabel: UILabel!
    var holidayLabel: UILabel!
}
    
