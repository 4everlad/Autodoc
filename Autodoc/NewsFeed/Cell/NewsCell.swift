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
    @IBOutlet weak var imageView: AsyncImageView!
    @IBOutlet weak var noImageView: NoImageView!
    
    static let reuseIdentifier = "NewsCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(with news: NewsItem) {
        titleLabel.text = news.title
        imageView.isHidden = true
        noImageView.isHidden = false
        
        guard let url = news.titleImageUrl, let newUrl = URL(string: url) else {
            return
        }
        
        imageView.loadImage(newUrl) { [weak self] result in
            self?.setImageVisibility(isDownloaded: result)
        }
    }
    
    func setImageVisibility(isDownloaded: Bool) {
        noImageView.isHidden = isDownloaded ? true : false
        imageView.isHidden = isDownloaded ? false : true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.cancelLoading()
        imageView.image = nil
    }
}
