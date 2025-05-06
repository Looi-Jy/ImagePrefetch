//
//  LoadingView.swift
//  CombineTest
//
//  Created by jieyong looi on 22/07/2021.
//

import UIKit

class LoadingView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        self.commonInit()
    }
    
    func commonInit() {
        guard let customView = UINib(resource: R.nib.loadingView).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        //UINib(resource: "LoadingView").instantiate(withOwner: self, options: nil).first as? UIView else { return }
        customView.frame = bounds
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(customView)
        self.view = customView
    }
    
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//
//        do {
////            self.imageView.image = R.image.app_logo()
//            //TODO: reset to GIF when ready
//            let gif = try UIImage(gifName: "loading_gif.gif")
//            self.imageView.setGifImage(gif)
//        } catch {
//
//        }
//
//    }
    
}
