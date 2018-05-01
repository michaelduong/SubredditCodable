//
//  PostController.swift
//  Subreddit
//
//  Created by Michael Duong on 2/1/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import Foundation
import UIKit

class PostController {
    
    static let shared = PostController()
    
    let baseURL = URL(string: "https://reddit.com/r")!
    
    var posts = [Post]()
    
    func fetchPosts(by searchTerm: String, completion: @escaping ([Post]) -> Void) {
        
        let url = baseURL.appendingPathComponent(searchTerm).appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                print("Error fetching data \(error) \(error.localizedDescription)")
                completion([]); return
            }
            
            guard let data = data else { completion([] ); return }
            
            do {
                let jsonDictionary = try JSONDecoder().decode(JSONDictionary.self, from: data)
                let posts = jsonDictionary.data.children.flatMap{$0.post}
                completion(posts)
            } catch let error {
                print("Error decoding data \(error) \(error.localizedDescription)")
                completion([]); return
            }
        }.resume()
    }
    
    func fetchImage(at urlString: String, completion: @escaping(UIImage?) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            if let error = error {
                print("Error fetching thumbnails \(error) \(error)")
                completion(#imageLiteral(resourceName: "reddit-logo")); return
            }
            
            guard let data = data else { completion(#imageLiteral(resourceName: "reddit-logo")); return }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
