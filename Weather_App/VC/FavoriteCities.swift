//
//  FavoriteCities.swift
//  Weather_App
//
//  Created by Roman Kantor on 2020-11-25.
//  Copyright © 2020 Roman Kantor. All rights reserved.
//

import UIKit

class FavoriteCities: UITableViewController, UISearchBarDelegate, addNewFavoriteLocationProtocol {
    
    var myModel : DataModelManager?
    var searchActive = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllFavLocations()
    }
    
    // get all the favorite locations and refresh the table
    func getAllFavLocations() {
        do {
           try CoreDataManager.shared.frc.performFetch()
        }catch {
            print("Fetching Error")
        }
        self.tableView.reloadData()
    }
    
    // implement the add new favorite location protocol
    func addNewFavoriteLocationDidFinish(location: Location) {
        let allFavLocations = CoreDataManager.shared.frc.fetchedObjects ?? [FavLocation]()
        CoreDataManager.shared.addLocation(location: location, allLocations: allFavLocations)
        getAllFavLocations()
    }
    
    // Search through favorite locations
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchText != ""{
            self.searchActive = true
            CoreDataManager.shared.frcSearch = CoreDataManager.shared.searchInFavorite(searchText: searchText)
            do {
               try CoreDataManager.shared.frcSearch.performFetch()
            }catch {
                print("Fetching Error")
            }
            self.tableView.reloadData()
        }
        else{
            self.searchActive = false
            getAllFavLocations()
        }
     }
    
    // Table view section begins---------------
        
    // number of table columns
    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchActive {
            return CoreDataManager.shared.frcSearch.sections?.count ?? 0

        }else{
            return CoreDataManager.shared.frc.sections?.count ?? 0
        }
    }

    // number of table rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return CoreDataManager.shared.frcSearch.sections?[section].numberOfObjects ??  0
        }else{
            return CoreDataManager.shared.frc.sections?[section].numberOfObjects ??  0
        }
    }

    // populating table cells with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        if searchActive {
            cell.textLabel?.text = CoreDataManager.shared.frcSearch.object(at: indexPath).city
            cell.detailTextLabel?.text = CoreDataManager.shared.frcSearch.object(at: indexPath).country
        }else{
            cell.textLabel?.text = CoreDataManager.shared.frc.object(at: indexPath).city
            cell.detailTextLabel?.text = CoreDataManager.shared.frc.object(at: indexPath).country
        }
       
        return cell
    }
    
    // provide header for sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchActive {
            return CoreDataManager.shared.frcSearch.sections?[section].indexTitle
        }else{
            return CoreDataManager.shared.frc.sections?[section].indexTitle
        }
    }
        
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
       
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
       if editingStyle == .delete {
        var locationToDelete : FavLocation?
        
        if searchActive {
            locationToDelete = CoreDataManager.shared.frcSearch.object(at: indexPath)
        }else{
            locationToDelete = CoreDataManager.shared.frc.object(at: indexPath)
            }
        
        CoreDataManager.shared.deleteLocation(favLocationToDelete: locationToDelete ?? FavLocation())
        getAllFavLocations()
       }
    }
    
    // prepare data before moving to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "searchLocation"{
            let searchCitiesVC = segue.destination as! SearchCities
            searchCitiesVC.delegate = self

            searchCitiesVC.myModel = self.myModel
        }
        else{
            let cityWeatherVC = segue.destination as! CityWeather

            if searchActive {
                cityWeatherVC.locationToDisplay = CoreDataManager.shared.frcSearch.object(at: (tableView?.indexPathForSelectedRow)!)
            }else{
                cityWeatherVC.locationToDisplay = CoreDataManager.shared.frc.object(at: (tableView?.indexPathForSelectedRow)!)
            }
            
            cityWeatherVC.myModel = self.myModel
        }

    }


}
