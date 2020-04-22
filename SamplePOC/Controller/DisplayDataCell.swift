//
//  DisplayDataCell.swift
//  SamplePOC
//
//  Created by Krishnaveni on 4/19/20.
//  Copyright © 2020 Krishnaveni. All rights reserved.
//

import UIKit
import SnapKit

class DisplayDataCell: UITableViewCell {
    
    // MARK: - List Model class
    var list:DataModel? {
        didSet {
            guard let dataItem = list else {return}
            if let name = dataItem.title {
                // profileImageView.image = UIImage(named: name)
                titleLabel.text = name
            }
            if let discriptionTitle = dataItem.description {
                if discriptionTitle.count == 0 {
                    descriptionLabel.text = "Empty value "
                } else {
                    descriptionLabel.text = " \(discriptionTitle) "
                }
                
            }
            
            if let profile = dataItem.imageHref {
                 profileImageView.setImage(with: profile)
            }
        }
    }
    
    // MARK: - Create IBOutlets
    
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
        label.textColor =  .black
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - initilize IBOutlets
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
        }
        
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(profileImageView.snp_rightMargin).offset(20)
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
        self.profileImageView.image = nil
        self.titleLabel.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
}
