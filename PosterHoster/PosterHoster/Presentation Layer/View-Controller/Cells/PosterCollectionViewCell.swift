//
//  PosterCollectionViewCell.swift
//  PosterHoster
//
//  Created by Kartik Gupta on 26/05/22.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet private weak var imageView : LazyImageView!
    @IBOutlet private weak var title: UILabel!

    func updateCell(with cellModel: PosterCellModel) {
        self.imageView.downloadFromLink(name: cellModel.imageURL, contentMode: .scaleToFill)
        self.title.text = cellModel.title
    }
    
}
