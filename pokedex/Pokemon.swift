//  Pokemon.swift
//  pokedex
//
//  Created by Mehmet Anıl Kul on 9.08.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    var typeArray: [String] = []
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _evoTxt: String!
    private var _nextEvoName: String!
    private var _baseEvoID: String!
    private var _nextEvoID: String!
    private var _lastEvoID: String!
    private var _nextEvoLvl: String!
    private var _lastEvoLvl: String!
    private var _pokemonURL: String!
    private var _pokemonDescriptionURL: String!
    
    
    var URL_POKEMON_EVOLUTION = ""
    
    var nextEvoName: String {
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var baseEvoID: String {
        if _baseEvoID == nil {
            _baseEvoID = ""
        }
        return _baseEvoID
    }
    
    var nextEvoID: String {
        if _nextEvoID == nil {
            _nextEvoID = ""
        }
        return _nextEvoID
    }
    
    var lastEvoID: String {
        if _lastEvoID == nil {
            _lastEvoID = ""
        }
        return _lastEvoID
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    var lastEvoLvl: String {
        if _lastEvoLvl == nil {
            _lastEvoLvl = ""
        }
        return _lastEvoLvl
    }
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
//    var typeArray: [String] {
//        if _typeArray == nil{
//            _typeArray = []
//        }
//        return _typeArray
//    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var evoTxt: String {
        if _evoTxt == nil {
            _evoTxt = ""
        }
        return _evoTxt
    }
    
    var pokemonURL: String {
        if _pokemonURL == nil {
            _pokemonURL = ""
        }
        return _pokemonURL
    }
    
    var pokemonDescriptionURL: String {
        if _pokemonDescriptionURL == nil {
            _pokemonDescriptionURL = ""
        }
        return _pokemonDescriptionURL
    }
    

    
    init(name:String, pokedexID:Int) {
        self._name = name
        self._pokedexID = pokedexID
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)/"
        self._pokemonDescriptionURL = "\(URL_BASE)\(URL_POKEMON_DESCRIPTION)\(self.pokedexID)/"
    }
    
    
    // Download JSON Detail
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        
        // Get base stats
        Alamofire.request(_pokemonURL).responseJSON {
            response in
            let result = response.result
            
            if result.isSuccess {
                let pokeJSON : JSON = JSON(result.value!)
                
                let weight = pokeJSON["weight"].intValue
                self._weight = String(weight)
                let height = pokeJSON["height"].intValue
                self._height = String(height)
                let attack = pokeJSON["stats"][4]["base_stat"].intValue
                self._attack = String(attack)
                let defense = pokeJSON["stats"][3]["base_stat"].intValue
                self._defense = String(defense)
                
                let type = pokeJSON["types"]
                let typeName = type[0]["type"]["name"].stringValue
                print("Type count: \(type.count)")
                self.typeArray.append(typeName.capitalized)
                
                // For multiple types
                if type.count > 1 {
                    for x in 1..<type.count {
                        let typeName = type[x]["type"]["name"].stringValue
                        self.typeArray.append(typeName.capitalized)
                    }
                }
                // Get Description
                Alamofire.request(self._pokemonDescriptionURL).responseJSON { (response) in
                    let result = response.result
                    if result.isSuccess {
                        let pokeJSON : JSON = JSON(result.value!)
                        print("description url: \(self._pokemonDescriptionURL)")
                        let description = pokeJSON["flavor_text_entries"][1]["flavor_text"].stringValue
                        print("Description: \(description)")
                        self._description = description
                        self.URL_POKEMON_EVOLUTION = pokeJSON["evolution_chain"]["url"].stringValue
                        print("Evo Cahin URL: \(self.URL_POKEMON_EVOLUTION)")
                    }
                    
                    // Get Evolution Chain
                    Alamofire.request(self.URL_POKEMON_EVOLUTION).responseJSON { (response) in
                        let result = response.result
                        if result.isSuccess {
                            let pokeJSON : JSON = JSON(result.value!)
                            
                            // Get Base Evolve
                            let baseEvoURL = pokeJSON["chain"]["species"]["url"].stringValue
                            // Trim url to get the next evolution ID
                            let baseEvoURLTrimmed = baseEvoURL.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                            let baseEvoIDCleared = baseEvoURLTrimmed.replacingOccurrences(of: "/", with: "")
                            print("Base Evo ID: \(baseEvoIDCleared)")
                            // Assign private var base Evo ID to trimmed ID
                            self._baseEvoID = baseEvoIDCleared
                            
                            // Get Next Evolve
                            let nextEvoURL = pokeJSON["chain"]["evolves_to"][0]["species"]["url"].stringValue
                            // Trim url to get the next evolution ID
                            let nextEvoURLTrimmed = nextEvoURL.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                            let nextEvoIDCleared = nextEvoURLTrimmed.replacingOccurrences(of: "/", with: "")
                            print("Next Evo ID: \(nextEvoIDCleared)")
                            // Assign private var last Evo ID to trimmed ID
                            self._nextEvoID = nextEvoIDCleared
                            
                            // Get Next Evo Level
                            let nextEvoLevel = pokeJSON["chain"]["evolves_to"][0]["evolution_details"][0]["min_level"].stringValue
                            print("Next Evo Level: \(nextEvoLevel)")
                            self._nextEvoLvl = nextEvoLevel
                            
                            // Get Last Evolve
                            let lastEvoURL = pokeJSON["chain"]["evolves_to"][0]["evolves_to"][0]["species"]["url"].stringValue
                            // Trim url to get the last evolution ID
                            let lastEvoURLTrimmed = lastEvoURL.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                            let lastEvoIDCleared = lastEvoURLTrimmed.replacingOccurrences(of: "/", with: "")
                            print("Last Evo ID: \(lastEvoIDCleared)")
                            // Assign private var last Evo ID to trimmed ID
                            self._lastEvoID = lastEvoIDCleared
                            
                            // Get Last Evo Level
                            let lastEvoLevel = pokeJSON["chain"]["evolves_to"][0]["evolves_to"][0]["evolution_details"][0]["min_level"].stringValue
                            print("Last Evo Level: \(lastEvoLevel)")
                            self._lastEvoLvl = lastEvoLevel
                            completed()
                        }
                    }
                    
                }
            }
            
            
            
        }
    }
}
