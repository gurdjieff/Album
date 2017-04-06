//
//  SearchAlbumVM.swift
//  HuluSearchAlbum
//
//  Created by Daiyu Zhang on 4/2/17.
//  Copyright © 2017 Daiyu Zhang. All rights reserved.
//

import UIKit

class SearchAlbumVM: AlbumVM {
    func requestData(keywords: String, finishedCallBack: @escaping () -> ()) {
        loadAlbumGroupData(URLString: "https://api.spotify.com/v1/search", parameters: ["q":keywords, "type":"album"], finishedCallback: finishedCallBack)
    }
}
