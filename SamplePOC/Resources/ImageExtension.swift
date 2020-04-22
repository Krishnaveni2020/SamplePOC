//
//  ImageExtension.swift
//  SamplePOC
//
//  Created by Krishnaveni on 4/20/20.
//  Copyright © 2020 Krishnaveni. All rights reserved.
//

import Foundation
import Kingfisher

// MARK: - image loading
extension UIImageView {
    func setImage(with urlString: String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        kf.indicatorType = .activity
        if urlString.count == 0 {
            self.image = UIImage.init(named: "map.png")
        }
        
        self.kf.setImage(with: resource, placeholder: UIImage.init(named: "map.png"), options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("Image: \(value.image). Got from: \(value.cacheType)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
    }
}
