//
//  DisplayDataCell.swift
//  SamplePOC
//
//  Created by Krishnaveni on 4/19/20.
//  Copyright © 2020 Krishnaveni. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class DisplayDataCell: UITableViewCell {

     var contact:DataModel? {
           didSet {
               guard let dataItem = contact else {return}
               if let name = dataItem.title {
                  // profileImageView.image = UIImage(named: name)
                   titleLabel.text = name
               }
            if let discriptionTitle = dataItem.description {
                if discriptionTitle == "" {
                    descriptionLabel.text = " "
                } else {
                    descriptionLabel.text = " \(discriptionTitle) "
                }
                     
               }
               
            if let profile = dataItem.imageHref {
               profileImageView.setImage(with: profile)
               }
           }
       }
       
       let containerView:UIView = {
           let view = UIView()
           view.translatesAutoresizingMaskIntoConstraints = false
           view.clipsToBounds = true // this will make sure its children do not go out of the boundary
           return view
       }()
       
       let profileImageView:UIImageView = {
           let img = UIImageView()
           img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
           img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
           img.layer.cornerRadius = 35
           img.clipsToBounds = true
           return img
       }()
       
       let titleLabel:UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 20)
           label.textColor = .black
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       let descriptionLabel:UILabel = {
           let label = UILabel()
           label.font = UIFont.boldSystemFont(ofSize: 14)
           label.textColor =  .white
           label.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
           label.layer.cornerRadius = 5
           label.clipsToBounds = true
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(profileImageView)
    
        profileImageView.snp.makeConstraints { (make) in
           make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(10)
            make.width.equalTo(70)
            make.height.equalTo(70)
       // make.bottom.equalTo(contentView).offset(-10)
   
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
        make.left.equalTo(profileImageView.snp_rightMargin).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
            make.right.equalTo(contentView).offset(-10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
    make.bottom.equalTo(descriptionLabel.snp_topMargin).offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(10)
            make.left.equalTo(containerView)
            make.right.equalTo(containerView)
            make.bottom.equalTo(containerView)
        }
        descriptionLabel.numberOfLines = 0
                
    }
        override func prepareForReuse() {
           super.prepareForReuse()
           self.descriptionLabel.text = nil
       }
    
       required init?(coder aDecoder: NSCoder) {
           
           super.init(coder: aDecoder)
       }

}

extension UIImageView {
    func setImage(with urlString: String){
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        var kf = self.kf
        kf.indicatorType = .activity
        self.kf.setImage(with: resource)
    }
}
