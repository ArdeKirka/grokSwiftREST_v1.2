//
//  GistRouter.swift
//  grokSwiftREST
//
//  Created by Christina Moulton on 2016-04-02.
//  Copyright © 2016 Teak Mobile Inc. All rights reserved.
//

import Foundation
import Alamofire

enum GistRouter: URLRequestConvertible {
  static let baseURLString:String = "https://api.github.com/"
  
  case GetPublic() // GET https://api.github.com/gists/public
  case GetMyStarred() // GET https://api.github.com/gists/starred
  case GetAtPath(String) // GET at given path
  
  var URLRequest: NSMutableURLRequest {
    var method: Alamofire.Method {
      switch self {
      case .GetPublic, .GetAtPath, .GetMyStarred:
        return .GET
      }
    }
    
    let url:NSURL = {
      // build up and return the URL for each endpoint
      let relativePath:String?
      switch self {
        case .GetAtPath(let path):
          // already have the full URL, so just return it
          return NSURL(string: path)!
        case .GetPublic():
          relativePath = "gists/public"
        case .GetMyStarred:
          relativePath = "gists/starred"
      }
      
      var URL = NSURL(string: GistRouter.baseURLString)!
      if let relativePath = relativePath {
        URL = URL.URLByAppendingPathComponent(relativePath)
      }
      return URL
    }()
    
    let params: ([String: AnyObject]?) = {
      switch self {
      case .GetPublic, .GetAtPath, .GetMyStarred:
        return nil
      }
    }()
    
    let URLRequest = NSMutableURLRequest(URL: url)
    
    let username = "myUsername"
    let password = "myPassword"
    
    let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
    let base64Credentials = credentialData.base64EncodedStringWithOptions([])
    URLRequest.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
    
    let encoding = Alamofire.ParameterEncoding.JSON
    let (encodedRequest, _) = encoding.encode(URLRequest, parameters: params)
    
    encodedRequest.HTTPMethod = method.rawValue
    
    return encodedRequest
  }
}
