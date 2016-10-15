//
//  PlacesViewController.swift
//  Memorable Places
//
//  Created by Noy Hillel on 15/04/2016.
//  Copyright © 2016 Inscriptio. All rights reserved.
//

import UIKit

// Global variable
// Storing it as an array of Dictionaries, which will store a place and a name
var places = [Dictionary<String, String>()]
// Setting the activePlace, default at -1
var activePlace = -1

class PlacesViewController: UITableViewController {

    // Getting our table
    @IBOutlet var table: UITableView!
    
    // We want to use the viewDidAppear method, as viewDidLoad is only called when it's loaded not appears, that's crucial to this app
    override func viewDidAppear(_ animated: Bool) {
        // If our tempPlaces are saved in our "places" key as our Dictionary, set the places variable to that
        if let tempPlaces = UserDefaults.standard.object(forKey: "places") as?[Dictionary<String, String>] {
            places = tempPlaces
        }
        
        // If the places count is 1
        if places.count == 1 && places[0].count == 0 {
            // Remove it at 0th place
            places.remove(at:0)
            
            // Default name here
            places.append(["name":"Empire State Building","lat":"40.748717","lon":"-73.985664"]) // Default place
            // Of course save it as it loads/appears
            UserDefaults.standard.set(places, forKey: "places")
        }
        // Here we set the activePlace to -1 by default again
        activePlace = -1
        // Refresh the table
        table.reloadData()
    }
    
    // Our method for being able to edit the row, which is needed so we can delete it
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { return true }
    
    // Our delete function
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // Checking if the style is deleting
        if editingStyle == UITableViewCellEditingStyle.delete {
            // Delete it
            places.remove(at: indexPath.row)
            // "Save" that delete
            UserDefaults.standard.set(places, forKey: "places")
            // Refresh the table
            table.reloadData()
        }
    }

    // MARK: - Table view data source

    // We only want one section
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    // Number of rows in our section, which varies, so we'll set it to the amount of places
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return places.count }

    // Our method for our prototype cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Getting our cell by its identifier
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        // If one exists
        if places[indexPath.row]["name"] != nil {
            // Set that text to the name of the place
            cell.textLabel?.text = places[indexPath.row]["name"]
        }
        // Return the cell
        return cell
    }
    
    // When they select the place
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Set the active variable place to the row in which they selected, which can't be -1 that's why setting "anything else" (Only our add button) to -1 was useful
        activePlace = indexPath.row
        // Perform the segue, parsing the identifier of 'toMap' which we made
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    // Util methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
        * This is just other methods we have access to, may as well keep it here
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
