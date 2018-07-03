//
//  Constants.swift
//  pokedex
//
//  Created by Mehmet Anıl Kul on 13.08.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v2/pokemon/"
let URL_POKEMON_DESCRIPTION = "/api/v2/pokemon-species/"
//NOT: http kaynagindan veri almak icin info.plist'den app transport security settings ve altina allow arbitary loads = yes yapiyoruz

typealias DownloadComplete = () -> ()
