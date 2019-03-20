//
//  ComicCell.swift
//  Marvel
//
//  Created by Bruno Silva on 04/12/2018.
//

import UIKit

class ComicCell: UICollectionViewCell, ViewModelPresenterCell {
    
    var viewModel: ComicViewModel?  {
        didSet {
            guard let viewModel = self.viewModel else { return }
            
            self.coverImageView.loadImageUsingUrlString(urlString: viewModel.thumbnail.getImageUrl(size: .medium))
            self.titleLabel.text = viewModel.title
            self.issueNumberLabel.text = viewModel.issueNumber
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var issueNumberLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView! {
        didSet {
            self.coverImageView.contentMode = .scaleAspectFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
