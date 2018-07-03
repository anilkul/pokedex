//
//  ViewController.swift
//  pokedex
//
//  Created by Mehmet Anıl Kul on 9.08.2017.
//  Copyright © 2017 Mehmet Anıl Kul. All rights reserved.
//

import UIKit
import AVFoundation //muzik icin

//Kullanacagimiz Collection View Protokollerini girelim
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemonList = [Pokemon]() //pokemon isminde bir array olusturduk
    var filteredPokemonList = [Pokemon]() //arama sonucunda cikacak liste
    var inSearchMode = false //searchbar'a bir sey girildi ise aktive olacak boolean. Arama aktif ise filteredPokemonList'i goster gibi komutlar verecegiz
    var musicPlayer: AVAudioPlayer!

    // segue olustururken TableView Cell'den degil de generic olarak ana VC'den segue olusturmaliyiz. TableView Cell'den segue alirsan data aktarimi yapamayiz cunku segue kodun kendisinden degil de ViewController'dan cagirilmis olur.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //protokolleri aktive edelim
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done // klavyedeki search butonunun ismini done yaptik
        
        parsePokemonCSV()
        initAudio()
    }
    
    func initAudio() {
        let musicPath = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: musicPath)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 // -1 loop surekli devam edecek anlamina gelir
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    //pokemon.csv dosyasindan bilgileri alalim
    func parsePokemonCSV() {
        
        // csv bundle'imizi tanitalim. pokemon.csv icin yol belirttik
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            //CSV dosyamizi, Mark Price'in yadigi CSV classi yardimi ile aliyoruz
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows //classtaki row metodunu kullanarak tum rowlari cekiyoruz
            
            //her row'dan id ve identifier key'lerini alalim
            for row in rows {
                let pokeId = Int(row["id"]!)! //force unwrap
                let name = row["identifier"]!
                
                // aldigimiz degerleri Pokemon classinda tanimli poke degiskenine esitleyelim
                let poke = Pokemon(name: name, pokedexID: pokeId)
                
                //pokemonList arrayimize pokemonumuzu ekleyelim
                pokemonList.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //yuklenecek cell kismini ayarla. dequeue, queue'yi boz anlaminda. Tum cell'ler bir anda yuklenmeye calisilirsa crash aliriz.
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            
            let pokemonInList: Pokemon!
            
            if inSearchMode {
                pokemonInList = filteredPokemonList[indexPath.row]
                
                // View Classimizda tanimli configureCell fonksiyonunu kullanarak UI'a bilgileri yolluyoruz
                cell.configureCell(pokemonInList)
                
            } else {
                // pokemonInList degiskeninin bilgilerini Pokemon Model Class'i ile arrayden cekiyoruz.
                pokemonInList = pokemonList[indexPath.row]
                cell.configureCell(pokemonInList)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    //Itemi sectigimizde islem yapilabilmesini saglayan fonksiyon didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pokemonDetail: Pokemon!
        if inSearchMode {
            pokemonDetail = filteredPokemonList[indexPath.row]
        } else {
            pokemonDetail = pokemonList[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailSegue", sender: pokemonDetail)
        
    }
    //CV'de kac item olacak
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemonList.count
        }
        return pokemonList.count
    }
    
    // kac CV section'i var
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    // Background music icin on off tusu kontrolcusunu yazalim
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2 // pause iken transparency 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0 // caliyor iken transparency 1.0
        }
    }
    
    // Klavyeden search'e basildiginda klavye kapansin
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // textDidChange ile searchbar icerisindeki degisiklik direk algilanip es zamanli arama yapilir
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData() // searchbar bos ise ve yazilan silindi ise CV'u geri eski haline dondur
            view.endEditing(true) //klavyeyi kapatmak icin
        } else {
            inSearchMode = true
        
            // else'den once searchBar'da bir eleman olmasini garantiledigimiz icin searchbar.text!'de unlem koyduk. Tum karakterleri lowercase yapiyoruz bu sekilde arama islemi daha accurate olacak
            let lower = searchBar.text!.lowercased()
            
            // filteredPokemonList'imiz, normal pokemon listesinde, Pokemon modelinde belirtilmis name elemaninlari icerisinde lower degiskenini(yani girdigimiz arama metnini) icerenlerin filtrelenmesi ile olusturulmus bir array
            filteredPokemonList = pokemonList.filter({$0.name.range(of: lower) != nil})
            collection.reloadData() // CV'u resetle
            
        }
    }
    
    //segue'ye hazirlan, anyObject gonderilebiliyor
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "PokemonDetailSegue" {
            //destination VC'si PokemonDetailVC olan ve segue ile gecis yapilacak olan VC'yi detailsVC olarak tanimla
            if let detailsVC = segue.destination as? PokemonDetailVC {
                
                // gonderilen veri yani sender Pokemon class'ina ait bir sentPokemon degiskeni olsun
                if let sentPokemon = sender as? Pokemon {
                    
                    // segue ile gecis yapilacak olan VC'imiz yani detailsVC(PokemonDetailVC) icindeki pokemon degiskenini sentPokemon'a esitle
                    detailsVC.pokemon = sentPokemon
                }
            }
        }
    }
}

















