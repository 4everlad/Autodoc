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
    var spinnerView: InfiniteScrollActivityView!
    
    private let spacing: CGFloat = 20
    
    private var viewModel: NewsFeedViewModel = .init()
    private var feedSubscriber: AnyCancellable!
    private var spinnerSubscriber: AnyCancellable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureHierarchy()
        configureDataSource()
        setupSpinnerView()
        setSubscribers()
        setupViews()
        
        viewModel.getNews()
    }
    
}

private extension NewsFeedViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let device = UIDevice.current.userInterfaceIdiom
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: CGFloat(spacing), leading: spacing, bottom: spacing, trailing: spacing)
        
          let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth((device == .pad) ? 1/3 : 2/3))
          let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: (device == .pad) ? 2: 1)

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
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, NewsItemJSON>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: NewsItemJSON) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else { fatalError("Cannot create the cell") }
            
            cell.set(with: identifier)
                             
            return cell
        }
        
        updateUI()
    }
    
    private func setSubscribers() {
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
    
    func setupSpinnerView() {
        // Set up Infinite Scroll loading indicator
        let frame = CGRect(x: 0,
                           y: collectionView.contentSize.height,
                           width: collectionView.bounds.size.width,
                           height: InfiniteScrollActivityView.defaultHeight)
        spinnerView = InfiniteScrollActivityView(frame: frame)
        spinnerView.isHidden = true
        collectionView.addSubview(spinnerView)
        
        var insets = collectionView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        collectionView.contentInset = insets
    }
}

extension NewsFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = viewModel.newsFeed[indexPath.row]
        let isItemLast = viewModel.newsFeed.isLast(item)
        
        if isItemLast && viewModel.canLoad {
            
            let frame = CGRect(x: 0,
                               y: collectionView.contentSize.height,
                               width: collectionView.bounds.size.width,
                               height: InfiniteScrollActivityView.defaultHeight)
            
            spinnerView.frame = frame
            spinnerView.startAnimating()
            
            // TODO: - check if not weak
            viewModel.getNews { [weak self] in
                self?.spinnerView.stopAnimating()
            }
        }
    }
}

