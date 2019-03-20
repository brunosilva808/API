//
//  CharacterViewModel.swift
//  Marvel
//
//  Created by Bruno Silva on 02/01/2019.
//

import Foundation

struct CharacterViewModel {
    
    let id: Int
    let name: String
    let thumbnail: Thumbnail
    let comics, series, events, stories: Comics?
    
    // Dependenct Injection (DI)
    init(result: Result) {
        self.id = result.id
        self.name = result.name ?? ""
        self.thumbnail = result.thumbnail
        self.comics = result.comics
        self.series = result.series
        self.events = result.events
        self.stories = result.stories
    }
}
