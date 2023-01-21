//
//  NewsFeedCell.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 17.01.2023.
//

import UIKit
import Combine

class NewsCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var poster: AsyncImageView!
//    private var animator: UIViewPropertyAnimator?
    
    static let reuseIdentifier = "NewsCell"
    
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
        // Initialization code
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        poster.cancelLoading()
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
