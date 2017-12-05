//
//  MovieCatalogTableViewController.swift
//  MovieCatalog
//
//  Created by vlaghane on 12/2/17.
//  Copyright © 2017 Drones. All rights reserved.
//

import UIKit
import CoreData

let url = "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD"

class MovieCatalogTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
 
    var catalogArray = Array<Any>()
    let urlsession = NewtworkSession()
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        let movieName = NSSortDescriptor(key: "movieName", ascending: true)
        //let lastNameSort = NSSortDescriptor(key: "lastName", ascending: true)
        request.sortDescriptors = [movieName]
        
        let moc =  CoreDataManager.sharedInstance.persistentContainer.viewContext//newBackgroundContext()// .managedObjectContext
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent  = moc
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: privateMOC, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self as? NSFetchedResultsControllerDelegate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeFetchedResultsController()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDataCatalog),
            name: NSNotification.Name(rawValue: Constants.notificationCoreDataUpdated),
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
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
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
        let size =  self.fetchedResultsController.fetchedObjects?.count //catalogArray.count
        return size!
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMovieCell", for: indexPath) as! MovieCatalogCell
        //cell.cellLabel.text = "\(indexPath.row)"
        processCell(index: indexPath.row, cell: cell )
        // Configure the cell...
        return cell 
    }
   
    func processCell(index: Int, cell: MovieCatalogCell){
 
        if self.fetchedResultsController.fetchedObjects!.count > 0{
       // if (catalogArray.count > 0 && index < catalogArray.count){
            
            catalogArray = self.fetchedResultsController.fetchedObjects!
            var  catalogDetails = catalogArray[index] as! MovieDetails//as! Array<Any>
            //catalogDetails = self.fetchedResultsController[index]
            let movieName = catalogDetails.movieName// ["movieName" ]//  catalogDetails[8] as? String
            let location = catalogDetails.location//["location"]//[10] as? String
            
            if(movieName != nil &&  !(movieName?.isEmpty)! ){
                cell.cellLabel.text = movieName
            }
            if( location != nil && !(location?.isEmpty)!){
                 cell.location.text = location
            }
        }
    }
  
     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
//    - (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath;
//
//    func controllerdid
    
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return fetchedResultsController.sections!.count
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let sections = fetchedResultsController.sections else {
//            fatalError("No sections in fetchedResultsController")
//        }
//        let sectionInfo = sections[section]
//        return sectionInfo.numberOfObjects
//    }
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
