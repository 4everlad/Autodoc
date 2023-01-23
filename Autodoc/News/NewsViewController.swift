//
//  NewsViewController.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 21.01.2023.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var siteNewsButton: UIButton!
    
    var viewModel: NewsViewModel
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNews()
    }
    
    func setNews() {
        
        Task {
            self.imageView.image = await viewModel.getNewsImage()
        }
        
        self.dateLabel.text = viewModel.news.publishedDateStr
        self.titleLabel.text = viewModel.news.title
        self.newsTypeLabel.text = viewModel.news.categoryType
        self.descriptionLabel.text = viewModel.news.description
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
