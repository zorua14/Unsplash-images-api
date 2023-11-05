//
//  ImagesViewModel.swift
//  Unsplash-Images
//
//  Created by Karthikeyan Muthu on 31/10/23.
//

import Foundation
class ImagesViewModel{
    //static let shared = ImagesViewModel()
    func getImages(_ page:Int,_ vc:ImagesViewController,_ refreshing: Bool = false)
    {
        APIHandler.shared.sendRequest( page, vc,refreshing)
    }
    func getFilteredImages(_ page: Int,_ vc:ImagesViewController,_ topic:String)
    {
        APIHandler.shared.filterAPI(page, vc, topic)
    }
}
