//
//  NewsFeedCell.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 17.01.2023.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static let reuseIdentifier = "NewsCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
