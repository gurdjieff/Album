//
//  AlbumVM.swift
//  HuluSearchAlbum
//
//  Created by Daiyu Zhang on 4/2/17.
//  Copyright © 2017 Daiyu Zhang. All rights reserved.
//

import UIKit

class AlbumVM: NSObject {
    lazy var albumGroup: [AlbumModel] = [AlbumModel]()
    
    func loadAlbumGroupData(URLString : String, parameters : [String : Any]? = nil, finishedCallback : @escaping () -> ()) {
        
        NetworkTool.request(type: .GET, urlString: URLString, paramters: parameters) { (result) in
            guard let dict = result as? [String : Any] else { return }
            guard let dictionary = dict["albums"] as? [String : Any] else { return }
            guard let array = dictionary["items"] as? [[String: Any]] else { return }
            for dict in array {
                self.albumGroup.append(AlbumModel(dict: dict))
            }
            
            finishedCallback()
        }
    }
}
