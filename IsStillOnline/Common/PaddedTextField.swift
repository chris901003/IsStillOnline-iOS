// Created for IsStillOnline in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/1/14.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

open class PaddedTextField: UITextField {
    public var textInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsDisplay()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
    }

    convenience init() {
        self.init(frame: .zero)
        textAlignment = .center
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textAlignment = .center
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }

    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}
