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

    var catalogArray = Array<Any>(){
        didSet{
            processMovieList(inArr:catalogArray)
        }
    }
    var flagHideLoadingView         = true
    var loadingView:LoadingView     = LoadingView()
    
    let urlsession          = NetworkSession()
    var fetchDataArray      = Array<Any >()
    let context             = CoreDataManager.sharedInstance.persistentContainer.viewContext
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    var sortOrder           = false
    var movieDict           = Dictionary<String,Any>()
    var movieDateDict           = Dictionary<String,Any>()
    var movieDArray         = Array<String>()

    
    @IBAction func sortButtonClicked(_ sender: Any) {
     
            if(sortOrder){
                movieDArray.sort()
                sortOrder = false
            }else{ 
                movieDArray.reverse()
                sortOrder = true
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeFetchedResultsController()
        setupLoadingIndicator(start:  true )
        updateDataCatalog()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateDataCatalog),
            name: NSNotification.Name(rawValue: Constants.notificationCoreDataUpdated),
            object: nil)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        urlsession.dataRequest(urltoRequest: url )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return 1
        if movieDArray.count > 0{
            setupLoadingIndicator(start: false)
        }
         return movieDArray.count//movieDict.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        let size =  catalogArray.count //self.fetchedResultsController.fetchedObjects?.count //
//        return size
        
        let arr = movieDict[movieDArray[section]] as! Array<Any>
        return arr.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMovieCell", for: indexPath) as! MovieCatalogCell
        //cell.cellLabel.text = "\(indexPath.row)"
        processCellinSection(index: indexPath.row, cell: cell, section: indexPath.section  )
        //processCell(index: indexPath.row, cell: cell )
        // Configure the cell...
        return cell 
    }
   
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if let date =  movieDateDict[movieDArray[section]] as? String{
            return movieDArray[section] + "," + "  Date:" + date
        }else {
            return movieDArray[section]
            
        }
        
    }
    
    func processCellinSection(index: Int, cell: MovieCatalogCell, section: Int ){
        
        var  movieName = ""
        var  location = ""
        
        var localArray = movieDict[ movieDArray[section]] as! Array<Any>
        
        
            if let  movie   = (movieDArray[section] as? String){movieName = movie }
            if let locate =  (localArray[index] as? String) { location = locate}
        
        if(  !(movieName.isEmpty) ){
            //cell.cellLabel.text = movieName
        }
        if(  !(location.isEmpty)){
            cell.location.text = location
        }
        
    }
    
    //fetched results controller delegate
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.reloadData()
    }
  
    func processMovieList(inArr: Array<Any> ){
        
        var localList = Array<Any>()
        
        if inArr.count > 0{
            
            _ = inArr[0]
            if let el = inArr[0] as? MovieDetails{
                var currentElement = el
                for(_, element) in inArr.enumerated(){
                    
                    if  let  catalogDetails = element  as? MovieDetails{
                        if let  movie  = catalogDetails.movieName {
                            if currentElement.movieName == movie{
                                localList.append(catalogDetails.location ?? "San Francisco")
                            }else {
                                movieDict[currentElement.movieName!] = localList
                                movieDateDict[currentElement.movieName!] =  currentElement.yearRelease
                                localList.removeAll()
                                localList.append(catalogDetails.location ?? "San Francisco")
                                currentElement = element as! MovieDetails
                                movieDArray.append(currentElement.movieName!)
                            }
                        }
                    }
                }
            }else if let el = inArr[0] as? Array<Any>{
                var lastElement = el as? Array<Any >
 
                for(_, element) in inArr.enumerated(){
                    if  let  catalogDetails = element  as? Array<Any>{
                        if  let   movie = (lastElement![8] as? String) {
                             if let  movieCurrEl   = (catalogDetails[8] as? String){
                                if movieCurrEl  == movie   {
                                    if let locate =  (catalogDetails[10] as? String) {
                                        //location = locate
                                        localList.append(locate )
                                    }
                                }else {
                                    movieDict[ movieCurrEl  ] = localList
                                    localList.removeAll()
                                    if let locate =  (catalogDetails[10] as? String) {
                                        //location = locate
                                        localList.append(locate )
                                    }
                                    movieDateDict[movieCurrEl] =  catalogDetails[9] ?? ""
                                    lastElement = (element as? Array<Any >)
                                    movieDArray.append(movieCurrEl )
                                }
                            }
                        }
                    }
                }
            }
           
            movieDArray = Array( movieDict.keys)
            movieDArray.sort()
        }
    }
    

    ///
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
    
    //initialize fetched results controller
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: movieEntity)
        let movieName = NSSortDescriptor(key: "movieName", ascending: true)
        let moc = context
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent  = moc
        request.sortDescriptors = [movieName]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: privateMOC, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
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
 
    
    func setupLoadingIndicator(start: Bool ){
        if(start){
            var flagSubviewPresent = false
            
            for view in self.view.subviews{
                if view === self.loadingView {
                    DispatchQueue.main.async {
                        self.loadingView.isHidden = false
                        self.flagHideLoadingView = false
                    }
                    flagSubviewPresent = true
                    break
                }
            }
            if(!flagSubviewPresent ){
                self.loadingView = LoadingView(frame: self.view.frame)
                self.view.addSubview(self.loadingView)
                DispatchQueue.main.async {
                    self.loadingView.isHidden = false
                    self.flagHideLoadingView = false
                }
            }
        }
        else if(!start ){
            DispatchQueue.main.async {
                self.loadingView.stopSpinner()
                self.loadingView.isHidden  = true
                self.flagHideLoadingView = true
            }
        }
    }

}
