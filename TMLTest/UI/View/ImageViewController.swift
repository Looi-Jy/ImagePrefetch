//
//  ImageViewController.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import UIKit

class ImageViewController: BaseViewController, ImageHelper {
    
    @IBOutlet weak var segCtrl: UISegmentedControl!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var width: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var url: UILabel!
    @IBOutlet weak var downloadUrl: UILabel!
    
    private var model: ImageData?
    private var blurImages: [UIImageView] = []
    
    convenience init(model: ImageData) {
        self.init()
        self.model = model
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "IMAGE PAGE"
        
        if let model = self.model {
            let path: String = self.getImagePathByWidth(model: model)
            self.showImage(url: path)
            self.imgHeight.constant = CGFloat(Int(self.imageView.frame.width) * (model.height ?? 1) / (model.width ?? 1))
            self.id.text = model.id ?? ""
            self.author.text = model.author ?? ""
            self.width.text = "\(model.width ?? 0)"
            self.height.text = "\(model.height ?? 0)"
            self.url.text = model.url ?? ""
            self.downloadUrl.text = model.downloadUrl ?? ""
        }
        
    }
    
    private func showBlurImage() {
        let num: Int = Int(self.slider.value)
        if self.blurImages.count >= num {
//            print(num)
            self.imageView.image = self.blurImages[num-1].image
        }
    }
    
    private func showImage(url: String) {
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        self.loadImage(url: url, imageView: self.imageView, completion: { [weak self] _ in
            guard let `self` = self else { return }
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        })
    }

    @IBAction func segCtrlTap(_ sender: Any) {
        
        guard let model = self.model else { return }
        
        let path: String = self.getImagePathByWidth(model: model)
        switch self.segCtrl.selectedSegmentIndex {
        case 0:
            self.showImage(url: path)
            self.slider.isHidden = true
        case 1:
            if self.blurImages.isEmpty {
                self.showImage(url: "\(path)?blur=5")
                self.downloadBlurImages()
                self.slider.value = 5
            }else {
                self.showBlurImage()
            }
            self.slider.isHidden = false
        case 2:
            self.showImage(url: "\(path)?grayscale")
            self.slider.isHidden = true
        default:
            break
        }
    }

    @IBAction func sliderChanged(_ sender: Any) {
        self.showBlurImage()
    }
}

// MARK: - download blur images
extension ImageViewController {
    private func downloadBlurImages() {
        guard let model = self.model else { return }
        let path: String = self.getImagePathByWidth(model: model)
        if path.isEmpty { return }
        for i in 1...10 {
            let imgView: UIImageView = UIImageView()
            let blurUrl: String = "\(path)?blur=\(i)"
            self.loadImage(url: blurUrl, imageView: imgView, completion: nil)
            self.blurImages.append(imgView)
        }
    }
}
