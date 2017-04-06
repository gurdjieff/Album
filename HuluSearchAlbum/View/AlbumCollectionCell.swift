//
//  AlbumCollectionCell.swift
//  HuluSearchAlbum
//
//  Created by Daiyu Zhang on 4/2/17.
//  Copyright © 2017 Daiyu Zhang. All rights reserved.
//

import UIKit

class AlbumCollectionCell: UICollectionViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var album: AlbumModel? {
        didSet {
            guard let album = album else { return }
            if let dict = album.images?[0] {
                if let url = URL(string: dict["url"] as! String) {
                    coverImageView.kf.setImage(with: url)
                }
            }
            nameLabel.text = album.name
        }
    }
}
