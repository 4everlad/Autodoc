//
//  ViewController.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 21.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let noImageView: UIView = {
        let noImageView = UIView()
        noImageView.translatesAutoresizingMaskIntoConstraints = false
        noImageView.backgroundColor = UIColor.systemYellow
        return noImageView
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:
        [titleLabel, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var newsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews:
        [newsTypeLabel, descriptionLabel, siteNewsButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .white
        label.text = "Title"
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white
        label.text = "Date"
        label.numberOfLines = 1
        return label
    }()
    
    private let newsTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        label.text = "News Type"
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.text = "Description"
        label.numberOfLines = 0
        return label
    }()
    
    private let siteNewsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Посмотреть на сайте", for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    private var viewModel: NewsViewModel
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

}

private extension ViewController {
    
    func setupViews() {
        view.addSubview(noImageView)
        noImageView.addSubview(imageStackView)
        view.addSubview(newsStackView)
        
        setupNoImageView()
        setupImageStackView()
        setupNewsStackView()
        
        self.navigationItem.title = "Новость"
        self.navigationController?.navigationBar.tintColor = UIColor.systemRed
        self.view.backgroundColor = .white
    }
    
    func setupNoImageView() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            noImageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            noImageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            noImageView.topAnchor.constraint(equalTo: guide.topAnchor),
            noImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
        ])
    }
    
    func setupImageStackView() {
        
        NSLayoutConstraint.activate([
            imageStackView.leadingAnchor.constraint(equalTo: noImageView.leadingAnchor, constant: 16),
            imageStackView.trailingAnchor.constraint(equalTo: noImageView.trailingAnchor, constant: -16),
            imageStackView.bottomAnchor.constraint(equalTo: noImageView.bottomAnchor, constant: -16),
            imageStackView.topAnchor.constraint(greaterThanOrEqualTo: noImageView.topAnchor, constant: 16)
        ])
    }
    
    func setupNewsStackView() {
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            newsStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            newsStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            newsStackView.topAnchor.constraint(equalTo: noImageView.bottomAnchor, constant: 26),
            newsStackView.bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor, constant: -16)
        ])
        
    }
    
}
