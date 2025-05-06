//
//  ImageHelper.swift
//  TMLTest
//
//  Created by JY Looi on 6/3/22.
//

import UIKit
import Kingfisher

protocol ImageHelper {}

extension ImageHelper {
    @MainActor func loadImage(url: String, imageView: UIImageView, completion: ((Bool) -> ())?) {
        if let url = URL(string: url) {
            
            KF.url(url)
                .placeholder(UIImage())
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .onSuccess({ _ in
                    completion?(true)
                })
                .onFailure({ _ in
                    completion?(false)
                })
                .set(to: imageView)
        }
    }
    
    func getImagePathByWidth(model: ImageData, width: Int = 1080) -> String {
        
        if let path: String = model.downloadUrl?.components(separatedBy: "id/").first {
            let height: Int = 1080 * (model.height ?? 1) / (model.width ?? 1)
            return "\(path)id/\(model.id ?? "0")/\(width)/\(height)"
        }
        return ""
    }
    
}
