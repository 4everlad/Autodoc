//
//  ViewController.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 17.01.2023.
//

import UIKit
import Combine

final class NewsFeedViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, NewsItem>!
    private var collectionView: UICollectionView!
    private var rowSpinnerView: InfiniteScrollActivityView!
    
    lazy private var spinnerView: UIActivityIndicatorView = {
        let spinnerView = UIActivityIndicatorView()
        spinnerView.color = .systemRed
        return spinnerView
    }()
    
    private let spacing: CGFloat = 20
    private let size: CGFloat = 45
    
    private(set)var viewModel: NewsFeedViewModel?
    private var feedSubscriber: AnyCancellable?
    
    init(viewModel: NewsFeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configureHierarchy()
        configureDataSource()
        setupViews()
        setupSpinnerViews()
        setSubscribers()
        
        Task {
            let _ = await viewModel?.getNewsAsync()
            DispatchQueue.main.async {
                self.spinnerView.stopAnimating()
            }
        }

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
        dataSource = UICollectionViewDiffableDataSource<Section, NewsItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: NewsItem) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseIdentifier, for: indexPath) as? NewsCell else { fatalError("Cannot create the cell") }
            
            cell.set(with: identifier)
                             
            return cell
        }
        
        updateUI()
    }
    
    private func setSubscribers() {
        feedSubscriber = viewModel?.$newsFeed
           .receive(on: DispatchQueue.main)
           .sink { [weak self] _ in
               self?.updateUI()
           }
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, NewsItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.newsFeed)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

private extension NewsFeedViewController {
    func setupViews() {
        self.navigationItem.title = "Новостная лента"
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupSpinnerViews() {
        let frame = CGRect(x: 0,
                           y: collectionView.contentSize.height,
                           width: collectionView.bounds.size.width,
                           height: InfiniteScrollActivityView.defaultHeight)
        rowSpinnerView = InfiniteScrollActivityView(frame: frame)
        rowSpinnerView.isHidden = true
        collectionView.addSubview(rowSpinnerView)
        
        var insets = collectionView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        collectionView.contentInset = insets
        
        view.addSubview(spinnerView)
        spinnerView.startAnimating()
        spinnerView.hidesWhenStopped = true
        
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
            
            spinnerView.widthAnchor.constraint(equalToConstant: size),
            spinnerView.heightAnchor.constraint(equalToConstant: size)
        ])
    }
}

extension NewsFeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        let item = viewModel.newsFeed[indexPath.row]
        let isItemLast = viewModel.newsFeed.isLast(item)
        
        if isItemLast && viewModel.canLoad {
            
            let frame = CGRect(x: 0,
                               y: collectionView.contentSize.height,
                               width: collectionView.bounds.size.width,
                               height: InfiniteScrollActivityView.defaultHeight)
            
            rowSpinnerView.frame = frame
            rowSpinnerView.startAnimating()
            
            Task {
                let _ = await viewModel.getNewsAsync()
                self.rowSpinnerView.stopAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? NewsCell else { return }
        
        let item = viewModel.newsFeed[indexPath.row]
        
        cell.animateOnSelect(completion: {
            viewModel.showNews(with: item)
        })
    }
}

