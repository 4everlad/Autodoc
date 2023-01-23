//
//  NoImageView.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 21.01.2023.
//

import UIKit

class NoImageView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageIcon = UIImage(systemName: "photo.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        imageView.image = imageIcon
        return imageView
    }()
    
    private let size: CGFloat = 45
    private let spacing: CGFloat = 16
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupViews()
    }

    override init(frame: CGRect) {
         super.init(frame: frame)
         setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
         setupViews()
    }
}

private extension NoImageView {
    func setupViews() {
        self.addSubview(imageView)
        self.backgroundColor = .systemRed.withAlphaComponent(0.2)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: size * 1.3),
            imageView.heightAnchor.constraint(equalToConstant: size),
        ])
    }
}
