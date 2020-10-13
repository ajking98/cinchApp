//
//  Helpers.swift
//  Cinch
//
//  Created by Ahmed Gedi on 10/11/20.
//  Copyright © 2020 Gedi, Ahmed M. All rights reserved.
//

import Foundation


struct Helpers {
    
    ///Finds synonyms for given word
    static func findSynonyms(word: String, completion: @escaping(Set<String>) -> Void){
        var synonymSet: Set = Set<String>()
        
        guard let url = URL(string: "https://tuna.thesaurus.com/pageData/\(word)") else { return }
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
//            print(String(data: data, encoding: .utf8)!)
            guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:AnyObject] else { return }
            guard let jsonData = json["data"] as? [String: AnyObject] else { return }
            guard let definitionData = jsonData["definitionData"] as? [String: Any] else { return }
            guard let definitions = definitionData["definitions"] as? [[String: Any]] else { return }
            
            for definition in definitions {
                guard let synonyms = definition["synonyms"] as? [[String: Any]] else { return }
                for synonymDict in synonyms {
                    
                    guard let similarity = synonymDict["similarity"] as? String else { return }
                    guard let term = synonymDict["term"] as? String else { return }
                    if let similarityInt = Int(similarity) {
                        if similarityInt >= 50 {
                            synonymSet.insert(term)
                        }
                    }
                }
            }
            completion(synonymSet)
        }
        
        task.resume()
    }
}
