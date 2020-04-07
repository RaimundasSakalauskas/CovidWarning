//
//  BlurView.swift
//  CovidWarning
//
//  Created by Raimundas Sakalauskas on 2020-04-08.
//  Copyright © 2020 Raimundas Sakalauskas. All rights reserved.
//

import UIKit

//https://stackoverflow.com/a/35735392/2249485
@IBDesignable class BlurView : UIView {

    var toolbar: UIToolbar!
    var heightConstraint: NSLayoutConstraint!

    //using toolbar will let us match navbar color
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        clipsToBounds = true
        addToolbar()
    }

    func addToolbar() {
        toolbar = UIToolbar(frame: self.bounds)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.clipsToBounds = true
        insertSubview(toolbar, at: 0)

        //Can't pin to topAnchor, because toolbar has higher priority than default UI label.
        heightConstraint = toolbar.heightAnchor.constraint(equalToConstant: self.bounds.height)

        addConstraints([
            toolbar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            toolbar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            toolbar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            heightConstraint
        ])
    }

    override var bounds: CGRect {
        get {
            super.bounds
        }
        set {
            super.bounds = newValue
            if let heightConstraint = heightConstraint {
                heightConstraint.constant = newValue.height

                NSLog("bounds newValue.height = \(newValue.height)")
            }
        }
    }
}
