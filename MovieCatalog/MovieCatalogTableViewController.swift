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
    var fetchDataArray = Array<Any >()
    let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var sortOrder = false
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        let movieName = NSSortDescriptor(key: "movieName", ascending: true)
         
        request.sortDescriptors = [movieName]
        
        let moc = context
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
    
    
    @IBAction func sortButtonClicked(_ sender: Any) {
        var   tempA = catalogArray as? [MovieDetails]
        var tempB = Array<MovieDetails>()
        
        if tempA != nil && tempA?.count != 0 {
            for (index, element ) in (tempA?.enumerated())! {
                
                if (tempA?.count)! > index {
                    if element.movieName != nil{
                        tempB.append(element)
                    }
                }
            }
            if(sortOrder){
            catalogArray = tempB.sorted {$0.movieName!.localizedStandardCompare($1.movieName!) == .orderedAscending}
                sortOrder = false
            }else{
                catalogArray = tempB.sorted {$0.movieName!.localizedStandardCompare($1.movieName!) == .orderedDescending}
                sortOrder = true
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        urlsession.dataRequest(urltoRequest: url )
    }
    
    @objc func updateDataCatalog(){
        
        catalogArray = urlsession.dataArray
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        fetchDataArray = CoreDataManager.sharedInstance.fetchDataMovies()
        catalogArray = self.fetchedResultsController.fetchedObjects!
        
        if catalogArray.count == 0 {
            catalogArray = fetchDataArray
        }
        if catalogArray.count == 0{
            catalogArray = urlsession.dataArray
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
        let size =  catalogArray.count //self.fetchedResultsController.fetchedObjects?.count //
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
  
            catalogArray = self.fetchedResultsController.fetchedObjects!
            if catalogArray.count == 0 {
                catalogArray = fetchDataArray
            }
            if catalogArray.count == 0{
                catalogArray = urlsession.dataArray
            }
        
        var  movieName = ""
        var  location = ""
        if  let  catalogDetails = catalogArray[index] as? MovieDetails{
            if let  movie  = catalogDetails.movieName {movieName = movie }
            if let locate = catalogDetails.location { location = locate}
        }
        if let catalogDetails = catalogArray[index] as? Array<Any>
        {
            if let  movie   = (catalogDetails[8] as? String){movieName = movie }
           if let locate =  (catalogDetails[10] as? String) { location = locate}

        }
     

        
        if(movieName != nil &&  !(movieName.isEmpty) ){
                cell.cellLabel.text = movieName
            }
        if( location != nil && !(location.isEmpty)){
                 cell.location.text = location
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
