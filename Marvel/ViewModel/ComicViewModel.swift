//
//  ComicViewModel.swift
//  Marvel
//
//  Created by Bruno Silva on 03/01/2019.
//

import Foundation

struct ComicViewModel {
    
    let title: String?
    let issueNumber: String?
    let thumbnail: Thumbnail
    
    init(result: Result) {
        self.title = result.title
        self.thumbnail = result.thumbnail
        if let issueNumber = result.issueNumber {
            self.issueNumber = "Issue number #\(issueNumber)"
        } else {
            self.issueNumber = ""
        }
    }
}
