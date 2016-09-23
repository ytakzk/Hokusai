//
//  ThumbnailCell.swift
//  Hokusai
//
//  Created by Yuta Akizuki on 2015/07/12.
//  Copyright (c) 2015年 CocoaPods. All rights reserved.
//

import UIKit

class ThumbnailCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.layer.shadowColor   = UIColor.black.cgColor
        self.nameLabel.layer.shadowOpacity = 1.0
        self.nameLabel.layer.shadowRadius  = 4.0
        self.nameLabel.layer.shadowOffset  = CGSize(width: 0, height: 0)
    }

}
