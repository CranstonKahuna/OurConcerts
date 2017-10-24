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
    
    var rating: Int16  = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
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
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highLightedStar = UIImage(named: "highLightedStar", in: bundle, compatibleWith: self.traitCollection)
        // Create the buttons
        for btn in 0..<6 {
            let button = UIButton(type: .custom)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.accessibilityLabel = "Set \(btn) star rating"
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        // First button is half-wide
        let halfWide = NSLayoutConstraint(item: ratingButtons[0], attribute: .width, relatedBy: .equal, toItem: ratingButtons[0], attribute: .height, multiplier: 0.5, constant: 0.0)
        ratingButtons[0].addConstraint(halfWide)
        addArrangedSubview(ratingButtons[0])

        for btn in 1..<6 {
            let button = ratingButtons[btn]
            button.setImage(emptyStar, for: .selected)
            button.setImage(filledStar, for: .normal)
            button.setImage(highLightedStar, for: .highlighted)
            button.setImage(highLightedStar, for: [.highlighted, .selected])
            button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
            button.contentMode = .center
            let squareConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 1.4, constant: 0.0)
            button.addConstraint(squareConstraint)
            // Add the new button to the stack
            addArrangedSubview(button)
        }
        updateButtonSelectionStates()
    }
    
    // Mark: Button Action
    
    @objc func ratingButtonTapped(button: UIButton) {
        if !editable {
           return
        }
        guard let index = ratingButtons.index(of:button) else {
            fatalError("The button, \(button) is not in the ratinButtons array: \(ratingButtons)")
        }
        // Calculate the rating of the selected button
        rating = Int16(index)
    }

    private func updateButtonSelectionStates() {
        // If the index of a button is less than the rating, that button should be selected
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating + 1
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            // Assign the value string
            button.accessibilityValue = valueString
        }
    }
}
