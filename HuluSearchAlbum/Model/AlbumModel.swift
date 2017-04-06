//
//  AlbumModel.swift
//  HuluSearchAlbum
//
//  Created by Daiyu Zhang on 4/2/17.
//  Copyright © 2017 Daiyu Zhang. All rights reserved.
//

import UIKit

class AlbumModel: NSObject {
    var images : [[String: Any]]?
    var name : String = ""
    
    init(dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
