//
//  PokemonDetailVC.swift
//  PokeDax
//
//  Created by Sergiy Lyahovchuk on 13.07.17.
//  Copyright © 2017 HardCode. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDefense: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblPokeID: UILabel!
    @IBOutlet weak var lblAttack: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var lblEvo: UILabel!
    
    var pokemon: Pokemon!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblName.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        lblPokeID.text = "\(pokemon.pokedexId)"
        
        pokemon.downloadPokemonDetail {
            self.updateUI()
        }
    }

    // MARK: - IBActions
    
    @IBAction func onBtnBackPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Private
    
    func updateUI() {
        lblAttack.text = pokemon.attack
        lblDefense.text = pokemon.defense
        lblType.text = pokemon.type
        lblWeight.text = pokemon.weight
        lblHeight.text = pokemon.height
        lblDescription.text = pokemon.description
        if pokemon.nextEvolutionId == "" {
            lblEvo.text = "No evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let str = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            lblEvo.text = str
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
