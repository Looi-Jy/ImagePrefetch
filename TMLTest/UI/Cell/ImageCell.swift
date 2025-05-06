//
//  ImageCell.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import UIKit
import Kingfisher

class ImageCell: UICollectionViewCell, ImageHelper {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = UIImage()
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
    
    func updateAppearanceFor(_ image: UIImage?) {
        self.displayImage(image)
    }
    
    private func displayImage(_ image: UIImage?) {
        if let image = image {
            self.imageView.image = image
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        } else {
            self.loadingIndicator.startAnimating()
            self.imageView.image = .none
        }
    }
}
