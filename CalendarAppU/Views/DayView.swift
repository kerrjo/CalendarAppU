//
//  DayView.swift
//  CalendarAppU
//
//  Created by JOSEPH KERR on 1/27/22.
//

import UIKit

protocol DaySelection: AnyObject {
    func onDaySelected(_ day: Int, text: String)
}

class DayView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    weak var daySelectionHandler: DaySelection?
    
    var day: Int = 0
    var holidayText: String = "" {
        didSet {
            holidayLabel.text = holidayText
        }
    }

    init(day: Int) {
        super.init(frame: .zero)
        backgroundColor = day == 0 ? .gray.withAlphaComponent(0.5) : .lightGray.withAlphaComponent(0.5)
        self.day = day
        
        //if day > 0 && day % 4 == 0 { holidayText = "hello world" }
        
        dayLabel = UILabel()
        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        dayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true

        holidayLabel = UILabel()
        addSubview(holidayLabel)
        holidayLabel.translatesAutoresizingMaskIntoConstraints = false
        holidayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        holidayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 2).isActive = true
        holidayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2).isActive = true
        holidayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        holidayLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 0).isActive = true

        holidayLabel.numberOfLines = 3
        holidayLabel.adjustsFontSizeToFitWidth = true
        holidayLabel.minimumScaleFactor = 0.5

        let dayText = day > 0 ? "\(day)" : ""
        dayLabel.text = dayText
        holidayLabel.text = holidayText

        if day > 0 {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(daySelected))
            addGestureRecognizer(gesture)
        }
    }
    
    var dayLabel: UILabel!
    var holidayLabel: UILabel!
    
    @objc func daySelected() {
        daySelectionHandler?.onDaySelected(day, text: holidayText)
    }
}


class DayViewPopup: UIView {
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
        backgroundColor = day == 0 ? .gray.withAlphaComponent(0.5) : .orange.withAlphaComponent(0.5)
        self.day = day
        
        dayLabel = UILabel()
        addSubview(dayLabel)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        dayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4).isActive = true
        holidayLabel = UILabel()
        addSubview(holidayLabel)
        holidayLabel.translatesAutoresizingMaskIntoConstraints = false
        holidayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        holidayLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2).isActive = true
        holidayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4).isActive = true
        holidayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        holidayLabel.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 4).isActive = true

        holidayLabel.numberOfLines = 2
        holidayLabel.adjustsFontSizeToFitWidth = true
        holidayLabel.minimumScaleFactor = 0.5

        let dayText = day > 0 ? "\(day)" : ""
        dayLabel.text = dayText
        holidayLabel.text = nil
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(daySelected))
        addGestureRecognizer(gesture)
    }
    
    var dayLabel: UILabel!
    var holidayLabel: UILabel!
    
    @objc func daySelected() {
        removeFromSuperview()
    }
}
    
