//
//  Pokemon.swift
//  PokeDax
//
//  Created by Sergiy Lyahovchuk on 12.07.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionName: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLevel: String!
    private var _pokemonURL: String!
    
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            return ""
        }
        return _nextEvolutionTxt
    }
    
    var attack: String {
        if _attack == nil {
            return ""
        }
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            return ""
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            return ""
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            return ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            return ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            return ""
        }
        return _description
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            return ""
        }
        return _nextEvolutionName
    }

    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            return ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            return ""
        }
        return _nextEvolutionLevel
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        Alamofire.request(_pokemonURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let dict = response.result.value as? [String: Any] {
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                if let height = dict["height"] as? String {
                    self._height = height
                }
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [[String: AnyObject]], types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] as? String {
                                self._type! += "/\(name.capitalized)"
                            }
                            
                            
                        }
                    }
                }
                
                if let descrArr = dict["descriptions"] as? [[String: AnyObject]], descrArr.count > 0 {
                    if let url = descrArr[0]["resource_uri"] as? String {
                        let descrUrl = "\(URL_BASE)\(url)"
                        Alamofire.request(descrUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                            if let descDict = response.result.value as? [String: AnyObject] {
                                if let description = descDict["description"] as? String {
                                    let newDescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newDescription
                                }
                            }
                            completed()
                        }
                    }
                }
                
                if let evolutions = dict["evolutions"] as? [[String: AnyObject]], evolutions.count > 0 {
                    if let nextEvo = evolutions[0]["to"] as? String {
                        if nextEvo.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvo
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = nextEvoId
                                
                                if let lvlExists = evolutions[0]["level"] {
                                    if let lvl = lvlExists as? Int {
                                        self._nextEvolutionLevel = "\(lvl)"
                                    }
                                }
                            }
                        }
                    }
                }
                
                print(self._weight)
                print(self._height)
                print(self._attack)
                print(self._defense)
            }
            
            completed()
        }
    }
}
