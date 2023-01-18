//
//  ViewController.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 17.01.2023.
//

import UIKit
import Combine

class NewsFeedViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, NewsItemJSON>!
    var collectionView: UICollectionView!
    
    private let spacing: CGFloat = 20
    
    private var viewModel: NewsFeedViewModel = .init()
    private var feedSubscriber: AnyCancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureHierarchy()
        configureDataSource()
        setSubscriber()
        setupViews()
        
        viewModel.getNews()
    }
    
}

private extension NewsFeedViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: CGFloat(spacing), leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let nib = UINib(nibName: NewsCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: NewsCell.reuseIdentifier)
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, NewsItemJSON>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: NewsItemJSON) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else { fatalError("Cannot create the cell") }
            
            cell.titleLabel.text = "\(identifier.title)"
            
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsItemJSON>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.newsFeed)
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    private func setSubscriber() {
        feedSubscriber = viewModel.$newsFeed
           .receive(on: DispatchQueue.main)
           .sink { [weak self] _ in
              self?.updateUI()
           }
    }
    
    private func updateUI() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsItemJSON>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.newsFeed)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

private extension NewsFeedViewController {
    func setupViews() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

