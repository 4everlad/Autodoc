//
//  NewsFeedCell.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 17.01.2023.
//

import UIKit
import Combine

final class NewsCell: SelectableCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var poster: AsyncImageView!
    @IBOutlet weak var noImageView: NoImageView!
    
    
    static let reuseIdentifier = "NewsCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(with news: NewsItemJSON) {
        titleLabel.text = news.title
        poster.isHidden = true
        noImageView.isHidden = false
        if let url = news.titleImageUrl, let newUrl = URL(string: url) {
            poster.loadImage(newUrl) { [weak self] result in
                self?.poster.isHidden = result ? false : true
                self?.noImageView.isHidden = result ? true : false
            }
            
//            poster.loadImageASync(newUrl)
        }
    }
    
    func setImage() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        poster.cancelLoading()
    }
}
