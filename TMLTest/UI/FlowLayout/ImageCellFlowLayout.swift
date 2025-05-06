//
//  ImageCellFlowLayout.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import UIKit

class ImageCellFlowLayout: UICollectionViewFlowLayout {
    
    init(direction: UICollectionView.ScrollDirection = .vertical) {
        super.init()
        scrollDirection = direction
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { fatalError() }
        let spacing : CGFloat = 0
        sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        minimumLineSpacing = spacing
        minimumInteritemSpacing = spacing
        
        let width: CGFloat = collectionView.bounds.width/2
        itemSize = CGSize(width: width, height: width)
       
        super.prepare()
    }

}
