//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Mehmet Anıl Kul on 11.08.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var lastEvoImg: UIImageView!
    @IBOutlet weak var nextEvoLbl: UILabel!
    @IBOutlet weak var lastEvoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name.capitalized
        
        let img = UIImage(named: "\(pokemon.pokedexID)")
        
        mainImg.image = img
        currentEvoImg.image = img
        idLbl.text = "\(pokemon.pokedexID)"
        
        nextEvoImg.isHidden = true
        nextEvoLbl.isHidden = true
        lastEvoImg.isHidden = true
        lastEvoLbl.isHidden = true
        
        
        self.pokemon.downloadPokemonDetail {
            //buradaki kod network call bittiginde yani su durumda download bittiginde calisacak
            self.updateUI()
        }
    }
    
    func updateUI() {
        attackLbl.text = pokemon.attack
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = "\(pokemon.weight)"
        idLbl.text = "\(pokemon.pokedexID)"
        if !pokemon.typeArray.isEmpty {
            typeLbl.text = "\(pokemon.typeArray[0])"
        }
        
        descriptionLbl.text = pokemon.description
        print("Next Evolution ID: \(pokemon.nextEvoID)")
        print("Next Evolution Level: \(pokemon.nextEvoLvl)")
        if pokemon.nextEvoID == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            evoLbl.text = "Evolution Chain"
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoID)
            nextEvoLbl.isHidden = false
            nextEvoLbl.text = "Lv. \(pokemon.nextEvoLvl)"
            nextEvoImg.isHidden = false
            if pokemon.lastEvoID != "" {
                lastEvoLbl.isHidden = false
                lastEvoLbl.text = "Lv. \(pokemon.lastEvoLvl)"
                lastEvoImg.isHidden = false
                lastEvoImg.image = UIImage(named: pokemon.lastEvoID)
            }
        }
        
    }

    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }


}
