//
//  MovieCatalogTableViewController.swift
//  MovieCatalog
//
//  Created by vlaghane on 12/2/17.
//  Copyright © 2017 Drones. All rights reserved.
//

import UIKit
let url = "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD"
class MovieCatalogTableViewController: UITableViewController {
 
    var catalogArray = Array<Any>()
    let urlsession = NewtworkSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDataCatalog),
            name: NSNotification.Name(rawValue: notificationDataDownload),
            object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        urlsession.dataRequest(urltoRequest: url )
    }
    
    
    @objc func updateDataCatalog(){
        
        catalogArray = urlsession.dataArray
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let size = catalogArray.count
        return size
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMovieCell", for: indexPath) as! MovieCatalogCell
        //cell.cellLabel.text = "\(indexPath.row)"
        processCell(index: indexPath.row, cell: cell )
        // Configure the cell...
        return cell 
    }
   
    func processCell(index: Int, cell: MovieCatalogCell){
        if (catalogArray.count > 0 && index < catalogArray.count){
            
            let catalogDetails = catalogArray[index] as! Array<Any>
            let movieName = catalogDetails[8] as? String
            let location = catalogDetails[10] as? String
            
            if(movieName != nil &&  !(movieName?.isEmpty)! ){
                
                cell.cellLabel.text = movieName
               
            }
            if( location != nil && !(location?.isEmpty)!){
                
                 cell.location.text = location
            }
        }
        
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == Constants.locationSegueIdentifier,let selectedCell = sender as? MovieCatalogCell {
            guard let locationController = segue.destination as? MovieLocationViewController  else {
                    return
            }
            locationController.locationAddress =  selectedCell.location.text ?? "location"
        }
            
    }
 

}
