//
//  CharacterCell.swift
//  Marvel
//
//  Created by Bruno Silva on 02/12/2018.
//

import UIKit

protocol FavouriteCharacterDelegate {
    func favouriteCharacterButtonPressed()
}

class CharacterCell: UITableViewCell, ViewModelPresenterCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView! {
        didSet {
            self.characterImageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var favouriteButton: UIButton! {
        didSet {
            self.favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        }
    }
    
    var delegate: FavouriteCharacterDelegate?
    var viewModel: CharacterViewModel? {
        didSet {
            guard let viewModel = self.viewModel else { return }
            
            self.titleLabel.text = viewModel.name
            self.characterImageView.loadImageUsingUrlString(urlString: viewModel.thumbnail.getImageUrl(size: .small))
            self.selectFavouriteCharacter()
        }
    }
    
    func selectFavouriteCharacter() {
        guard let id = viewModel?.id,
              let favouriteId = UserDefaultsDataSource().readData(for: UserDefaultsKeys.favouriteCharacter),
              let favourite = favouriteId as? Int else { return }
        
        if favourite == id {
            self.favouriteButton.setImage(UIImage(named: "star_full"), for: .normal)
        } else {
            self.favouriteButton.setImage(UIImage(named: "star_empty"), for: .normal)
        }
    }
}

//MARK: - IBAction
extension CharacterCell {
    @objc func favouriteButtonPressed() {
        guard var id = viewModel?.id else { return }
        
        if let favouriteId = UserDefaultsDataSource().readData(for: UserDefaultsKeys.favouriteCharacter),
           let favourite = favouriteId as? Int,
               favourite == id {
            id = 0
        }
        
        UserDefaultsDataSource().writeData(id, for: UserDefaultsKeys.favouriteCharacter)
        self.selectFavouriteCharacter()
        self.delegate?.favouriteCharacterButtonPressed()
    }
}
