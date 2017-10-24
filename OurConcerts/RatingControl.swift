//
//  RatingControl.swift
//  OurConcerts
//
//  Created by Dean Thomas on 10/23/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    
    // MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0
    
    @IBInspectable var editable: Bool = true

    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Private Methods
    
    private func setupButtons() {
        print("setupButtons")
        // Create the buttons
        for _ in 0..<6 {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
    //        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
    //        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        // First button is half-wide
        let halfWide = NSLayoutConstraint(item: ratingButtons[0], attribute: .width, relatedBy: .equal, toItem: ratingButtons[0], attribute: .height, multiplier: 0.5, constant: 0.0)
        ratingButtons[0].addConstraint(halfWide)
        ratingButtons[0].backgroundColor = UIColor.white
        addArrangedSubview(ratingButtons[0])

        for btn in 1..<6 {
            let button = ratingButtons[btn]
            button.backgroundColor = UIColor.red
            let squareConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 1.0, constant: 0.0)
           button.addConstraint(squareConstraint)
            // Add the new button to the stack
            addArrangedSubview(button)

        }
    }
    
    // Mark: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        print("ratingButtonTapped Button Pressed")
        if !editable {
            print("ratingButtonTapped not editable")
           return
        }
    }

}
