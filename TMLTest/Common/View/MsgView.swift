//
//  MsgView.swift
//  CombineTest
//
//  Created by jieyong looi on 23/07/2021.
//

import UIKit

class MsgView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var msg: UILabel!
    
    private var msgStr: String = ""
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.commonInit()
//    }
    
    init(frame: CGRect, msg: String) {
        super.init(frame: frame)
        self.msgStr = msg
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
        guard let customView = UINib(resource: R.nib.msgView).instantiate(withOwner: self, options: nil).first as? UIView else { return }
        //UINib(resource: "LoadingView").instantiate(withOwner: self, options: nil).first as? UIView else { return }
        customView.frame = bounds
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(customView)
        self.view = customView
        
        self.bgView.layer.cornerRadius = 20
        self.bgView.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        self.msg.text = self.msgStr
    }
    
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//
//        do {
//            let gif = try UIImage(gifName: "loading.gif")
//            self.imageView.setGifImage(gif)
//        } catch {
//
//        }
//
//    }
    
}
