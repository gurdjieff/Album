//
//  NetworkTool.swift
//  HuluSearchAlbum
//
//  Created by Daiyu Zhang on 4/2/17.
//  Copyright © 2017 Daiyu Zhang. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case GET
    case POST
}

class NetworkTool {
    class func request(type: MethodType, urlString: String, paramters: [String: Any]? = nil, finishedCallback: @escaping (_ result: Any) -> ()) {
        // get type
        let method = type == .GET ? HTTPMethod.get : HTTPMethod.post
        // send request
        Alamofire.request(urlString, method: method, parameters: paramters).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            // call back
            finishedCallback(result as AnyObject)
        }
    }
}
