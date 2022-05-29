//
//  ModelPage.swift
//  Zalo-Feed-Exercise
//
//  Created by Bui Anh Lap on 30/05/2022.
//

import Foundation

class ModelPage {
    var currentPage = 1
    var perPage = 20
    
    func loadMore() {
        currentPage += 1
    }
}
