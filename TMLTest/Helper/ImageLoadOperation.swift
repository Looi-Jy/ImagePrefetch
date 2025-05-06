//
//  ImageLoadOperation.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import UIKit

class ImageLoadOperation: Operation, ImageHelper, @unchecked Sendable {
    var image: UIImage?
    var loadingCompleteHandler: ((UIImage?) -> ())?
    private var imagePath: String
    
    init(_ path: String) {
        self.imagePath = path
    }
    
    override func main() {
        if isCancelled { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let imgView = UIImageView()
            self.loadImage(url: self.imagePath, imageView: imgView) { _ in
                self.image = imgView.image
                self.loadingCompleteHandler?(self.image)
            }
        }
    }
}
