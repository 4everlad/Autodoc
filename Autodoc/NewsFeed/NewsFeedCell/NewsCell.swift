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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
//        poster.image = nil
//        poster.alpha = 0.0
//        animator?.stopAnimation(true)
        poster.cancelLoading()
    }

}
