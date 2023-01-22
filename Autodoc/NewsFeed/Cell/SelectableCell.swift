//
//  SelectableCell.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 21.01.2023.
//

import UIKit

class SelectableCell: UICollectionViewCell {
    
    override var isHighlighted: Bool {
        didSet {
            animateOnHighlight(isHiglighted: isHighlighted)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            animateOnSelect(isSeleted: isSelected)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func animateOnHighlight(isHiglighted: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.90, y: 0.90) : .identity
        })
    }
    
    func animateOnSelect(isSeleted: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: {
            self.alpha = self.isSelected ? 0.5 : 1
        })
    }
    
}
