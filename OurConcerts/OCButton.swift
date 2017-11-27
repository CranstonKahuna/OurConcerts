//
//  OCButton.swift
//  OurConcerts
//
//  Created by Dean Thomas on 11/26/17.
//  Copyright © 2017 Dean Thomas. All rights reserved.
//

import UIKit

@IBDesignable
class OCButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet { setupView() }
    }
    
    @IBInspectable var titleInset: CGFloat = 0.0 {
        didSet { setupView() }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet { setupView() }
    }
    
    @IBInspectable var borderColor: UIColor? = .white {
        didSet { setupView() }
    }

    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        titleEdgeInsets = UIEdgeInsets(top: titleInset, left: titleInset, bottom: titleInset, right: titleInset)
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
    }
}

