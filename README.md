# MovieCatalog

Assumptions :
1 - the url API provides data for San Francisco City listing the locations of the movies.

2 - The API doesn't need auth token.

Project Structure:
Project is segregated into classes for Model[coredata], LocationManager[Map], NetworkLayer[JSON download], View and ViewController

Model:
CoreDataManager class contains  the logic to fetch,save,delete the managedobjects from the coredata.
MovieCatalogCoreData - is the coredata file, which maintians the entities for MovieCatalog

Utility -
Constants structure maintains necessary strings to be used across files

Location:
MovieLocationViewController class receives the details of location when user clicks on the cell in the movie list view. It converts the string address into map using CLGeocoder.
[ city,state and zip are assumed as constants]

Network:
NewtworkSession initatiates the data download task from the API Endpoint and notifiies the coredatamanager once download is successful.

MovieCatalogTableViewController class fetches data from coredata using NSFetchedResultsController and provides the list in tableview .


