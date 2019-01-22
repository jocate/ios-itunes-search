//
//  SearchResultController.swift
//  iTunes Search
//
//  Created by Jocelyn Stuart on 1/22/19.
//  Copyright © 2019 JS. All rights reserved.
//

import Foundation

private let baseURL = URL(string: "https://itunes.apple.com/")!


class SearchResultController {
    
    var searchResults: [SearchResult] = []
    
    func performSearch(with searchTerm: String, andResult resultType: ResultType, completion:  @escaping ([SearchResult]?, Error?) -> Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        let searchQueryItem = URLQueryItem(name: "search", value: searchTerm)
        urlComponents.queryItems = [searchQueryItem]
        
        guard let requestURL = urlComponents.url else {
            NSLog("Problem constructing search URL for \(searchTerm)")
            completion(nil, NSError())
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("Error fetching data. No data returned.")
                completion(nil, NSError())
                return
            }
            
            do {
                let jsonDecoder = JSONDecoder()
                //jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedResults = try jsonDecoder.decode(SearchResults.self, from: data)
                self.searchResults = decodedResults.results
                completion(self.searchResults, nil)
            } catch {
                NSLog("Unable to decode data into people: \(error)")
                completion(nil, error)
                return
            }
            
        }
        dataTask.resume()
            
        }
    
    }

