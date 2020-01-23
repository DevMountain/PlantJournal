//
//  PlantTypeListTableViewController.swift
//  PlantsGlobal
//
//  Created by Trevor Walker on 1/21/20.
//  Copyright © 2020 Trevor Walker. All rights reserved.
//

import UIKit

class PlantTypeListTableViewController: UITableViewController {
    //Where we will hold out plants
    var plants: [Plant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Creating Query Items
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "token", value: "WUhNT0J3citlNy9Qa3A2RldhcTJOUT09"),
            URLQueryItem(name: "completed_data", value: "true")]
        
        //Calling our API call
        PlantController.GetPlants(queryItems: queryItems) { (res) in
            
            //Handling the result
            switch res {
                //if success, then we set our local plants to the plants we received from the API call
            case .success(let receivedPlants):
                self.plants = receivedPlants
                //Reloads out tableview with the data we just received
                    //Using main.async becuase UIUpdates have to happen in the main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let err):
                print("Failed to get Plants: \(err.localizedDescription) --> \(err)")
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Sets the number of rows we have based on the number of plants we received
        return plants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath)
        //setting up cell
        //MARK:  break out the plant
        cell.textLabel?.text = plants[indexPath.row].commonName
        cell.detailTextLabel?.text = plants[indexPath.row].scientificName
        
        // Configure the cell...
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Checking which segue we are using
        if segue.identifier == "showPlant" {
            //unwraps our destination and grabbing the indexPath
            guard let destination = segue.destination as? PlantViewController, let indexPath = tableView.indexPathForSelectedRow?.row else {return}
            //sending out the plantID of the plant we tapped on to our PlantViewControllers.plantID
            destination.plantID = plants[indexPath].id
        }
    }
}
