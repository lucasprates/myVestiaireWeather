//
//  ForecastsTable.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 06/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit

class ForecastsTable: UITableViewController {
    
    private var forecastsViewModel: ForecastViewModel?
    private var selectedRow: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Do any additional setup after loading the view.
        self.forecastsViewModel = ForecastViewModel(withForecastDataUpdateReturnBlock: {
            self.tableView.reloadData()
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of sections (only one)
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return the number of rows (forecasts' count)
        return forecastsViewModel?.forecastsCount ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let forecatUnitCell = tableView.dequeueReusableCell(withIdentifier: "forecastUnitCell") as? ForecastCell
        
        forecatUnitCell?.fillCellUI(withViewModel: self.forecastsViewModel, atIndex: indexPath.row)
        return forecatUnitCell ?? tableView.dequeueReusableCell(withIdentifier: "blank", for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let forecastDetailedVC = segue.destination as? ForecastDetailed, let rowFilled = self.selectedRow {
                forecastDetailedVC.fillData(withForecastsViewModel: self.forecastsViewModel, andWithSelectedRow: rowFilled)
            }
        }
    }
 

}
