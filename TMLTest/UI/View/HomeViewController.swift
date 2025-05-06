//
//  HomeViewController.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var viewModel: ImageListViewModel = {
        return ImageListViewModel()
    }()
    
    private lazy var dataSource = makeDataSource()
    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath : ImageLoadOperation]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "HOME"
        self.setupCollectionView()
        self.bindViewModel()
        self.viewModel.apply(.getImageList)
        
    }
    
    private func bindViewModel() {
        
        self.viewModel.bindHeaderRefreshCtrl(self.collectionView.headRefreshControl)
        self.viewModel.bindFooterRefreshCtrl(self.collectionView.footRefreshControl)
        
        self.viewModel.$imageList
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] list in
                guard let `self` = self else { return }
                self.updateList(list: list)
            })
            .store(in: &self.cancellables)
    }

}

// MARK: - collectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
    
    private func setupCollectionView() {
        self.collectionView.collectionViewLayout = self.createCompositionLayout()//ImageCellFlowLayout()
        self.collectionView.register(ImageCell.getNib(), forCellWithReuseIdentifier: ImageCell.identifier)
        self.dataSource = self.makeDataSource()
        self.collectionView.dataSource = self.dataSource
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = self
        
        self.collectionView.bindHeadRefreshHandler({ [weak self] in
            guard let `self` = self else { return }
            if !self.collectionView.headRefreshControl.isTriggeredRefreshByUser {
                self.viewModel.apply(.getImageList)
            }
            
        }, themeColor: .lightGray, refreshStyle: .replicatorCircle)
        
        self.collectionView.bindFootRefreshHandler({ [weak self] in
            guard let `self` = self else { return }
            
            if !self.collectionView.footRefreshControl.isTriggeredRefreshByUser {
                self.viewModel.apply(.getMoreData)
            }
            
        }, themeColor: .lightGray, refreshStyle: .replicatorCircle)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = self.loadingOperations[indexPath] { return }
            if let imgLoader = self.loadImage(at: indexPath.row) {
                self.loadingQueue.addOperation(imgLoader)
                self.loadingOperations[indexPath] = imgLoader
            }

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let dataLoader = self.loadingOperations[indexPath] {
                dataLoader.cancel()
                self.loadingOperations.removeValue(forKey: indexPath)
            }
        }
    }
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Int, ImageData> {
        return UICollectionViewDiffableDataSource<Int, ImageData>(collectionView: self.collectionView) { collectionView, indexPath, imageData in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell {
                
                //load more data for smooth scrolling
                let count: Int = self.viewModel.imageList.count
                let row: Int = indexPath.row
                if row >= count - 8 && !self.viewModel.loading {
                    self.viewModel.apply(.getMoreData)
                }
                
                // How should the operation update the cell once the data has been loaded?
                let updateCellClosure: (UIImage?) -> () = { [weak self] image in
                    guard let `self` = self else { return }
                    cell.updateAppearanceFor(image)
                    self.loadingOperations.removeValue(forKey: indexPath)
                }
                
                // Try to find an existing data loader
                if let dataLoader = self.loadingOperations[indexPath] {
                    // Has the data already been loaded?
                    if let image = dataLoader.image {
                        cell.updateAppearanceFor(image)
                        self.loadingOperations.removeValue(forKey: indexPath)
                    } else {
                        // No data loaded yet, so add the completion closure to update the cell once the data arrives
                        dataLoader.loadingCompleteHandler = updateCellClosure
                    }
                } else {
                    // Need to create a data loaded for this index path
                    if let dataLoader = self.loadImage(at: indexPath.row) {
                        // Provide the completion closure, and kick off the loading operation
                        dataLoader.loadingCompleteHandler = updateCellClosure
                        self.loadingQueue.addOperation(dataLoader)
                        self.loadingOperations[indexPath] = dataLoader
                    }
                }

                return cell
            }
            
            return ImageCell()
        }
    }
    
    private func updateList(list: [ImageData], animate: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ImageData>()
        snapshot.appendSections([1])
        snapshot.appendItems(list, toSection: 1)
        self.dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model: ImageData = self.viewModel.imageList[indexPath.row]
        self.navigationController?.pushViewController(ImageViewController(model: model), animated: true)
    }
    
    private func loadImage(at idx: Int) -> ImageLoadOperation? {
        if (0..<self.viewModel.imageList.count).contains(idx) {
            let model: ImageData = self.viewModel.imageList[idx]
            if let path: String = model.downloadUrl?.components(separatedBy: "id/").first {
                let url:String = "\(path)id/\(model.id ?? "0")/100"
                return ImageLoadOperation(url)
            }
        }
        return .none
    }
    
}

// MARK: - collectionView composition layout
extension HomeViewController {
    private func createCompositionLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { [unowned self] sectionNum, env -> NSCollectionLayoutSection? in
            switch sectionNum {
            case 0: return self.commonLayout()
            default: return self.commonLayout()
            }
        }
    }
    
    private func commonLayout() -> NSCollectionLayoutSection {
        
        let count: Int = 3
        let height: CGFloat = self.collectionView.frame.width/CGFloat(count)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
     item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(height))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: count)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
//      section.contentInsets.leading = 15

//        section.boundarySupplementaryItems = [
//     NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension:
//     .fractionalWidth(1), heightDimension: .estimated(44)), elementKind: "0", alignment:
//     .topLeading)
//     ]

      return section
    }
}
