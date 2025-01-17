//
//  UILabel+Ex.swift
//  Todos
//
//  Created by J Oh on 7/6/24.
//

import UIKit

class PaddedLabel: UILabel {
    private var padding = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        clipsToBounds = true 
    }
}
