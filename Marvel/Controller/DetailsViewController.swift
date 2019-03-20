//
//  DetailsViewController.swift
//  Marvel
//
//  Created by Bruno Silva on 02/12/2018.
//

import UIKit

class DetailsViewController: StaticTableController {
    
    var delegate: FavouriteCharacterDelegate?
    var characterViewModel: CharacterViewModel!
    private var linkRequest = Request.Link()
    private let cellCharacter = CharacterCell.fromNib()
    private let cellContainer1 = ContainerCell.fromNib()
    private let cellContainer2 = ContainerCell.fromNib()
    private let cellContainer3 = ContainerCell.fromNib()
    private let cellContainer4 = ContainerCell.fromNib()
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = characterViewModel.name
        self.tableView.registerNib(for: CharacterCell.self)
        self.tableView.registerNib(for: ContainerCell.self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.addGestureRecognizer(tap)
        
        self.cellCharacter.viewModel = self.characterViewModel
        self.cellCharacter.delegate = self
        self.cellContainer1.set(title: "Comics")
        self.cellContainer2.set(title: "Events")
        self.cellContainer3.set(title: "Stories")
        self.cellContainer4.set(title: "Series")
        self.dataSource.append(self.cellCharacter)
        
        self.getComics()
        self.getEvents()
        self.getSeries()
        self.getStories()
        
        self.dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    @objc func handleTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getComics() {
        if let url = characterViewModel.comics?.collectionURI {
            self.dispatchGroup.enter()
            self.linkRequest.url = url
            
            NetworkManagerNew().response(with: self.linkRequest, page: 0, onSuccess: { [weak self] (data) in
                if data.results.count > 0 {
                    self?.cellContainer1.viewModel = data.results.map({ return ComicViewModel(result: $0)})
                    if let cell = self?.cellContainer1 {
                        self?.dataSource.append(cell)
                    }
                }
            }, onError: { (error) in
                print(error)
            }) { [weak self] in
                self?.dispatchGroup.leave()
            }
        }
    }

    func getEvents() {
        if let url = characterViewModel.events?.collectionURI {
            self.dispatchGroup.enter()
            
            var request = Request.Link()
            request.url = url
            
            NetworkManagerNew().response(with: request, page: 0, onSuccess: { [weak self] (data) in
                if data.results.count > 0 {
                    self?.cellContainer2.viewModel = data.results.map({ return ComicViewModel(result: $0)})
                    if let cell = self?.cellContainer2 {
                        self?.dataSource.append(cell)
                    }
                }
                }, onError: { (error) in
                    print(error)
            }) { [weak self] in
                self?.dispatchGroup.leave()
            }

        }
    }

    func getStories() {
        if let url = characterViewModel.stories?.collectionURI {
            self.dispatchGroup.enter()
            
            var request = Request.Link()
            request.url = url
            
            NetworkManagerNew().response(with: request, page: 0, onSuccess: { [weak self] (data) in
                if data.results.count > 0 {
                    self?.cellContainer3.viewModel = data.results.map({ return ComicViewModel(result: $0)})
                    if let cell = self?.cellContainer3 {
                        self?.dataSource.append(cell)
                    }
                }
                }, onError: { (error) in
                    print(error)
            }) { [weak self] in
                self?.dispatchGroup.leave()
            }

        }
    }

    func getSeries() {
        if let url = characterViewModel.series?.collectionURI {
            self.dispatchGroup.enter()
            
            var request = Request.Link()
            request.url = url
            
            NetworkManagerNew().response(with: request, page: 0, onSuccess: { [weak self] (data) in
                if data.results.count > 0 {
                    self?.cellContainer4.viewModel = data.results.map({ return ComicViewModel(result: $0)})
                    if let cell = self?.cellContainer4 {
                        self?.dataSource.append(cell)
                    }
                }
                }, onError: { (error) in
                    print(error)
            }) { [weak self] in
                self?.dispatchGroup.leave()
            }

        }
    }
    
}

extension DetailsViewController: FavouriteCharacterDelegate {
    func favouriteCharacterButtonPressed() {
        self.delegate?.favouriteCharacterButtonPressed()
    }
}
