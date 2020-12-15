//
//  SearchCities.swift
//  Weather_App
//
//  Created by Roman Kantor on 2020-11-25.
//  Copyright © 2020 Roman Kantor. All rights reserved.
//

import UIKit

protocol addNewFavoriteLocationProtocol {
    func addNewFavoriteLocationDidFinish(location: Location)
}

class SearchCities: UITableViewController {
    var myModel : DataModelManager?
    
    // protocol instance
    var delegate : addNewFavoriteLocationProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.myModel?.searchResult = []
    }
    
            
    // number of table columns
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // number of table rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myModel?.searchResult.count ??  0
    }

    // populating table cells with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "citySearchCell", for: indexPath)
       
       
        if let location = myModel?.searchResult[indexPath.row]{
            cell.textLabel?.text = location.city
            cell.detailTextLabel?.text = location.country
        }
       
       return cell
    }
    
    // cell clicked
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteLocation = self.myModel?.searchResult[indexPath.row] ?? Location()
        showAction(favLocation: favoriteLocation)
    }

}

// Extension for SEARCH -----------------------
extension SearchCities : UISearchBarDelegate {
    
    func parseLocation (results: [String]) {
       
       // itterate through returned array of strings and populate the location class with the results
       for result in results {
          
          var tempLocation : Location = Location()

          // extract city
          let index = result.firstIndex(of: ",")
          var charsToDrop = result.distance(from: index ?? result.startIndex, to: result.endIndex)
          var substr = result.dropLast(charsToDrop)
          tempLocation.city = String(substr)
          
          //extract country
          charsToDrop = result.count - charsToDrop + 1
          substr = result.dropFirst(charsToDrop)
          tempLocation.country = String(substr)

          // append location to search result
          self.myModel?.searchResult.append(tempLocation)
       }

}
       
    // auto completion search bar for the lcoations
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
       
        // make link accept spaces in the key
        let imporvedSearch = searchText.replacingOccurrences(of: " ", with: "%20")
       
        myModel?.fetchLocation(key: imporvedSearch) { (results) in
             DispatchQueue.main.async {
              
               // reset the Location array every time search text changes
               self.myModel?.searchResult = []
               
               // check if the returned result contains valid data
               if results[0] != "%s" {
                   self.parseLocation(results: results)
               }
               else {
                   self.myModel?.searchResult = []
               }

              // reload the table
              self.tableView.reloadData()
             }
       }
    }
}

// Extension for Action Sheet
extension SearchCities {
    // Action Sheet setup
    func showAction(favLocation: Location) {
         
         // Configuring action sheet buttons
         let cancelAction = UIAlertAction(title: "Keep Browsing", style: .default) { (alert) in
             //do nothing
         }
         
         let saveAction = UIAlertAction(title: "Save", style: .default) { (alert) in
            self.delegate?.addNewFavoriteLocationDidFinish(location: favLocation)
            self.navigationController?.popViewController(animated: true)
         }
     
         let actionSheet = UIAlertController(title: "Confirm", message: "Save \(favLocation.city), \(favLocation.country)?", preferredStyle: .actionSheet)
         actionSheet.addAction(saveAction)
         actionSheet.addAction(cancelAction)
         self.present(actionSheet, animated: true, completion: nil)
     }
}
